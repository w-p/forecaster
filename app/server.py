import re
import json
import falcon
import iso8601
import logging
import requests
from fuzzywuzzy import fuzz


logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
logger.addHandler(logging.StreamHandler())

geocode = 'https://maps.googleapis.com/maps/api/geocode/json?address={},{}'
weather = 'https://api.weather.gov/points/{},{}'
tides = 'https://api.weather.gov/products/types/TID/locations/{}'


def get_geocoordinates(city, state):
    logger.info('get_geocoordinates({}, {})'.format(city, state))
    url = geocode.format(city, state)
    res = requests.get(url, verify=False)
    logger.info('- google response: {}'.format(res.status_code))
    if res.status_code != 200:
        raise Exception(
            'request failed. code: {}, url: {}'.format(res.status_code, url)
        )
    data = res.json()
    coordinates = data['results'][0]['geometry']['location']
    result = (
        round(coordinates.get('lat'), 4), # need <= 4 decimal precision
        round(coordinates.get('lng'), 4)
    )
    return result

def get_weather(latitude, longitude):
    logger.info('get_weather({}, {})'.format(latitude, longitude))
    url = weather.format(latitude, longitude)
    res = requests.get(url, verify=False)
    logger.info('- noaa response: {}'.format(res.status_code))
    if res.status_code != 200:
        raise Exception(
            'request failed. code: {}, url: {}'.format(res.status_code, url)
        )
    data = res.json()
    properties = data.get('properties')
    result = (
        properties.get('cwa'), # locationId
        properties.get('forecastHourly') # hourly forecast url
    )
    return result

def get_forecast(url):
    if url is None:
        return []
    logger.info('get_forecast({})'.format(url))
    res = requests.get(url, verify=False)
    logger.info('- noaa response: {}'.format(res.status_code))
    if res.status_code != 200:
        raise Exception(
            'request failed. code: {}, url: {}'.format(res.status_code, url)
        )
    data = res.json()
    properties = data.get('properties')
    periods = sorted(
        properties.get('periods'),
        key=lambda x: x.get('number')
    )

    logger.info('- forecasts recieved: {}'.format(len(periods)))
    result = []

    for period in periods[0:12]:
        speed, unit = period.get('windSpeed').split(' ')
        forecast = {
            'name': period.get('name') or None,
            'hour': iso8601.parse_date(period.get('startTime')).hour,
            'temp': {
                'degrees': period.get('temperature'),
                'units': period.get('temperatureUnit')
            },
            'wind': {
                'speed': int(speed),
                'unit': unit,
                'direction': period.get('windDirection')
            },
            'text': period.get('shortForecast')
        }
        result.append(forecast)
    return result

def parse_tide_report(text):
    logger.info('parse_tide_report(<too long...>)')
    result = {}
    lines = text.split('\n')
    name_re = re.compile('(Tides\sfor\s(the\s)?)')
    tide_re = re.compile('(High|Low)\s+tide')
    temp_re = re.compile('.+(\.\.\.)')
    current_name = None
    logger.info('- lines to process: {}'.format(len(lines)))
    for line in lines:
        if re.match(name_re, line):
            index = re.search(name_re, line).end()
            name = line[index:].strip().replace(':', '')
            current_name = name
            result[name] = {
                'temp': None,
                'tides': []
            }
        elif re.match(tide_re, line):
            index = re.search(tide_re, line).end()
            time = line[index:].strip().replace('.', '')
            result[current_name]['tides'].append({
                'type': 'high' if 'High' in line else 'low',
                'time': time.replace('  ', ' ')
            })
        elif re.match(temp_re, line):
            index = re.search(temp_re, line).end()
            name = line[:index].replace('...', '')
            temp = line[index:].strip().replace('.', '')
            for key in result.keys():
                if fuzz.ratio(name, key) > 70:
                    result[key]['temp'] = int(temp)
    return result

def get_tide_report(location_id):
    if location_id is None:
        return {}
    logger.info('get_tide_report({})'.format(location_id))
    res = requests.get(tides.format(location_id), verify=False)
    logger.info('- noaa response: {}'.format(res.status_code))
    if res.status_code != 200:
        raise Exception(
            'request failed. code: {}, url: {}'.format(res.status_code, url)
        )
    data = res.json()
    features = data.get('features', None)
    if features:
        url = features[0]['@id']
        res = requests.get(url, verify=False)
        logger.info('- noaa response: {}'.format(res.status_code))
        data = res.json()
        return parse_tide_report(data.get('productText'))
    return None


class ForecastResource(object):
    def on_get(self, req, res, city, state):
        latitude, longitude = get_geocoordinates(city, state)
        logger.info('* latitude {}, longitude {}'.format(latitude, longitude))

        location_id, forecast_url = get_weather(latitude, longitude)
        logger.info('* location id: {}, forecast url: {}'.format(location_id, forecast_url))

        result = {
            'forecast': get_forecast(forecast_url),
            'tides': get_tide_report(location_id)
        }
        logger.info('* result:\n{}'.format(result))

        res.status = falcon.HTTP_200
        res.body = json.dumps(result)

app = falcon.API()
forecast = ForecastResource()
app.add_route('/api/forecast/{city}/{state}', forecast)
