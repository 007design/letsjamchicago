<template>
  <div :class="['main-container', { auth: authenticated }]">
    <UserToolbar v-if="authenticated" />
    <div class="main-content">
      <RouterView />
    </div>
  </div>
</template>

<script>
import { mapState } from 'pinia';
import { useAuthStore } from '@/stores/auth';
import UserToolbar from '@/components/UserToolbar.vue';

export default {
  name: 'MainDashboard',
  components: {
    UserToolbar,
  },
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

  &.auth {
    padding: 3em 1em 1em;
  }
}
.main-content {
  width: 100%;
  max-width: 900px;
}
</style>
