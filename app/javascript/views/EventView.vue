<template>
  <Card class="edit-event-card">
    <template #header>
      <h3>{{ event.id ? 'Edit your' : 'Create an' }} event</h3>
    </template>
    <template #content>
      <div class="flex flex-column gap-1 mb-2">
        <label for="name" class="text-sm">Event name</label>
        <InputText id="name" type="text" v-model="event.name" />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="description" class="text-sm">Event description</label>
        <InputText id="description" type="text" v-model="event.description" />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="neighborhood" class="text-sm">
          Neighborhood
          <Badge
            value="?"
            severity="info"
            v-tooltip.bottom="'Select a neighborhood to help local musicians find your event'"
          />
        </label>
        <NeighborhoodDropdown v-model="event.neighborhood" />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="location" class="text-sm">Event location</label>
        <InputText id="location" type="text" v-model="event.location" />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="map" class="text-sm">
          Google map URL
          <Badge
            value="?"
            severity="info"
            v-tooltip.bottom="'Paste a URL from Google Maps'"
          />
        </label>
        <InputText id="map" type="text" v-model="event.map" />
      </div>
      <div :class="['flex gap-3 mb-2', mqMobile ? 'flex-column' : 'flex-row']">
        <div class="event-date">
          <label for="date" class="text-sm">Event date</label>
          <Calendar
            id="date"
            v-model="event.start_date"
            inline
            :min-date="new Date()"
          />
        </div>
        <div class="event-time">
          <label for="time" class="text-sm">Start time</label>
          <Calendar
            id="time"
            v-model="event.start_time"
            timeOnly
            hour-format="12"
          />
          {{ event.start_time }}
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
import { extractMapPlace, formatTime } from '@/utils/common';
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
  data() {
    return {
      event: {},
      showPreview: false,
    };
  },
  async created() {
    if (this.eventId) {
      const event = await getEvent(this.eventId);
      this.event = {
        ...event,
        start_time: formatTime(new Date(event.start_time).toLocaleDateString()),
      };
    }
  },
  computed: {
    isFormValid() {
      return this.event.name
        && this.event.location
        && this.event.start_date
        && this.event.start_time;
    },
    newEvent() {
      return {
        ...this.event,
        start_date: this.event.start_date?.toString(),
        start_time: this.event.start_time?.toString(),
        map: this.event.map?.indexOf('google.com') > -1 ? extractMapPlace(this.event.map) : this.event.map || '',
      };
    },
  },
  methods: {
    async doPreview() {
      this.showPreview = true;
    },
  },
};
</script>

<style lang="scss" scoped>
.edit-event-card {
  margin-top: 1em;
  padding: 0 1em 1em;
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

:deep(.p-card-body) {
  padding: 0;
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
