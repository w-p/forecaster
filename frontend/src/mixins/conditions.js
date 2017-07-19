
export const Conditions = function () {
    let default_icon = 'animate-spin icon-spinner';
    let default_image = 'cloudy.png';
    let condition_map = {
        'Fog': {
            icon: 'icon-waves',
            image: 'cloudy.png'
        },
        'Rain': {
            icon: 'icon-rain',
            image: 'rainy.png'
        },
        'Snow': {
            icon: 'icon-rain',
            image: 'snowy.png'
        },
        'Clear': {
            icon: 'icon-sun',
            image: 'clear.png'
        },
        'Sunny': {
            icon: 'icon-sun',
            image: 'clear.png'
        },
        'Mostly Cloudy': {
            icon: 'icon-cloud',
            image: 'cloudy-mostly.png'
        },
        'Partly Cloudy': {
            icon: 'icon-cloud-sun',
            image: 'cloudy-partly'
        },
        'Thunderstorms': {
            icon: 'icon-cloud-flash',
            image: 'stormy.png'
        }
    };
    this.get_condition_icon = (forecast) => {
        if (!forecast) {
            return default_icon;
        }
        for (let condition in condition_map) {
            if (forecast.includes(condition)) {
                return condition_map[condition].icon;
            }
        }
        return default_icon;
    };
    this.get_condition_image = (forecast) => {
        if (!forecast) {
            return default_image;
        }
        for (let condition in condition_map) {
            if (forecast.includes(condition)) {
                return condition_map[condition].image;
            }
        }
        return default_image;
    };
};
