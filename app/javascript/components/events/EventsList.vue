<template>
  <EventCard
    v-for="(event, index) in events"
    :key="`${event.name}-${index}`"
    :event="event"
    is-preview
  >
    <template #footer>
      <template v-if="isCurrentEvents">
        <div class="button-group">
          <Button
            class="edit-button"
            severity="secondary"
            label="Edit event"
            @click="() => $emit('editEvent', event)"
          />
          <Button
            class="cancel-event-button"
            severity="danger"
            link
            label="Cancel event"
            @click="() => $emit('cancelEvent', event)"
          />
        </div>
        <Button
          class="delete-button"
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
import EventCard from '@/components/events/EventCard.vue';

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
  color: white;
  margin-right: .5em;
}

.cancel-event-button {
  color: red;
}
</style>
