import {
  doGet,
  doPatch,
  doPost,
} from '@/utils/api';

/**
 * Gets events.
 *
 * @returns {Promise}
 */
export async function getEvents({ neighborhood = '' }) {
  return doGet(`api/v1/events?${neighborhood ? `neighborhood=${neighborhood}` : ''}`);
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
