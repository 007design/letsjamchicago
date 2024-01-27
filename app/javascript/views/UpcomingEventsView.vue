<template>
  <div class="upcoming-events-header">
    <h2>Upcoming events</h2>
    <NeighborhoodDropdown v-model="neighborhood" showClear />
  </div>
  <EventCard
    v-for="(event, index) in events"
    :key="`${event.name}-${index}`"
    :event="event"
    @filter="filterBy"
  />
</template>

<script>
import { mapActions, mapState } from 'pinia';
import { getEvents } from '@/services/events';
import { useEventsStore } from '@/stores/events';
import EventCard from '@/components/EventCard.vue';
import NeighborhoodDropdown from '@/components/NeighborhoodDropdown.vue';

export default {
  name: 'UpcomingEventsView',
  components: {
    EventCard,
    NeighborhoodDropdown,
  },
  data() {
    return {
      neighborhood: '',
    };
  },
  created() {
    this.loadEvents();
  },
  computed: {
    ...mapState(useEventsStore, ['events']),
  },
  watch: {
    neighborhood() {
      this.loadEvents();
    },
  },
  methods: {
    ...mapActions(useEventsStore, ['setEvents']),
    /**
     * Load events from the server.
     */
    async loadEvents() {
      try {
        const data = await getEvents({ neighborhood: this.neighborhood });

        this.setEvents(data);
      } catch (error) {
        // this.addAlert({
        //   title: 'Error retrieving events.',
        //   type: 'error',
        // });
      }
    },
    filterBy(neighborhood) {
      this.neighborhood = neighborhood;
    },
  },
};
</script>

<style lang="scss" scoped>
h2 {
  margin: 0;
}

.upcoming-events-header {
  display: flex;
  justify-content: space-between;
  margin: 1em 0;
}
</style>
