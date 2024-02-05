<template>
  <Dropdown
    id="neighborhood"
    v-model="neighborhood"
    :options="neighborhoods"
    filter
    placeholder="Select a neighborhood"
  />
</template>

<script>
import { neighborhoods } from '@/utils/common';

export default {
  name: 'NeighborhoodDropdown',
  emits: ['update:value'],
  props: {
    value: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      neighborhood: '',
      neighborhoods,
    };
  },
  watch: {
    neighborhood() {
      this.$emit('update:value', this.neighborhood);
    },
  },
};
</script>
