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

export async function getAttendingEvents({ user }) {
  return doGet(`api/v1/users/${user.id}/attending`);
}

export async function getEvent(id) {
  return doGet(`api/v1/events/${id}`);
}

export async function getNearbyUsers(neighborhood) {
  return doGet(`api/v1/users/nearby?n=${neighborhood}`);
}

export async function inviteUsers(eventId, invitations) {
  return doPost(`api/v1/events/${eventId}/invite`, { invitations });
}

export async function newEvent(event) {
  return doPost('api/v1/events', { event });
}

export async function updateEvent(event) {
  return doPatch(`api/v1/events/${event.id}`, { event });
}

export async function cancelEvent(event) {
  return doPatch(`api/v1/events/${event.id}`, {
    event: {
      ...event,
      cancelled: true,
    },
  });
}

export async function deleteEvent(event) {
  return doDelete(`api/v1/events/${event.id}`);
}

export async function joinEvent(event) {
  return doGet(`api/v1/events/${event.id}/attend`);
}

export async function leaveEvent(event) {
  return doDelete(`api/v1/events/${event.id}/decline`);
}
