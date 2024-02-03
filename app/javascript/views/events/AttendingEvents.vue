<template>
  <h2>Attending events</h2>
  <Card v-if="!events.length" class="empty-card">
    <template #content>
      <p>You have no upcoming events.</p>
      <Button label="Create an event" @click="() => $router.push({ name: 'NewEvent' })" />
    </template>
  </Card>
  <EventCard
    v-else
    v-for="(event, index) in events"
    :key="`${event.name}-${index}`"
    :event="event"
    @decline="loadEvents"
  />
</template>

<script>
import { mapActions, mapState } from 'pinia';
import { useAuthStore } from '@/stores/auth';
import { useEventsStore } from '@/stores/events';
import { getAttendingEvents } from '@/services/events';
import EventCard from '@/components/events/EventCard.vue';

export default {
  name: 'AttendingEvents',
  components: {
    EventCard,
  },
  computed: {
    ...mapState(useEventsStore, ['events']),
    ...mapState(useAuthStore, ['user']),
  },
  async created() {
    this.loadEvents();
  },
  methods: {
    ...mapActions(useEventsStore, ['setEvents']),
    /**
     * Load events from the server.
     */
    async loadEvents() {
      try {
        const data = await getAttendingEvents({ user: this.user });

        this.setEvents(data);
      } catch (error) {
        this.$toast.add({
          severity: 'danger',
          summary: 'Error',
          detail: 'Could not load events. Please sign in again.',
          life: 3000,
        });
      }
    },
  },
};
</script>

<style lang="scss" scoped>
h2 {
  margin: 0 .5em .5em;

  .mobile & {
    margin: 0 0 .5em
  }
}

.empty-card {
  margin-bottom: 1em;

  :deep(.p-card-content) {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  p {
    margin: 0;
  }

  .mobile & {
    :deep(.p-card-content) {
      flex-direction: column;
      text-align: center;
    }

    p {
      margin-bottom: 1em;
    }
  }

  button {
    background: #44B6E5;
    border-color: #44B6E5;
    padding: .4em .5em;
    font-size: 14px;
  }
}
</style>
