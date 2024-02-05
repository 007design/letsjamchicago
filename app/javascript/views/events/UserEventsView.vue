<template>
  <h2>Upcoming events</h2>
  <Card v-if="!currentEvents.length" class="empty-card">
    <template #content>
      <p>You have no upcoming events.</p>
      <Button label="Create an event" @click="() => $router.push({ name: 'NewEvent' })" />
    </template>
  </Card>
  <EventsList
    v-else
    :events="currentEvents"
    is-current-events
    @editEvent="doEditEvent"
    @deleteEvent="doDeleteEvent"
    @cancelEvent="doCancelEvent"
  />
  <template v-if="pastEvents.length">
    <Divider />
    <h2>Past events</h2>
    <EventsList
      :events="pastEvents"
      @editEvent="doEditEvent"
      @deleteEvent="doDeleteEvent"
      @cloneEvent="doCloneEvent"
    />
  </template>
</template>

<script>
import { mapActions, mapState } from 'pinia';
import { useAuthStore } from '@/stores/auth';
import { useEventsStore } from '@/stores/events';
import { getEvents, deleteEvent, cancelEvent } from '@/services/events';
import EventsList from '@/components/events/EventsList.vue';

export default {
  name: 'UserEvents',
  components: {
    EventsList,
  },
  computed: {
    ...mapState(useEventsStore, ['events']),
    ...mapState(useAuthStore, ['user']),
    currentEvents() {
      return this.events.filter(({ start_date: date }) => new Date(date) >= new Date());
    },
    pastEvents() {
      return this.events.filter(({ start_date: date }) => new Date(date) < new Date());
    },
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
        const data = await getEvents({ user: this.user });

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
    doEditEvent(event) {
      this.$router.push({ name: 'EditEvent', params: { eventId: event.id } });
    },
    doCancelEvent() {
      this.$confirm.require({
        message: 'Are you sure you want to cancel this event? This cannot be undone!',
        header: 'Confirmation',
        icon: 'pi pi-exclamation-triangle',
        rejectClass: 'p-button-secondary p-button-outlined',
        rejectLabel: 'Go back',
        acceptClass: 'p-button-danger delete-button',
        acceptLabel: 'Cancel event',
        accept: async () => {
          try {
            await cancelEvent(this.event);
            this.loadEvents();
          } catch {
            this.$toast.add({
              severity: 'danger',
              summary: 'Error',
              detail: 'Could not cancel event. Please sign in again.',
              life: 3000,
            });
          }
        },
      });
    },
    doCloneEvent(event) {
      this.$router.push({ name: 'CloneEvent', params: { eventId: event.id }, query: { clone: true } });
    },
    doDeleteEvent(event) {
      this.$confirm.require({
        message: 'Are you sure you want to delete this event? This cannot be undone!',
        header: 'Confirmation',
        icon: 'pi pi-exclamation-triangle',
        rejectClass: 'p-button-secondary p-button-outlined',
        rejectLabel: 'Cancel',
        acceptClass: 'p-button-danger delete-button',
        acceptLabel: 'Delete event',
        accept: async () => {
          try {
            await deleteEvent(event);
            this.loadEvents();
          } catch {
            this.$toast.add({
              severity: 'danger',
              summary: 'Error',
              detail: 'Could not delete event. Please sign in again.',
              life: 3000,
            });
          }
        },
      });
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
