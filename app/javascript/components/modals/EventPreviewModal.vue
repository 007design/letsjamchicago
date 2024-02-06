<template>
  <Dialog
    class="w-11 event-preview-dialog"
    v-model:visible="isDialogVisible"
    modal
    dismissable-mask
    header="Event preview"
    position="top"
    @hide="onCloseDialog"
  >
    <EventCard
      :event="event"
      is-preview
    />
    <template #footer>
      <Button label="Go back" link @click="isDialogVisible = false" />
      <Button label="Save event" @click="doSave" />
    </template>
  </Dialog>
  <Toast />
</template>

<script>
import { newEvent, updateEvent } from '@/services/events';
import EventCard from '@/components/events/EventCard.vue';

export default {
  name: 'EventPreviewModal',
  emits: ['update:visible'],
  components: {
    EventCard,
  },
  props: {
    visible: {
      type: Boolean,
      default: false,
    },
    event: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      isDialogVisible: false,
    };
  },
  watch: {
    visible() {
      this.isDialogVisible = this.visible;
    },
  },
  methods: {
    onCloseDialog() {
      this.$emit('update:visible', false);
    },
    async doSave() {
      if (this.event.id) {
        try {
          await updateEvent({
            ...this.event,
            map: this.event.map ? JSON.stringify(this.event.map) : '',
          });
          document.location.href = `/event/${this.event.id}`;
        } catch {
          this.isDialogVisible = false;
          this.$toast.add({
            severity: 'danger',
            summary: 'Error',
            detail: 'Could not update event.',
            life: 3000,
          });
        }
      } else {
        try {
          const event = await newEvent({
            ...this.event,
            map: this.event.map ? JSON.stringify(this.event.map) : '',
          });
          document.location.href = `/event/${event.id}`;
        } catch {
          this.isDialogVisible = false;
          this.$toast.add({
            severity: 'danger',
            summary: 'Error',
            detail: 'Could not create event.',
            life: 3000,
          });
        }
      }
      this.isDialogVisible = false;
    },
  },
};
</script>

<style lang="scss">
.event-preview-dialog {
  max-width: 768px;

  .p-dialog-content {
    padding: 0;
  }

  .p-dialog-footer {
    display: flex;
    justify-content: space-between;
    padding: .75em 1.5em 1em;

    button {
      background: #44B6E5;
      border-color: #44B6E5;
    }
  }

  .p-button.p-button-link {
    color: #44B6E5;
    background: transparent;
  }
}
</style>
