import { getCookie } from '@/utils/cookies';

const cookieNameSpace = import.meta.env.VITE_COOKIE_NAMESPACE;

/**
 * Direct user to sign in page depending on if user is authenticated and confirmed
 *
 * @param {object} to
 * @param {object} from
 * @param {Function} next
 */
function requireAuth(to, from, next) {
  const authCookie = getCookie(`${cookieNameSpace}-auth`);

  if (authCookie) {
    next();
  } else {
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
        component: () => import('@/views/UpcomingEventsView.vue'),
      },
      {
        path: '/new',
        name: 'NewEvent',
        beforeEnter: requireAuth,
        component: () => import('@/views/EventView.vue'),
      },
      {
        path: '/edit/:eventId',
        name: 'EditEvent',
        beforeEnter: requireAuth,
        component: () => import('@/views/EventView.vue'),
        props: true,
      },
      {
        path: '/events',
        name: 'MyEvents',
        beforeEnter: requireAuth,
        component: () => import('@/views/UserEventsView.vue'),
      },
    ],
  },
  {
    path: '/signin',
    name: 'SignIn',
    component: () => import('@/views/SignInView.vue'),
  },
  {
    path: '/signup',
    name: 'SignUp',
    component: () => import('@/views/RegisterView.vue'),
  },
];
