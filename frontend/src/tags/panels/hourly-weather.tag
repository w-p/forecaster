
<hourly-weather>
    <span class='time'>{ hour }:00</span>
    <i class={ get_condition_icon(text) }></i>
    <span class='temperature'>{ degrees }&deg{ units }</span>
    <span class='wind'>{ wind.speed } { wind.unit } { wind.direction }</span>

    <style type='postcss'>
        :scope
            display flex
            flex-direction column
            align-items center
            justify-content space-around
            width 100%
            height 100%
            color white
            padding 0.5rem
            font-family Lato
            background-color rgba(0, 0, 0, 0.5)
            [class^="icon-"]
                font-size 3vw
            .time
            .wind
            .temperature
                font-size 1.5vw
    </style>

    <script>
        this.degrees = this.opts.degrees || '';
        this.units = this.opts.units || '';
        this.hour = this.opts.hour || '';
        this.text = this.opts.text || '';
        this.wind = this.opts.wind || '';
        this.mixin('conditions');

        this.on('update', () => {
            console.log('hourly-weather updated');
            this.degrees = this.opts.degrees;
            this.units = this.opts.units;
            this.hour = this.opts.hour.toString();
            this.text = this.opts.text;
            this.wind = this.opts.wind;
        });
    </script>
</hourly-weather>
