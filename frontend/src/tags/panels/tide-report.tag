<tide-report>
    <div class='name'>{ name }</div>
    <div class='listing' each={ tide in tides }>
        <div class='tide-type'>{ tide.type }</div>
        <div class='tide-time'>{ get_time(tide.time) }</div>
    </div>

    <style type='postcss'>
        :scope
            display flex
            flex-direction column
            color white
            flex-grow 1
            font-family Lato
            .name
                font-weight normal
                padding 0.3rem
                overflow hidden
                font-size 1.25vw
                white-space nowrap
                text-overflow ellipsis
                background-color rgba(0, 0, 0, 0.7)
            .listing
                display flex
                flex-direction row
                flex-grow 1
                width 100%
                font-size 1vw
                padding-left 0.3rem
                background-color rgba(0, 0, 0, 0.3)
                div
                    padding 0.2rem 0
                .tide-type
                    min-width 20%
    </style>
    <script>
        this.name = this.opts.name || '';
        this.tides = this.opts.data.tides || [];

        this.on('update', () => {
            console.log('tide-report updated');
            this.name = this.opts.name;
            this.tides = this.opts.data.tides;
        });

        this.get_time = (time) => {
            let parts = time.split(' ');
            if (parts.length >= 2) {
                let time = parts[0];
                let ampm = parts[1];
                let hour = time.slice(0, time.length - 2);
                if (ampm == 'AM') {
                    if (hour.length == 1) {
                        hour = '0' + hour;
                    } else if (hour == '12') {
                        hour = '00';
                    }
                } else {
                    hour = parseInt(hour) + 12;
                }
                let minute = time.slice(time.length -2, time.length);

                if (parts.length < 3) {
                    return `${hour}:${minute}`;
                }
                let day = parts[2].substring(0, 3);
                return `${hour}:${minute} ${day}`;
            }
            return time;
        };
    </script>
</tide-report>
