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
        <template v-if="authenticated">
          <Button
            class="create-event-button"
            label="Create an event"
            :size="mqMobile ? 'small': ''"
            @click="() => $router.push({ name: 'NewEvent' })"
          />
          <Button
            class="menu-button"
            :size="mqMobile ? 'small': ''"
            icon="pi pi-bars"
            aria-haspopup="true"
            aria-controls="overlay_menu"
            @click="toggle"
          />
          <Menu ref="menu" id="overlay_menu" :model="menuItems" :popup="true" />
        </template>
        <template v-else>
          <Button
            class="sign-up-button"
            label="Sign up"
            link
            :size="mqMobile ? 'small': ''"
            @click="() => $router.push({ name: 'SignUp' })"
          />
          <Button
            class="sign-in-button"
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
  data() {
    return {
      menuItems: [
        {
          label: 'Create an event',
          command: () => {
            this.$router.push({ name: 'NewEvent' });
          },
        },
        {
          label: 'Attending events',
          command: () => {
            this.$router.push({ name: 'AttendingEvents' });
          },
        },
        {
          label: 'Created events',
          command: () => {
            this.$router.push({ name: 'MyEvents' });
          },
        },
        {
          label: 'Account settings',
          command: () => {
            this.$router.push({ name: 'NewEvent' });
          },
        },
        {
          label: 'Sign out',
          command: () => {
            this.signOut();
          },
        },
      ],
    };
  },
  computed: {
    ...mapState(useAuthStore, ['user']),
    authenticated() {
      return this.user !== null;
    },
  },
  methods: {
    toggle(event) {
      this.$refs.menu.toggle(event);
    },
    async signOut() {
      try {
        await signOut();
      } finally {
        document.location.href = '/';
      }
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

    .mobile & {
      margin-right: .5em;
    }
  }
}

.menu-button {
  background: transparent;
  border: none;
  color: #44B6E5;
  margin-left: .5em;
  font-size: 20px;

  :deep(.p-button-icon) {
    font-size: 20px;
  }
}

.home-button {
  display: block;
  margin: .25em 0;
  padding: 0;
  font-size: 30px;
  font-weight: 600;
  color: #44B6E5;

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

.create-event-button,
.sign-in-button {
  background: #44B6E5;
  border-color: #44B6E5;
}

.sign-up-button {
  color: #44B6E5;
  margin-right: .5em;
}

.p-button-sm {
  padding: .4em .5em;
  font-size: 14px;
}
</style>
