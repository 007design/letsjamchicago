<template>
  <DataTable
    v-if="!mqMobile"
    :value="events"
    table-class="events-table"
    size="small"
    show-gridlines
    striped-rows
  >
    <Column header="Event name" class="events-table-column" v-tooltip.bottom="event">
      <template #body="slotProps">
        {{ slotProps.data.name }}
      </template>
    </Column>
    <Column header="Description" class="events-table-column">
      <template #body="slotProps">
        {{ slotProps.data.description }}
      </template>
    </Column>
    <Column header="Neighborhood" class="events-table-column">
      <template #body="slotProps">
        {{ slotProps.data.neighborhood }}
      </template>
    </Column>
    <Column header="Location" class="events-table-column">
      <template #body="slotProps">
        {{ slotProps.data.location }}
      </template>
    </Column>
    <Column header="Google map" class="events-table-column">
      <template #body="slotProps">
        {{ slotProps.data.map }}
      </template>
    </Column>
    <Column header="Event date" class="events-table-column">
      <template #body="slotProps">
        {{ formatDate(slotProps.data.start_date) }}
      </template>
    </Column>
    <Column header="Start time" class="events-table-column">
      <template #body="slotProps">
        {{ formatTime(slotProps.data.start_time) }}
      </template>
    </Column>
    <Column class="button-column" v-if="isCurrentEvents">
      <template #body="slotProps">
        <Button
          label="Edit"
          class="edit-button"
          @click="() => $emit('editEvent', slotProps.data)"
        />
        <Button
          label="Delete"
          severity="danger"
          class="delete-button"
          @click="() => $emit('deleteEvent', slotProps.data)"
        />
      </template>
    </Column>
    <Column class="button-column" v-else>
      <template #body="slotProps">
        <Button
          label="Clone event"
          class="edit-button"
          @click="() => $emit('cloneEvent', slotProps.data)"
        />
      </template>
    </Column>
  </DataTable>
  <EventCard
    v-else
    v-for="(event, index) in events"
    :key="`${event.name}-${index}`"
    :event="event"
    is-preview
  >
    <template #footer>
      <template v-if="isCurrentEvents">
        <Button
          class="edit-button"
          size="small"
          label="Edit event"
          @click="() => $emit('editEvent', event)"
        />
        <Button
          class="delete-button"
          size="small"
          label="Delete event"
          severity="danger"
          @click="() => $emit('deleteEvent', event)"
        />
      </template>
      <template v-else>
        <Button
          class="edit-button"
          size="small"
          label="Clone event"
          @click="() => $emit('cloneEvent', event)"
        />
      </template>
    </template>
  </EventCard>
</template>

<script>
import { formatDate, formatTime } from '@/utils/common';
import mq from '@/utils/mq';
import EventCard from './EventCard.vue';

export default {
  name: 'EventsList',
  mixins: [mq],
  emits: ['deleteEvent', 'editEvent'],
  components: {
    EventCard,
  },
  props: {
    events: {
      type: Array,
      required: true,
    },
    isCurrentEvents: {
      type: Boolean,
      default: false,
    },
  },
  methods: {
    formatDate,
    formatTime,
  },
};
</script>

<style lang="scss" scoped>
.edit-button {
  background: #44B6E5;
  border-color: #44B6E5;
  padding: .4em .5em;
  font-size: 14px;
}

.delete-button {
  padding: .4em .5em;
  font-size: 14px;
}

:deep(.events-table) {
  table-layout: fixed;

  .edit-button {
    background: #44B6E5;
    border-color: #44B6E5;
    font-size: 12px;
    padding: .25em .5em;
    margin-right: .5em;
  }

  .delete-button {
    font-size: 12px;
    padding: .25em .5em;
  }
}

:deep(th.events-table-column) {
  font-size: 14px;
  max-width: calc(100% / 8);
  white-space: nowrap;
}

:deep(td.events-table-column) {
  font-size: 14px;
  max-width: calc(100% / 8);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
