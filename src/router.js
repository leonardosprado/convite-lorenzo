import { createRouter, createWebHistory } from 'vue-router'
import Convite from './components/Convite.vue'
import ConviteScroll from './components/ConviteScroll.vue'
import Painel from './components/Painel.vue'

export default createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/',       component: Convite },
    { path: '/2',      component: ConviteScroll },
    { path: '/painel', component: Painel },
    { path: '/:pathMatch(.*)*', redirect: '/' },
  ],
})
