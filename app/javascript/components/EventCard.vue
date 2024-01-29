<template>
  <Card class="event-card">
    <template #header>
      <div class="event-card-header">
        <div class="event-card-location">
          <Chip v-if="event.neighborhood">
            <Button link :label="event.neighborhood" @click="filterBy(event.neighborhood)" />
          </Chip>
          <div v-if="!mqMobile" class="event-location">
            <strong>{{ event.location }}</strong>
          </div>
        </div>
        <div class="event-card-when">
          <i class="pi pi-calendar"></i>
          {{ dateFormatter(event.start_date) }} @ {{ timeFormatter(event.start_date) }}
          <div v-if="mqMobile">
            <strong>{{ event.location }}</strong>
          </div>
          <div class="add-to-calendar">
            <Button link label="Add to calendar" />
          </div>
        </div>
      </div>
    </template>
    <template #content>
      <div class="event-card-content">
        <div class="event-details">
          <Panel
            class="event-description-panel"
            toggleable
            collapsed
          >
            <template #header>
              <h3>{{ event.name }}</h3>
            </template>
            <div class="event-description">
              {{ event.description }}
            </div>
            <iframe
              v-if="event.map"
              :width="mqMobile ? '100%' : 200"
              height="200"
              loading="lazy"
              allowfullscreen
              referrerpolicy="no-referrer-when-downgrade"
              :src="`https://www.google.com/maps/embed/v1/place?key=${apiKey}&q=${event.map}`">
            </iframe>
          </Panel>
        </div>
      </div>
    </template>
    <template #footer v-if="isPreview">
      <div class="event-card-footer">
        <slot name="footer" />
      </div>
    </template>
    <template #footer v-else>
      <div class="event-card-footer">
        <template v-if="!authenticated">
          <Button
            class="sign-in-button"
            :size="mqMobile ? 'small': ''"
            label="Sign in to RSVP"
            @click="() => $router.push({ name: 'SignIn' })"
          />
        </template>
        <template v-else-if="event.owned">
          <Button
            class="edit-event-button"
            :size="mqMobile ? 'small': ''"
            severity="secondary"
            label="Edit event"
            @click="editEvent"
          />
        </template>
        <template v-else-if="event.attending">
          <Button
            class="decline-button"
            :size="mqMobile ? 'small': ''"
            severity="danger"
            label="Decline event"
            @click="leaveEvent"
          />
        </template>
        <template v-else>
          <Button
            class="attend-button"
            :size="mqMobile ? 'small': ''"
            severity="success"
            label="Attend event"
            @click="joinEvent"
          />
        </template>
        <Tag severity="success">
          {{ event.attendee_count }} Going
        </Tag>
      </div>
    </template>
  </Card>
</template>

<script>
import { mapState } from 'pinia';
import { useAuthStore } from '@/stores/auth';
import { joinEvent, leaveEvent } from '@/services/events';
import mq from '@/utils/mq';
import { formatDate, formatTime } from '../utils/common';

const apiKey = import.meta.env.VITE_GOOGLE_API_KEY;

export default {
  name: 'EventCard',
  mixins: [mq],
  inject: ['loadEvents'],
  emits: ['filter', 'decline'],
  props: {
    event: {
      type: Object,
      required: true,
    },
    isPreview: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    ...mapState(useAuthStore, ['user']),
    authenticated() {
      return this.user !== null;
    },
    apiKey() {
      return apiKey;
    },
  },
  methods: {
    dateFormatter(dateString) {
      return formatDate(dateString);
    },
    timeFormatter(dateString) {
      return formatTime(dateString);
    },
    filterBy(neighborhood) {
      this.$emit('filter', neighborhood);
    },
    editEvent() {
      this.$router.push({ name: 'EditEvent', params: { eventId: this.event.id } });
    },
    async joinEvent() {
      try {
        await joinEvent(this.event);
      } finally {
        await this.loadEvents();
      }
    },
    async leaveEvent() {
      try {
        await leaveEvent(this.event);
        this.$emit('decline');
      } finally {
        await this.loadEvents();
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.event-card {
  margin: .5em 0;

  :deep(.p-card-body) {
    padding: 1em;
  }

  .p-button.p-button-link {
    color: #44B6E5;
    background: transparent;
  }

  .p-button-sm {
    padding: .4em .5em;
    font-size: 14px;
  }
}

.sign-in-button {
  background: #44B6E5;
  border-color: #44B6E5;
}

h3 {
  margin: 0;
}

iframe {
  border: 1px solid #e2e8f0;

  .mobile & {
    margin-top: 1em;
  }
}

.event-card-header {
  margin: 1em 1em 0;
  display: flex;
  justify-content: space-between;
  flex-direction: row-reverse;

  .mobile & {
    margin: .5em .5em 0;
    padding: .5rem;
    flex-direction: column;
  }
}

.event-card-footer {
  display: flex;
  justify-content: space-between;
}

.event-card-location {
  text-align: right;
  flex: 1 0 auto;

  button {
    margin: 0;
    padding: 0;
  }

  .mobile & {
    text-align: right;
    margin-bottom: .5em;
  }
}

.event-location {
  margin-right: .5em;
  margin-top: .5em;
}

.event-card-when {
  margin-bottom: .5em;

  .mobile & {
    font-size: 14px;
  }
}

.add-to-calendar {
  button {
    padding: .5em 0 0;
  }
}

.event-description-panel {
  padding: 0;
  margin: 0;
}

.event-description {
  flex: 1 0 auto;
}
</style>

<style lang="scss">
.event-card {
  .p-panel-content {
    display: flex;

    .mobile & {
      flex-direction: column;
    }
  }
}
</style>
