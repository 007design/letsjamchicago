<template>
  <Message
    v-if="!authenticated"
    class="new-message"
    :closable="false"
  >
    New here? Check out the <a href="/about">help</a>.
  </Message>
  <div class="upcoming-events-header">
    <h2>
      Upcoming events
      <template v-if="neighborhood">in {{ neighborhood }}</template>
    </h2>
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
      <p>We couldn't find any events<template v-if="neighborhood"> in {{ neighborhood }}</template>.
        Try selecting a different neighborhood.</p>
      <template v-if="authenticated">
        <p>
          Or why not
          <Button link class="text-button" @click="() => $router.push({ name: 'NewEvent' })">
            create an event</Button>?
        </p>
      </template>
      <template v-else>
        <p>
          Or
          <Button link class="text-button" @click="() => $router.push({ name: 'SignIn' })">
            sign in
          </Button>
          to create you own events.
        </p>
      </template>
    </template>
  </Card>
</template>

<script>
import { mapActions, mapState } from 'pinia';
import { useAuthStore } from '@/stores/auth';
import { useEventsStore } from '@/stores/events';
import EventCard from '@/components/events/EventCard.vue';
import NeighborhoodDropdown from '@/components/NeighborhoodDropdown.vue';

export default {
  name: 'UpcomingEventsView',
  components: {
    EventCard,
    NeighborhoodDropdown,
  },
  inject: ['loadEvents'],
  data() {
    return {
      neighborhood: null,
    };
  },
  created() {
    this.loadEvents();
  },
  computed: {
    ...mapState(useEventsStore, ['events']),
    ...mapState(useAuthStore, ['user']),
    authenticated() {
      return this.user !== null;
    },
  },
  watch: {
    neighborhood() {
      this.loadEvents(this.neighborhood);
    },
  },
  methods: {
    ...mapActions(useEventsStore, ['setEvents']),
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

.new-message {
  border-color: #44B6E5;
  color: #44B6E5;

  a:link,
  a:visited {
    color: #44B6E5;
  }

  :deep(.p-message-icon) {
    color: #44B6E5;
  }

  :deep(.p-message-wrapper) {
    justify-content: center;
  }
}

.text-button {
  padding: 0;
  color: #44B6E5;
}

.empty-card {
  text-align: center;
}
</style>
