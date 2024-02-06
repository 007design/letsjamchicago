<template>
  <template v-if="expired">
    <Card>
      <template #content>
        <p>Sorry, this event has already passed or could not be found.</p>
      </template>
    </Card>
  </template>
  <template v-else>
    <EventCard
      :event="event"
      is-manage
    >
    </EventCard>
    <Card v-if="event.owned">
      <template #header>
        <h3>Invite attendees</h3>
      </template>
      <template #content>
        <p v-if="!event.neighborhood">
          Please give your event a neighborhood to find nearby attendees.
        </p>
        <p v-else-if="!users.length">
          There are currently no users registered in {{ event.neighborhood }}.
        </p>
        <div
          v-else
          v-for="user in users"
          :key="user.id"
          class="flex align-items-center mb-2"
        >
          <Checkbox
            class="list-checkbox"
            v-model="user.checked"
            :binary="true"
            :disabled="user.invited"
          />
          <div>{{ user.name }}</div>
        </div>
      </template>
      <template #footer>
        <Button
          v-if="event.neighborhood && users.length"
          class="invite-button"
          label="Invite users"
          :disabled="invitations.length === (event.invites?.length || 0) "
          @click="doUpdateInvitations"
        />
      </template>
    </Card>
  </template>
</template>

<script>
import { mapState } from 'pinia';
import { getNearbyUsers, inviteUsers } from '@/services/events';
import { useEventsStore } from '@/stores/events';
import EventCard from '@/components/events/EventCard.vue';

export default {
  name: 'ShowEventView',
  inject: ['loadEvents'],
  components: {
    EventCard,
  },
  props: {
    eventId: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      event: null,
      users: [],
      expired: true,
    };
  },
  async created() {
    if (this.eventId) {
      if (!this.events.length) {
        await this.loadEvents();
      }

      this.event = this.events.find(({ id }) => id.toString() === this.eventId.toString());
      if (this.event) {
        this.expired = false;
        try {
          if (this.event.owned && this.event.neighborhood) {
            const users = await getNearbyUsers(this.event.neighborhood);
            this.users = users.map((u) => ({
              ...u,
              invited: this.event.invites?.includes(u.id),
              checked: this.event.invites?.includes(u.id),
            }));
          }
        } catch (err) {
          this.$toast.add({
            severity: 'danger',
            summary: 'Error',
            detail: 'Could not load event.',
            life: 3000,
          });
        }
      } else {
        this.expired = true;
      }
    }
  },
  computed: {
    ...mapState(useEventsStore, ['events']),
    invitations() {
      return this.users.filter(({ checked }) => checked).map(({ id }) => id);
    },
  },
  methods: {
    async doUpdateInvitations() {
      try {
        await inviteUsers(this.event.id, this.invitations);
        this.users = this.users.map((u) => ({ ...u, invited: this.invitations.includes(u.id) }));
        this.event.invites = this.invitations;
      } catch {
        this.$toast.add({
          severity: 'danger',
          summary: 'Error',
          detail: 'Could not update event.',
          life: 3000,
        });
      }
    },
  },
};
</script>

<style lang="scss" scoped>
h3 {
  margin: 1em 1em 0;
}
.button-group {
  .p-button.p-button-link {
    color: #44B6E5;
    background: transparent;

    &.cancel-event-button {
      color: red;
    }
  }
}

.invite-button {
  background: #44B6E5;
  border-color: #44B6E5;
}

.list-checkbox {
  margin-right: .5em;
}
</style>
