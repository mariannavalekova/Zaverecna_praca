import { createApp } from 'vue';

import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
import 'bootstrap';

import 'ckeditor5/ckeditor5.css';

import VueHighlightJS from '@highlightjs/vue-plugin';
import 'highlight.js/styles/vs.min.css';

import { createPinia } from 'pinia';
import VueKonva from 'vue-konva';
import App from './App.vue';
import router from './router';
import { useLoginStore } from './stores/loginStore';


const app = createApp(App);

app.use(createPinia());
app.use(router);
app.use(VueKonva);
app.use(VueHighlightJS);

const loginStore = useLoginStore();
loginStore.loadTokenFromLocalStorage();
loginStore.loadUserInfoFromLocalStorage();

app.mount('#app');
