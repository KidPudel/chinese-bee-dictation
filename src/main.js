import {createApp} from 'vue'
import {createRouter, createMemoryHistory} from 'vue-router'
import App from './App.vue'

const routes = [
    {path: '/', component: App}
]

const router = createRouter({history: createMemoryHistory(), routes})

const app = createApp(App)

// bind
app.use(router).mount("#app")