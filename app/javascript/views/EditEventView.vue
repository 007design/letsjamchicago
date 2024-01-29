<template>
  <Card class="edit-event-card">
    <template #header>
      <h3>
        {{ clone ? 'Clone an event' : event.id ? 'Edit your event' : 'Create an event' }}
      </h3>
    </template>
    <template #content>
      <div class="flex flex-column gap-1 mb-2">
        <label for="name" class="text-sm required">Event name</label>
        <InputText id="name" type="text" v-model="event.name" required />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="description" class="text-sm required">Event description</label>
        <InputText id="description" type="text" v-model="event.description" required />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <div class="input-header">
          <label for="neighborhood" class="text-sm">
            Neighborhood
          </label>
          <Badge
            value="?"
            severity="info"
            @click="toggleNeighborhoodTooltip"
          />
        </div>
        <NeighborhoodDropdown id="neighborhood" v-model="event.neighborhood" />
        <OverlayPanel ref="neighborhoodTooltip">
          Select a neighborhood to help local musicians find your event
        </OverlayPanel>
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="location" class="text-sm required">Event location</label>
        <InputText id="location" type="text" v-model="event.location" required />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <div class="input-header">
          <label for="map" class="text-sm">
            Google map URL
          </label>
          <Badge
            value="?"
            severity="info"
            @click="toggleMapTooltip"
          />
        </div>
        <InputText id="map" type="text" v-model="event.map" />
        <OverlayPanel ref="mapTooltip">
          Paste a URL from Google Maps
        </OverlayPanel>
      </div>
      <div :class="['flex gap-3 mb-2', mqMobile ? 'flex-column' : 'flex-row']">
        <div class="event-date">
          <label for="date" class="text-sm required">Event date</label>
          <Calendar
            id="date"
            v-model="event.start_date"
            date-format="DD MM d, yy"
            :min-date="new Date()"
          />
        </div>
        <div class="event-time">
          <label class="text-sm required">Start time</label>
          <div class="time-fields">
            <Dropdown
              class="time-input hours-input"
              v-model="hour"
              :options="timeOptions.hours"
            />
            <Dropdown
              class="time-input mins-input"
              v-model="min"
              :options="timeOptions.mins"
            />
            <Dropdown
              class="time-input ampm-input"
              v-model="ampm"
              :options="timeOptions.ampm"
            />
          </div>
          {{ event.start_date }}
        </div>
      </div>
    </template>
    <template #footer>
      <div class="footer-buttons">
        <Button label="Preview" @click="doPreview" :disabled="!isFormValid" />
      </div>
    </template>
  </Card>
  <EventPreviewModal v-model:visible="showPreview" :event="newEvent" />
</template>

<script>
import { getEvent } from '@/services/events';
import NeighborhoodDropdown from '@/components/NeighborhoodDropdown.vue';
import { extractMapPlace } from '@/utils/common';
import EventPreviewModal from '@/components/EventPreviewModal.vue';
import mq from '@/utils/mq';

export default {
  name: 'NewEventView',
  mixins: [mq],
  components: {
    EventPreviewModal,
    NeighborhoodDropdown,
  },
  props: {
    eventId: {
      type: Number,
      default: null,
    },
  },
  data(vm) {
    return {
      event: {},
      showPreview: false,
      clone: vm.$route.query.clone,
      hour: '12',
      min: '00',
      ampm: 'PM',
      timeOptions: {
        hours: [
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
        ],
        mins: [
          '00',
          '15',
          '30',
          '45',
        ],
        ampm: [
          'PM',
          'AM',
        ],
      },
    };
  },
  async created() {
    if (this.eventId) {
      try {
        const event = await getEvent(this.eventId);
        if (this.clone) {
          // eslint-disable-next-line camelcase
          const { start_date, ...clonedEvent } = event;
          this.event = clonedEvent;
        } else {
          this.event = {
            ...event,
          };
          let h = new Date(event.start_date).getHours();
          let m = new Date(event.start_date).getMinutes();
          const x = h >= 12 ? 'PM' : 'AM';
          h %= 12;
          h = h || 12;
          m = m < 10 ? `0${m}` : m;
          this.hour = h.toString();
          this.min = m.toString();
          this.ampm = x;
        }
      } catch (err) {
        this.$toast.add({
          severity: 'danger',
          summary: 'Error',
          detail: 'Could not load event.',
          life: 3000,
        });
      }
    }
  },
  computed: {
    timeHelper() {
      // eslint-disable-next-line no-nested-ternary
      return this.ampm === 'AM'
        ? (parseInt(this.hour, 10) >= 12 ? 0 : parseInt(this.hour, 10))
        : parseInt(this.hour, 10) === 12 ? 12 : parseInt(this.hour, 10) + 12;
    },
    isFormValid() {
      return this.event.name
        && this.event.description
        && this.event.location
        && this.event.start_date;
    },
    newEvent() {
      return {
        ...this.event,
        // start_date: this.event.start_date?.toString(),
        map: this.event.map?.indexOf('google.com') > -1 ? extractMapPlace(this.event.map) : this.event.map || '',
      };
    },
  },
  watch: {
    hour() {
      if (this.event.start_date) {
        this.event.start_date.setHours(this.timeHelper);
      }
    },
    min() {
      if (this.event.start_date) {
        this.event.start_date.setMinutes(this.min);
      }
    },
    ampm() {
      if (this.event.start_date) {
        this.event.start_date.setHours(this.timeHelper);
      }
    },
    'event.start_date': {
      handler(newVal, oldVal) {
        if (newVal !== oldVal) {
          const d = new Date(this.event.start_date);
          d.setHours(this.timeHelper);
          d.setMinutes(this.min);
          this.event.start_date = d;
        }
      },
    },
  },
  methods: {
    async doPreview() {
      this.showPreview = true;
    },
    toggleNeighborhoodTooltip(e) {
      this.$refs.neighborhoodTooltip.toggle(e);
    },
    toggleMapTooltip(e) {
      this.$refs.mapTooltip.toggle(e);
    },
  },
};
</script>

<style lang="scss" scoped>
.edit-event-card {
  padding: 0 1em 1em;
}

.input-header {
  .p-badge {
    cursor: pointer;
  }
}

.required::after {
  content: '*';
  color: red;
}

.footer-buttons {
  display: flex;
  justify-content: right;
}

.event-date,
.event-time {
  display: flex;
  flex-direction: column;
  flex: 1 0 auto;
}

.time-fields {
  display: flex;
  flex-wrap: nowrap;
}

.time-input {
  margin-right: .5em;
}

:deep(.p-card-body) {
  padding: 0;
}
.event-date {
  :deep(.p-datepicker table td.p-datepicker-today > span) {
    background-color: transparent;
  }
}

.p-button.p-button-link {
  color: #44B6E5;
  background: transparent;
}

.p-button {
  background: #44B6E5;
  border-color: #44B6E5;
}

.p-button-sm {
  padding: .4em .5em;
  font-size: 14px;
}
</style>
