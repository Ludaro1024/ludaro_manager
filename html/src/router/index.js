import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),

  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('../components/sites/home.vue')
    },
    {
        path: "/job",
        name: "job",
        component: () => import("../components/sites/job.vue")
    },
    {
      path: "/farming",
      name: "farming",
      component: () => import("../components/sites/farming.vue")
    },
    {
      path: "/door",
      name: "door",
      component: () => import("../components/sites/door.vue")
    },
    {
      path: "/data",
      name: "data",
      component: () => import("../components/sites/data.vue")
    },
    {
      path: "/user",
      name: "user",
      component: () => import("../components/sites/user.vue")
    },
    {
      path: "/vehicle",
      name: "vehicle",
      component: () => import("../components/sites/vehicle.vue")
    },
    {
      path: "/society",
      name: "society",
      component: () => import("../components/sites/society.vue")
    },
    {
      path: "/interactions",
      name: "interactions",
      component: () => import("../components/sites/society.vue")
    },
    {
      path: "/wiki",
      name: "wiki",
      component: () => import("../components/sites/wiki.vue")
    }
  ]
})

export default router