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
  <Card v-if="!events.length" class="empty-card">
    <template #content>
      We couldn't find any events. Try selecting a different neighborhood.
    </template>
  </Card>
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

  .mobile & {
    flex-direction: column;
    margin: 0;

    h2 {
      margin-bottom: .5em;
    }
  }
}

.empty-card {
  text-align: center;
}
</style>
