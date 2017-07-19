
import riot from 'riot';
import 'riot-hot-reload';

import _ from 'lodash';
import request from 'axios';

import './tags/app/app.tag';
import { Client } from './mixins/client';
import { Conditions } from './mixins/conditions';

import { data } from './data'; // temporary


riot.mixin('conditions', Conditions);
riot.mixin('client', Client);
riot.mount(
    'app',
    {
        location: {
            city: 'Emerald Isle',
            state: 'NC'
        }
    }
);
