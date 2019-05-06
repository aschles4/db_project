import Vue from 'vue'
import App from './App.vue'

import VueRouter from 'vue-router'

Vue.use(VueRouter)

import Login from './components/login.vue'
import Register from './components/register.vue'
import RequestRide from './components/requestRide.vue'

const routes = [
  { path: '/', component: Login, name: "login" },
  { path: '/register', component: Register, name: "regiser"},
  { path: '/requestRide', component: RequestRide, name: "requestRide"}
]

const router = new VueRouter({
  routes, // short for routes: routes
  mode: 'history'
})

new Vue({
  //define the selector for the root component
    el: '#app',
    //pass the template to the root component
    template: '<App/>',
    //declare components that the root component can access
    components: { App },
    //pass in the router to the Vue instance
    router,

    render: h => h(App)
  }).$mount('#app')
