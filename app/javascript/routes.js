import { setSignedIn } from '@/services/auth';
import { useAuthStore } from '@/stores/auth';
import { deleteCookie } from '@/utils/cookies';

/**
 * Direct user to sign in page depending on if user is authenticated and confirmed
 *
 * @param {object} to
 * @param {object} from
 * @param {Function} next
 */
async function requireAuth(to, from, next) {
  try {
    await setSignedIn();
    next();
  } catch {
    deleteCookie('auth');
    const authStore = useAuthStore();
    authStore.$reset();
    next({
      name: 'Home',
    });
  }
}

async function doGetUser(to, from, next) {
  const authStore = useAuthStore();

  if (!authStore.user) {
    try {
      await setSignedIn();
    } catch {
      deleteCookie('auth');
      authStore.$reset();
    } finally {
      next();
    }
  } else {
    next();
  }
}

export const routes = [
  {
    path: '/',
    component: () => import('@/views/MainView.vue'),
    children: [
      {
        path: '',
        name: 'Home',
        beforeEnter: doGetUser,
        component: () => import('@/views/events/UpcomingEventsView.vue'),
      },
      {
        path: '/event/:eventId',
        name: 'ShowEvent',
        beforeEnter: doGetUser,
        component: () => import('@/views/events/ShowEventView.vue'),
        props: true,
      },
      {
        path: 'about',
        name: 'About',
        beforeEnter: doGetUser,
        component: () => import('@/views/AboutView.vue'),
      },
      {
        path: 'new',
        name: 'NewEvent',
        beforeEnter: requireAuth,
        component: () => import('@/views/events/EditEventView.vue'),
      },
      {
        path: 'edit/:eventId',
        name: 'EditEvent',
        beforeEnter: requireAuth,
        component: () => import('@/views/events/EditEventView.vue'),
        props: true,
      },
      {
        path: 'clone/:eventId',
        name: 'CloneEvent',
        beforeEnter: requireAuth,
        component: () => import('@/views/events/EditEventView.vue'),
        props: true,
      },
      {
        path: 'events',
        name: 'MyEvents',
        beforeEnter: requireAuth,
        component: () => import('@/views/events/UserEventsView.vue'),
      },
      {
        path: 'attending',
        name: 'AttendingEvents',
        beforeEnter: requireAuth,
        component: () => import('@/views/events/AttendingEvents.vue'),
      },
      {
        path: 'account',
        name: 'AccountSettings',
        beforeEnter: requireAuth,
        component: () => import('@/views/auth/EditUserView.vue'),
      },
      {
        path: 'reset/:token',
        name: 'ResetPassword',
        component: () => import('@/views/auth/ResetPasswordView.vue'),
        props: true,
      },
    ],
  },
  {
    path: '/signin',
    name: 'SignIn',
    beforeEnter: doGetUser,
    component: () => import('@/views/auth/SignInView.vue'),
  },
  {
    path: '/signup',
    name: 'SignUp',
    beforeEnter: doGetUser,
    component: () => import('@/views/auth/RegisterView.vue'),
  },
  {
    path: '/forgot',
    name: 'ForgotPassword',
    beforeEnter: doGetUser,
    component: () => import('@/views/auth/ForgotPasswordView.vue'),
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    redirect: '/',
  },
];
