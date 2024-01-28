<template>
  <Dialog
    class="w-11 terms-dialog"
    v-model:visible="isTermsDialogVisible"
    modal
    dismissable-mask
    position="top"
    header="Terms of Use"
    @hide="onCloseDialog"
  >
    Don't @ me!
  </Dialog>
</template>

<script>
export default {
  name: 'TermsModal',
  emits: ['update:visible'],
  props: {
    visible: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      isTermsDialogVisible: false,
    };
  },
  watch: {
    visible() {
      this.isTermsDialogVisible = this.visible;
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
.terms-dialog {
  max-width: 768px;
}
</style>
