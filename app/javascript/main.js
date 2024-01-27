/* eslint-disable vue/no-reserved-component-names */
/* eslint-disable vue/multi-word-component-names */
/* eslint-disable import/no-extraneous-dependencies */
import { createApp } from 'vue';
import {
  createPinia,
  PiniaVuePlugin,
} from 'pinia';
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate';
import PrimeVue from 'primevue/config';
import App from '@/App.vue';

import router from '@/router';

import 'normalize.css';
import 'primeflex/primeflex.css';
import 'primevue/resources/themes/aura-light-blue/theme.css';
import 'primeicons/primeicons.css';

import Badge from 'primevue/badge';
import Button from 'primevue/button';
import Calendar from 'primevue/calendar';
import Card from 'primevue/card';
import Chip from 'primevue/chip';
import Column from 'primevue/column';
import ConfirmDialog from 'primevue/confirmdialog';
import DataTable from 'primevue/datatable';
import Dialog from 'primevue/dialog';
import Divider from 'primevue/divider';
import Dropdown from 'primevue/dropdown';
import InputText from 'primevue/inputtext';
import Panel from 'primevue/panel';
import Tag from 'primevue/tag';
import Tooltip from 'primevue/tooltip';

import ConfirmationService from 'primevue/confirmationservice';

const pinia = createPinia();
pinia.use(piniaPluginPersistedstate);

export default () => {
  document.addEventListener('DOMContentLoaded', () => {
    const app = createApp(App);

    app.use(PiniaVuePlugin);
    app.use(pinia);
    app.use(router);
    app.use(PrimeVue);
    app.use(ConfirmationService);

    app.component('Badge', Badge);
    app.component('Button', Button);
    app.component('Calendar', Calendar);
    app.component('Card', Card);
    app.component('Chip', Chip);
    app.component('Column', Column);
    app.component('ConfirmDialog', ConfirmDialog);
    app.component('DataTable', DataTable);
    app.component('Dialog', Dialog);
    app.component('Divider', Divider);
    app.component('Dropdown', Dropdown);
    app.component('InputText', InputText);
    app.component('Panel', Panel);
    app.component('Tag', Tag);
    app.directive('Tooltip', Tooltip);

    app.mount('#app');
  });
};