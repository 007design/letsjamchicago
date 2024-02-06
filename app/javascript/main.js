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
import Checkbox from 'primevue/checkbox';
import Chip from 'primevue/chip';
import Column from 'primevue/column';
import ConfirmDialog from 'primevue/confirmdialog';
import DataTable from 'primevue/datatable';
import Dialog from 'primevue/dialog';
import Divider from 'primevue/divider';
import Dropdown from 'primevue/dropdown';
import InputGroup from 'primevue/inputgroup';
import InputGroupAddon from 'primevue/inputgroupaddon';
import InputText from 'primevue/inputtext';
import Listbox from 'primevue/listbox';
import Menu from 'primevue/menu';
import Message from 'primevue/message';
import OverlayPanel from 'primevue/overlaypanel';
import Panel from 'primevue/panel';
import TabView from 'primevue/tabview';
import TabPanel from 'primevue/tabpanel';
import Tag from 'primevue/tag';
import Textarea from 'primevue/textarea';
import Toast from 'primevue/toast';
import Tooltip from 'primevue/tooltip';

import ConfirmationService from 'primevue/confirmationservice';
import ToastService from 'primevue/toastservice';

// import { VueReCaptcha } from 'vue-recaptcha-v3';

// const apiKey = import.meta.env.VITE_GOOGLE_RECAPTCHA_KEY;

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
    app.use(ToastService);

    app.directive('tooltip', Tooltip);
    // app.use(VueReCaptcha, { siteKey: apiKey });

    app.component('Badge', Badge);
    app.component('Button', Button);
    app.component('Calendar', Calendar);
    app.component('Card', Card);
    app.component('Checkbox', Checkbox);
    app.component('Chip', Chip);
    app.component('Column', Column);
    app.component('ConfirmDialog', ConfirmDialog);
    app.component('DataTable', DataTable);
    app.component('Dialog', Dialog);
    app.component('Divider', Divider);
    app.component('Dropdown', Dropdown);
    app.component('InputGroup', InputGroup);
    app.component('InputGroupAddon', InputGroupAddon);
    app.component('InputText', InputText);
    app.component('Listbox', Listbox);
    app.component('Menu', Menu);
    app.component('Message', Message);
    app.component('OverlayPanel', OverlayPanel);
    app.component('Panel', Panel);
    app.component('TabView', TabView);
    app.component('TabPanel', TabPanel);
    app.component('Tag', Tag);
    app.component('Textarea', Textarea);
    app.component('Toast', Toast);

    app.mount('#app');
  });
};
