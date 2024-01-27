import { defineStore } from 'pinia';

export const useEventsStore = defineStore('events', {
  state: () => ({
    events: [],
  }),

  actions: {
    /**
     * Set event list.
     *
     * @param {string} events
     */
    setEvents(events) {
      this.events.splice(0, this.events.length, ...events);
    },
  },
});
