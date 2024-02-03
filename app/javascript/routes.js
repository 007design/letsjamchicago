import { setSignedIn } from '@/services/auth';

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
    next({
      name: 'Home',
    });
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
        component: () => import('@/views/events/UpcomingEventsView.vue'),
      },
      {
        path: 'about',
        name: 'About',
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
        component: () => import('@/views/auth/EditUserView.vue'),
        props: true,
      },
    ],
  },
  {
    path: '/signin',
    name: 'SignIn',
    component: () => import('@/views/auth/SignInView.vue'),
  },
  {
    path: '/signup',
    name: 'SignUp',
    component: () => import('@/views/auth/RegisterView.vue'),
  },
  {
    path: '/forgot',
    name: 'ForgotPassword',
    component: () => import('@/views/auth/ForgotPasswordView.vue'),
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    redirect: '/',
  },
];
