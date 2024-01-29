<template>
  <Dialog
    class="w-11 policy-dialog"
    v-model:visible="isPolicyDialogVisible"
    modal
    dismissable-mask
    position="top"
    header="Privacy Policy"
    @hide="onCloseDialog"
  >
    Privacy
  </Dialog>
</template>

<script>
export default {
  name: 'PolicyModal',
  emits: ['update:visible'],
  props: {
    visible: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      isPolicyDialogVisible: false,
    };
  },
  watch: {
    visible() {
      this.isPolicyDialogVisible = this.visible;
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
.policy-dialog {
  max-width: 768px;
}
</style>
