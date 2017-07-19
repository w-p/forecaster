
import '../panels/tide-report.tag';
import '../panels/hourly-weather.tag';
import '../panels/current-weather.tag';

<app style={ get_background() }>
    <div class='weather-panels'>
        <current-weather
            city={ location.city }
            state={ location.state }
            degrees={ current.temp.degrees }
            units={ current.temp.units }
            text={ current.text }>
        </current-weather>
        <div class='weather-hourly'>
            <hourly-weather
                each={ item in forecast }
                degrees={ item.temp.degrees }
                units={ item.temp.units }
                hour={ item.hour }
                text={ item.text }
                wind={ item.wind }>
            </hourly-weather>
        </div>
    </div>
    <virtual if={ tides }>
        <div class='tide-panels'>
            <tide-report
                each={ data, name in tides }
                name={ name }
                data={ data }>
            </tide-report>
        </div>
    </virtual>

    <style type='postcss'>
        app
            display flex
            flex-direction row
            justify-content space-around
            position absolute
            top 0
            right 0
            bottom 0
            left 0
            width 100%
            background-size cover
            background-position center
            background-repeat no-repeat
            .weather-panels
                display flex
                flex-direction column
                width 100%
                height 100%
                padding 1rem
                .weather-hourly
                    display flex
                    flex-direction row
                    height 30%
            .tide-panels
                display flex
                flex-direction row
                flex-wrap wrap
                height 100%
                padding 1rem 1rem 1rem 0
                min-width 20%
                max-width 30%
                overflow-y scroll
                tide-report
                    width 50%
    </style>

    <script>
        this.mixin('client');
        this.mixin('conditions');
        this.current = {temp: {}};
        this.forecast = [];
        this.tides = [];
        this.location = this.opts.location;

        this.on('before-mount', () => {
            this.on_forecast(this.location.city, this.location.state, (res) => {
                this.current = res.data.forecast.shift();
                this.forecast = res.data.forecast.slice(0, 7);
                this.tides = res.data.tides;
                this.update();
            });
        });

        this.on('update', () => {
            console.log('app updated');
        });

        this.get_background = () => {
            let image = this.get_condition_image(this.current.text);
            return `background-image: url('./res/img/${image}')`;
        };
    </script>
</app>
