import {
  doGet,
  doDelete,
  doPost,
  doPatch,
} from '@/utils/api';
import { deleteCookie } from '@/utils/cookies';
import { useAuthStore } from '@/stores/auth';

const cookieNameSpace = import.meta.env.VITE_COOKIE_NAMESPACE;

/**
 * Log the user out by: update the Pinia Store, and remove cookies/local storage items
 */
export async function signOut() {
  const authStore = useAuthStore();

  try {
    await doDelete('signout');
  } finally {
    authStore.$reset();
    deleteCookie(`${cookieNameSpace}-auth`);
  }
}

/**
 * Setting all the appropriate info for logging in a user: localstorage/cookies and pinia states
 *
 * @param {object} user
 */
export function setSignedIn(user) {
  const authStore = useAuthStore();

  authStore.setUser(user);
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
 * Updates a user
 *
 * @returns {Promise}
 */
export async function updateUser({ new_password: password }) {
  return doPatch('api/v1/users', { password });
}

export async function sendContactEmail(email) {
  return doPost('contact', email);
}
