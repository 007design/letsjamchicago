import axios from 'axios';
import { getCookie, setCookie } from '@/utils/cookies';

const domain = import.meta.env.VITE_DOMAIN;

/**
 * Helper method
 *
 * @param {string} method
 * @param {string} url
 * @param {string} payload
 * @param {string} config
 * @returns {object}
 */
async function doAxiosCall(
  method,
  url,
  payload = {},
) {
  try {
    const { data, headers } = await axios({
      method,
      url: `/${url}`,
      data: payload,
      headers: {
        Authorization: getCookie('auth'),
        'Access-Control-Allow-Origin': domain,
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").content,
      },
    });

    if (method === 'post' && headers.authorization) {
      setCookie('auth', headers.authorization);
    }
    return data;
  } catch (error) {
    const { data } = error.response;
    throw new Error(data.error);
  }
}

/**
 * Custom "get" that returns data or throws an error.
 *
 * @param {string} url
 * @returns {Promise}
 */
export async function doGet(url) {
  return doAxiosCall('get', url);
}

/**
 * Custom "patch" that returns data or throws an error.
 *
 * @param {string} url
 * @returns {Promise}
 */
export async function doPatch(url, payload) {
  return doAxiosCall('patch', url, payload);
}

/**
 * Custom "delete" that returns data or throws an error.
 *
 * @param {string} url
 * @returns {Promise}
 */
export async function doDelete(url) {
  return doAxiosCall('delete', url);
}

/**
 * Custom "post" that returns data or throws an error.
 *
 * @param {string} url
 * @param {object} payload
 * @param {object} config
 * @returns {Promise}
 */
export async function doPost(url, payload) {
  return doAxiosCall('post', url, payload);
}

/**
 * Custom "post" that returns data or throws an error.
 *
 * @param {string} url
 * @param {object} payload
 * @param {object} config
 * @returns {Promise}
 */
export async function doPut(url, payload) {
  return doAxiosCall('put', url, payload);
}
