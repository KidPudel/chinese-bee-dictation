import {createApp} from 'vue'
import {createRouter} from 'vue-router'
import App from './App.vue'

const routes = [
    {path: '/', component: App}
]

const router = createRouter(routes)

const app = createApp(App)

// bind
app.use(router).mount("#app")