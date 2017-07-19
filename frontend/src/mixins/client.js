
import request from 'axios';

export const Client = function () {
    let timer = null;
    let frequency = 30000;
    let query = (url, cb) => {
        request.get(url)
            .then((res) => {
                console.log('success:', url);
                cb(res);
            })
            .catch((err) => {
                console.log('failure:', url);
                cb(err);
            });
    };

    this.on_forecast = (city, state, cb) => {
        let url = '/api/forecast/' + city + '/' + state;
        if (this.timer) {
            clearTimeout(this.timer);
        }
        query(url, cb);
        this.timer = setInterval(
            () => {query(url, cb)},
            frequency
        );
    };
};
