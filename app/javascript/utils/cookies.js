/**
 * Look a cookie and return results.
 *
 * @param {string} name - Name of the cookie to retrieve.
 * @returns {string}
 */
export function getCookie(name) {
  const cookieName = `${name}=`;
  const ca = document.cookie.split(';');

  for (let i = 0; i < ca.length; i += 1) {
    let c = ca[i];

    while (c.charAt(0) === ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(cookieName) === 0) {
      return c.substring(cookieName.length, c.length);
    }
  }

  return '';
}

/**
 * Delete a specfic cookie.
 *
 * @param {string} name - Name of the cookie to delete.
 */
export function deleteCookie(name) {
  // const domain = import.meta.env.VITE_DOMAIN;
  document.cookie = `${name}=; path=/; SameSite=Strict; expires=Thu, 01 Jan 1970 00:00:01 GMT;`;
  // document.cookie =
  // `${name}=; path=/; Domain=${domain}; SameSite=Strict; expires=Thu, 01 Jan 1970 00:00:01 GMT;`;
}

/**
 * Set a cookie.
 *
 * @param {string} name - Name of the cookie to set.
 * @param {string} value - Value of the cookie to set.
 * @param {Date} expirationDate - Expiration date (defaults to 24 hours).
 */
export function setCookie(
  name,
  value,
  expirationDate = new Date(new Date().getTime() + (24 * 60 * 60 * 1000)),
) {
  // const domain = import.meta.env.VITE_DOMAIN;
  const cookie = `${name}=${value}; SameSite=Strict; expires=${expirationDate.toUTCString()}; path=/; secure;`;
  // const cookie =
  // `${name}=${value}; Domain=${domain}; SameSite=Strict;
  // expires=${expirationDate.toUTCString()}; path=/; secure;`;

  document.cookie = cookie;
}
