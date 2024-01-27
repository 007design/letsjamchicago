import {
  doDelete,
  doGet,
  doPatch,
  doPost,
} from '@/utils/api';

/**
 * Gets events.
 *
 * @returns {Promise}
 */
export async function getEvents({ neighborhood = '', user = null }) {
  return doGet(`api/v1/events?${neighborhood ? `n=${neighborhood}` : ''}${user ? `u=${user.id}` : ''}`);
}

export async function getEvent(id) {
  return doGet(`api/v1/events/${id}`);
}

export async function newEvent(event) {
  return doPost('api/v1/events', { event });
}

export async function updateEvent(event) {
  return doPatch(`api/v1/events/${event.id}`, { event });
}

export async function deleteEvent(event) {
  return doDelete(`api/v1/events/${event.id}`);
}
