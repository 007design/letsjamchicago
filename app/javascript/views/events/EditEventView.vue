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
        <Textarea id="description" v-model="event.description" auto-resize rows="5" required />
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
          Select a neighborhood to help local musicians find your event.
        </OverlayPanel>
      </div>
      <div :class="['flex gap-3 mb-2', mqMobile ? 'flex-column' : 'flex-row']">
        <div class="event-date">
          <label class="text-sm required">Event date</label>
          <Calendar
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
        </div>
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="location" class="text-sm required">Event location name</label>
        <InputText id="location" type="text" v-model="event.location" required />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <div class="input-header">
          <label for="map" class="text-sm">
            Event location address
          </label>
          <Badge
            value="?"
            severity="info"
            @click="toggleMapTooltip"
          />
        </div>
        <InputText id="map" type="text" v-model="mapName" />
        <OverlayPanel ref="mapTooltip">
          Add an address so attendees can find your event.
        </OverlayPanel>
        <div id="previewmap" :class="{ visible: event.map }"></div>
      </div>
    </template>
    <template #footer>
      <div class="footer-buttons">
        <Button
          label="Preview"
          @click="doPreview"
          :disabled="!isFormValid"
        />
        <Button
          v-if="event.id && !clone"
          class="delete-event-button"
          label="Delete event"
          @click="doDelete"
        />
      </div>
    </template>
  </Card>
  <ConfirmDialog></ConfirmDialog>
  <EventPreviewModal v-model:visible="showPreview" :event="previewEvent" />
</template>

<script>
import { getEvent, deleteEvent } from '@/services/events';
import NeighborhoodDropdown from '@/components/NeighborhoodDropdown.vue';
import EventPreviewModal from '@/components/modals/EventPreviewModal.vue';
import mq from '@/utils/mq';

// eslint-disable-next-line no-unused-vars, one-var, one-var-declaration-per-line
let map, marker;

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
      // map: null,
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
        // this.map = event.map;
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
  mounted() {
    this.setupMap();
  },
  computed: {
    mapObject() {
      try {
        let replaced = this.event.map.replace(/\\"/g, '"');
        replaced = replaced.slice(1, replaced.length - 1);
        const mapData = JSON.parse(replaced);
        return mapData;
      } catch {
        return null;
      }
    },
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
    mapName() {
      return this.mapObject ? this.mapObject.name : '';
    },
    previewEvent() {
      return {
        ...this.event,
        // map: this.map,
      };
    },
  },
  watch: {
    mapObject: {
      handler(mapData) {
        if (mapData && map && this.mapObject) {
          this.$nextTick(() => {
            if (marker != null) marker.setMap(null);
            // eslint-disable-next-line no-unused-vars
            marker = new window.google.maps.Marker({
              map,
              title: this.mapObject.name,
              position: this.mapObject.geometry.location,
            });
            map.setCenter(this.mapObject.geometry.location);
          });
        }
      },
      immediate: true,
    },
    hour() {
      if (this.event.start_date) {
        const d = new Date(this.event.start_date);
        if (d.toString().toLocaleLowerCase() === 'invalid date') {
          return;
        }
        d.setHours(this.timeHelper);
        this.event.start_date = d;
      }
    },
    min() {
      if (this.event.start_date) {
        const d = new Date(this.event.start_date);
        if (d.toString().toLocaleLowerCase() === 'invalid date') {
          return;
        }
        d.setMinutes(this.min);
        this.event.start_date = d;
      }
    },
    ampm() {
      if (this.event.start_date) {
        const d = new Date(this.event.start_date);
        if (d.toString().toLocaleLowerCase() === 'invalid date') {
          return;
        }
        d.setHours(this.timeHelper);
        this.event.start_date = d;
      }
    },
    'event.start_date': {
      handler(newVal, oldVal) {
        if (newVal.toString() !== (oldVal ? oldVal.toString() : '')) {
          try {
            const d = new Date(this.event.start_date);
            if (d.toString().toLocaleLowerCase() !== 'invalid date') {
              d.setHours(this.timeHelper);
              d.setMinutes(this.min);
              this.event.start_date = d;
            }
          } catch (x) {
            // do nothing
          }
        }
      },
    },
  },
  methods: {
    async doPreview() {
      this.showPreview = true;
    },
    async doDelete() {
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
            await deleteEvent(this.event);
            document.location.href = '/';
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
    toggleNeighborhoodTooltip(e) {
      this.$refs.neighborhoodTooltip.toggle(e);
    },
    toggleMapTooltip(e) {
      this.$refs.mapTooltip.toggle(e);
    },
    setupMap() {
      map = new window.google.maps.Map(document.getElementById('previewmap'), {
        center: {
          lat: 41.833871,
          lng: -87.89677,
        },
        zoom: 13,
      });
      const input = document.getElementById('map');
      const options = {
        componentRestrictions: { country: 'us' },
        fields: ['address_components', 'geometry', 'icon', 'name'],
        strictBounds: false,
      };
      const autocomplete = new window.google.maps.places.Autocomplete(input, options);
      window.google.maps.event.addListener(autocomplete, 'place_changed', () => {
        const place = autocomplete.getPlace();
        this.event.map = place;
      });
    },
  },
};
</script>

<style lang="scss" scoped>
#previewmap.visible {
  height: 200px;
}
.edit-event-card {
  padding: 0 1em 1em;
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
  flex-direction: row-reverse;
  justify-content: space-between;
}

.delete-event-button {
  background: #EF4444;
  border-color: #EF4444;
  color: white;
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
</style>
