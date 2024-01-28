<template>
  <div :class="['main-container', { auth: authenticated }]">
    <div class="main-content">
      <RouterView :key="$route.fullPath" />
    </div>
  </div>
</template>

<script>
import { mapState } from 'pinia';
import { useAuthStore } from '@/stores/auth';

export default {
  name: 'MainDashboard',
  computed: {
    ...mapState(useAuthStore, ['user']),
    authenticated() {
      return this.user !== null;
    },
  },
};
</script>

<style lang="scss" scoped>
.main-container {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 1em;
}
.main-content {
  width: 100%;
  max-width: 900px;
}
</style>
