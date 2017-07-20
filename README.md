# Forecaster
#### A dashboard showing the forecast and tides.

![Screenshot](https://github.com/w-p/forecaster/blob/master/screenshot.png)

The frontend is:
- written in `javascript`
- using `riot.js`
- packaged with `webpack`

The backend is:
- written in `python`
- using `falcon`
- running behind `gunicorn`
- proxied by `nginx`
- serviced by `runit`

Other stuff:
- Geo-coordinates: `maps.googleapis.com`
- Weather: `api.weather.gov`
- Images: `pexels.com`
- Icon font: `fontello.com`

### Getting started

General workflow:
- develop and test on x86
- commit
- clone on ARM
- build / push the container
- kick off the service that starts the container

The container runs on port 80. Data is loaded on intial access and refreshed every 30 seconds.

##### x86
Use this for development.
```
git clone https://github.com/w-p/forecaster.git

# build the frontend
cd forecaster/frontend
npm install

# build the container
cd ..
make clean
make build-x86
make run-x86

# if you're me, push the container
make push-x86
```

##### arm32v6
Use this for your ARM box.
```
git clone https://github.com/w-p/forecaster.git

# just build the container, the compiled frontend is in the repo
cd forecaster
make clean
make build-x86

# if you're me, push the container
make push-arm

# start it up
cp ./forecaster.service /etc/systemd/system/
systemctl enable forecaster
systemctl start forecaster
```

### License
MIT
