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
  </Dialog>
</template>

<script>
import EventCard from './EventCard.vue';

export default {
  name: 'EventPreviewModal',
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
  },
};
</script>

<style lang="scss">
.event-preview-dialog {
  max-width: 768px;
}
</style>
