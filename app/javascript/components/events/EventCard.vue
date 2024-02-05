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
            <p v-if="mapObject" class="address-line">
              {{ mapObject.address_components[0].short_name }}
              {{ mapObject.address_components[1].short_name }}
            </p>
          </div>
        </div>
        <div class="event-card-when">
          <i class="pi pi-calendar"></i>
          {{ dateFormatter(event.start_date) }} @ {{ timeFormatter(event.start_date) }}
          <div v-if="mqMobile">
            <strong>{{ event.location }}</strong>
            <p v-if="mapObject" class="address-line">
              {{ mapObject.address_components[0].short_name }}
              {{ mapObject.address_components[1].short_name }}
            </p>
          </div>
          <div
            v-if="event.cancelled"
            class="cancelled-flag"
          >
            Cancelled
          </div>
          <div v-else class="add-to-calendar">
            <a
              target="_blank"
              rel="noopener"
              :href="calendarLink">
              <Button link label="Add to Google calendar" />
            </a>
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
            @update:collapsed="toggleEventDesc"
          >
            <template #header>
              <h3>{{ event.name }}</h3>
            </template>
            <div class="event-description">
              {{ event.description }}
            </div>
            <div
              v-if="mapObject"
              class="event-map"
              :id="`eventmap-${event.id || 1}`">
            </div>
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
            v-if="event.cancelled"
            class="edit-event-button"
            :size="mqMobile ? 'small': ''"
            label="Clone event"
            @click="doCloneEvent"
          />
          <div v-else class="button-group">
            <Button
              class="edit-event-button"
              :size="mqMobile ? 'small': ''"
              severity="secondary"
              label="Edit event"
              @click="doEditEvent"
            />
            <Button
              class="cancel-event-button"
              :size="mqMobile ? 'small': ''"
              severity="danger"
              link
              label="Cancel event"
              @click="doCancelEvent"
            />
          </div>
        </template>
        <template v-else-if="event.attending">
          <Button
            class="decline-button"
            :size="mqMobile ? 'small': ''"
            severity="danger"
            label="Decline event"
            @click="doLeaveEvent"
          />
        </template>
        <template v-else>
          <Button
            class="attend-button"
            :size="mqMobile ? 'small': ''"
            severity="success"
            label="Attend event"
            @click="doJoinEvent"
          />
        </template>
        <Tag
          v-if="authenticated"
          class="attendee-tag"
          severity="success"
          v-tooltip.focus.left="attendees"
          tabindex="1"
        >
          {{ event.attendee_count }} Going
        </Tag>
        <Tag
          v-else
          class="attendee-tag"
          severity="success"
        >
          {{ event.attendee_count }} Going
        </Tag>
      </div>
    </template>
  </Card>
  <ConfirmDialog></ConfirmDialog>
</template>

<script>
import { mapState } from 'pinia';
import { useAuthStore } from '@/stores/auth';
import { joinEvent, leaveEvent, cancelEvent } from '@/services/events';
import mq from '@/utils/mq';
import { formatDate, formatTime } from '@/utils/common';

const apiKey = import.meta.env.VITE_GOOGLE_API_KEY;
// eslint-disable-next-line no-unused-vars, one-var, one-var-declaration-per-line
let map, marker;

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
    attendees() {
      if (this.authenticated) {
        const count = this.event.attendee_count - this.event.attendee_names.length;
        return `${this.event.attendee_names}${count > 0 ? `,and ${count} other${count > 1 ? 's' : ''}` : ''}`.replace(',', '\n');
      }

      return '';
    },
    calendarLink() {
      const timezoneOffset = new Date().getTimezoneOffset() / 60;
      const date = new Date(this.event.start_date);
      const start = [
        date.getFullYear(),
        `0${(date.getMonth() + 1).toString()}`.slice(-2),
        date.getDate(),
        'T',
        `0${(date.getHours() + timezoneOffset).toString()}`.slice(-2),
        `0${(date.getMinutes()).toString()}`.slice(-2),
        '00Z',
      ].join('');
      const end = [
        date.getFullYear(),
        `0${(date.getMonth() + 1).toString()}`.slice(-2),
        date.getDate(),
        'T',
        `0${(date.getHours() + timezoneOffset + 1).toString()}`.slice(-2),
        `0${(date.getMinutes()).toString()}`.slice(-2),
        '00Z',
      ].join('');
      return `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${encodeURIComponent(this.event.name)}&details=${encodeURIComponent(this.event.description)}&location=${encodeURIComponent(this.event.location)}&dates=${start}/${end}&ctz=America/Chicago`;
    },
    mapObject() {
      try {
        let replaced = this.event.map.replace(/\\"/g, '"');
        replaced = replaced.replace(/^["|']\{/, '{').replace(/\}["|']$/, '}');
        const mapData = JSON.parse(replaced);
        return mapData;
      } catch {
        return null;
      }
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
    doEditEvent() {
      this.$router.push({ name: 'EditEvent', params: { eventId: this.event.id } });
    },
    doCloneEvent() {
      this.$router.push({ name: 'CloneEvent', params: { eventId: this.event.id }, query: { clone: true } });
    },
    toggleEventDesc(value) {
      if (!value && !map && this.mapObject) {
        map = new window.google.maps.Map(document.getElementById(`eventmap-${this.event.id || 1}`), {
          center: {
            lat: 41.833871,
            lng: -87.89677,
          },
          zoom: 13,
        });
        if (marker != null) marker.setMap(null);

        marker = new window.google.maps.Marker({
          map,
          title: this.mapObject.name,
          position: this.mapObject.geometry.location,
        });
        map.setCenter(this.mapObject.geometry.location);
      }
    },
    async doCancelEvent() {
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
    async doJoinEvent() {
      try {
        await joinEvent(this.event);
      } finally {
        await this.loadEvents();
      }
    },
    async doLeaveEvent() {
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

    &.cancel-event-button {
      color: red;
    }
  }

  .p-button-sm {
    padding: .4em .5em;
    font-size: 14px;
  }

  .cancelled-flag {
    color: red;
  }
}

.sign-in-button {
  background: #44B6E5;
  border-color: #44B6E5;
}

h3 {
  margin: 0;
}

.event-details {
  :deep(.p-panel-header) {
    display: flex;
    justify-content: space-between;
  }
}

.event-map {
  border: 1px solid #e2e8f0;
  height: 200px;
  width: 200px;
  flex: 1 0 auto;
  margin-left: 1em;

  .mobile & {
    margin-top: 1em;
    width: 100%;
    margin-left: 0;
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

.attendee-tag {
  cursor: pointer;
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

.address-line {
  margin: 0;
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
  flex: 1 1 auto;
  word-break: break-word;
  width: 100%;
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
