<template>
  <header class="main-header">
    <div class="header-content">
      <div class="header-title">
        <Button
          class="home-button"
          link
          size="large"
          @click="() => $router.push({ name: 'Home' })"
        >
          <img class="home-icon" src="/ljc-logo.svg" alt="letsjamchicago logo"/>
          Let's Jam Chicago
        </Button>
      </div>
      <div class="header-buttons">
        <Button
          v-if="authenticated"
          label="Sign out"
          :size="mqMobile ? 'small': ''"
          @click="signOut"
        />
        <template v-else>
          <Button
            label="Sign up"
            link
            :size="mqMobile ? 'small': ''"
            @click="() => $router.push({ name: 'SignUp' })"
          />
          <Button
            label="Sign in"
            :size="mqMobile ? 'small': ''"
            @click="() => $router.push({ name: 'SignIn' })"
          />
        </template>
      </div>
    </div>
  </header>
</template>

<script>
import { mapState } from 'pinia';
import { useAuthStore } from '@/stores/auth';
import mq from '@/utils/mq';
import { signOut } from '../services/auth';

export default {
  name: 'MainHeader',
  mixins: [mq],
  computed: {
    ...mapState(useAuthStore, ['user']),
    authenticated() {
      return this.user !== null;
    },
  },
  methods: {
    async signOut() {
      await signOut();
      document.location.href = '/';
    },
  },
};
</script>

<style lang="scss" scoped>
.main-header {
  position: sticky;
  top: 0;
  z-index: 2;
  padding: 0 0 0 1em;
  background: white;
  box-shadow: 0 1px 3px rgba(0, 0, 0, .25);
  display: flex;
  justify-content: center;

  .header-content {
    width: 100%;
    max-width: 900px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .header-title {
    display: flex;
    flex: 0 1 auto;
    align-items: center;
  }

  .header-buttons {
    margin-right: 1em;
  }
}

.home-button {
  display: block;
  margin: .25em 0;
  padding: 0;
  font-size: 30px;
  font-weight: 600;

  .mobile & {
    font-size: 18px;
  }
}

.home-icon {
  height: 30px;
  width: 30px;

  .mobile & {
    height: 26px;
    width: 26px;
  }
}

.p-button.p-button-link {
  color: #44B6E5;
  background: transparent;
}

.p-button {
  background: #44B6E5;
  border-color: #44B6E5;
}

.p-button-sm {
  padding: .4em .5em;
  font-size: 14px;
}
</style>
