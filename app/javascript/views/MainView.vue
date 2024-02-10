<template>
  <div :class="['main-container', { auth: authenticated }]">
    <Message
      v-if="authenticated && noNeighborhoods"
      class="help-message"
    >
      We recommend specifying which neighborhood(s) you are in/near
      so event creators can invite you.
      <template v-if="$route.path !== '/account'">
        Update this in <a href="/account">Account settings</a>.
      </template>
    </Message>
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
    noNeighborhoods() {
      return !this.user.neighborhoods || this.user.neighborhoods === '[]';
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

.help-message {
  max-width: 600px;
  color: #44B6E5;

  a, a:link, a:visited {
    color: #44B6E5;
  }

  :deep(.p-message-icon) {
    color: #44B6E5;
  }

  :deep(.p-message-close) {
    color: #44B6E5;
  }

  :deep(.p-message-wrapper) {
    justify-content: center;
  }
}
</style>
