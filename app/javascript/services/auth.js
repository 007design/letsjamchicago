import {
  doGet,
  doDelete,
  doPost,
  doPatch,
  doPut,
} from '@/utils/api';
import { useAuthStore } from '@/stores/auth';
import { deleteCookie } from '@/utils/cookies';

const cookieNameSpace = import.meta.env.VITE_COOKIE_NAMESPACE;

/**
 * Log the user out by: update the Pinia Store, and remove cookies/local storage items
 */
export async function signOut() {
  const authStore = useAuthStore();

  try {
    await doDelete('signout');
  } finally {
    deleteCookie(`${cookieNameSpace}-auth`);
    authStore.$reset();
  }
}

/**
 * Sign the user in.
 *
 * @param {string} email_address
 * @returns {object}
 */
export function signIn(user) {
  return doPost('signin', { user });
}

/**
 * Register a new user
 *
 * @param {object} form
 * @returns {Promise}
 */
export function signUp(user) {
  return doPost('signup', { user });
}

/**
 * Gets current user.
 *
 * @returns {Promise}
 */
export async function getUser() {
  return doGet('api/v1/users');
}

/**
 * Setting all the appropriate info for logging in a user: localstorage/cookies and pinia states
 *
 * @param {object} user
 */
export async function setSignedIn() {
  const authStore = useAuthStore();
  const user = await getUser();
  authStore.setUser(user);
}

/**
 * Updates a user
 *
 * @returns {Promise}
 */
export async function updateUser(user) {
  if (user.reset_password_token) {
    return doPut('reset', { user });
  }

  return doPatch('api/v1/users', { user });
}

/**
 * Send password reset email
 *
 * @returns {Promise}
 */
export async function forgotPassword(user) {
  return doPost('forgot', { user });
}

export async function sendContactEmail(email) {
  return doPost('contact', email);
}
