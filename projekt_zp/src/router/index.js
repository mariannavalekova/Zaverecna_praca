import { createRouter, createWebHistory } from 'vue-router';
import { useLoginStore } from '@/stores/loginStore';

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomeView.vue')
  },
  {
    path: '/learn',
    name: 'learn',
    component: () => import('../views/LearnView.vue')
  },
  {
    path: '/play/:level_id',
    name: 'game',
    component: () => import('../views/GameView.vue')
  },
  {
    path: '/signin',
    name: 'signin',
    component: () => import('../views/SigninView.vue')
  },
  {
    path: '/admin-signin',
    name: 'admin-signin',
    component: () => import('../views/AdminSigninView.vue')
  },
  {
    path: '/registration',
    name: 'registration',
    component: () => import('../views/RegistrationView.vue')
  },
  {
    path: '/admin-registration',
    name: 'admin-registration',
    component: () => import('../views/AdminRegistrationView.vue')
  },
  {
    path: '/account',
    name: 'account',
    component: () => import('../views/AccountView.vue')
  },
  {
    path: '/teacher-dashboard',
    name: 'teacher-dashboard',
    component: () => import('../views/TeacherDashboardView.vue'),
    meta: { requiresTeacher: true }
  },
  {
    path: '/student-dashboard',
    name: 'student-dashboard',
    component: () => import('../views/StudentDashboardView.vue'),
    meta: { requiresStudent: true }
  },
  {
    path: '/admin-panel',
    name: 'admin-panel',
    component: () => import('../views/AdminPanelView.vue')
  },
  {
    path: '/chapter-creator',
    name: 'chapter-creator',
    component: () => import('../views/ChapterCreatorView.vue')
  },
  {
    path: '/level-creator',
    name: 'level-creator',
    component: () => import('../views/LevelCreatorView.vue')
  },
  {
    path: '/level-editor/:level_id',
    name: 'level-editor',
    component: () => import('../views/LevelEditorView.vue')
  },
  {
    path: '/article-creator',
    name: 'article-creator',
    component: () => import('../views/ArticleCreatorView.vue')
  }
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

router.beforeEach((to, from, next) => {
  const loginStore = useLoginStore();

  if (to.meta.requiresTeacher) {
    if (!loginStore.user_is_teacher) {
      next({ name: 'learn' });
      return;
    }
  }

  if (to.meta.requiresStudent) {
    if (loginStore.user_is_teacher) {
      next({ name: 'learn' });
      return;
    }
  }

  next();
});

export default router;
