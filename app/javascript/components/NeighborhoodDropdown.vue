<template>
  <Dropdown
    id="neighborhood"
    v-model="neighborhood"
    :options="sortedNeighborhoods"
    filter
    placeholder="Filter by neighborhood"
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
  computed: {
    sortedNeighborhoods() {
      return neighborhoods.sort();
    },
  },
  watch: {
    neighborhood() {
      this.$emit('update:value', this.neighborhood);
    },
  },
};
</script>
