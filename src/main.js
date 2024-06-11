import {createApp} from 'vue'
import {createRouter} from 'vue-router'
import App from './App.vue'

const router = createRouter()

const app = createApp(App)

// bind
app.use(router).mount("#app")