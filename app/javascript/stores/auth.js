import { defineStore } from 'pinia';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
  }),

  actions: {
    /**
     * @param {object} user
     */
    setUser(user) {
      this.user = user;
    },
  },
});
