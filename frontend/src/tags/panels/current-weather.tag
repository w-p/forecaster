
<current-weather>
    <div class='banner'>Current Conditions for { city }, { state }</div>
    <div class='condition'>
        <i class={ get_condition_icon(text) }></i>
        <span class='temperature'>{ degrees }&deg{ units }</span>
    </div>
    <div class='forecast'>{ text }</div>

    <style type='postcss'>
        :scope
            display flex
            flex-direction column
            justify-content space-between
            width 100%
            height 100%
            padding 1rem 3rem
            color white
            font-family Lato
            background-color rgba(0, 0, 0, 0.3)
            .banner
                width 100%
                font-size 3.2vw
            .condition
                display flex
                flex-direction row
                align-items center
                justify-content center
                width 100%
                font-size 10vw
                .temperature
                    font-size 14vw
                    font-weight lighter
            .forecast
                display flex
                justify-content flex-end
                height 20%
                font-size 2.5vw
    </style>
    <script>
        this.city = this.opts.city || '';
        this.state = this.opts.state || '';
        this.degrees = this.opts.degrees || '';
        this.units = this.opts.units || '';
        this.text = this.opts.text || '';
        this.mixin('conditions');

        this.on('update', () => {
            console.log('current-weather updated');
            this.degrees = this.opts.degrees;
            this.units = this.opts.units;
            this.text = this.opts.text;
        });
    </script>
</current-weather>
