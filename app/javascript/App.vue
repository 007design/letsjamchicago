<template>
  <div :class="['main', { mobile: isMobile }]">
    <MainHeader />
    <RouterView :key="$route.fullPath" />
    <TermsModal v-model:visible="isTermsDialogVisible" />
    <PolicyModal v-model:visible="isPolicyDialogVisible" />
    <MainFooter />
  </div>
</template>

<script>
import { mapActions } from 'pinia';
import { getUser, setSignedIn } from '@/services/auth';
import { useEventsStore } from '@/stores/events';
import MainHeader from '@/components/MainHeader.vue';
import TermsModal from '@/components/TermsModal.vue';
import PolicyModal from '@/components/PolicyModal.vue';
import mq from '@/utils/mq';
import { getCookie } from '@/utils/cookies';
import MainFooter from '@/components/MainFooter.vue';

const cookieNameSpace = import.meta.env.VITE_COOKIE_NAMESPACE;

export default {
  name: 'App',
  components: {
    MainHeader,
    MainFooter,
    TermsModal,
    PolicyModal,
  },
  mixins: [mq],
  provide() {
    return {
      showTermsDialog: this.showTermsDialog,
      showPolicyDialog: this.showPolicyDialog,
    };
  },
  data() {
    return {
      isTermsDialogVisible: {
        type: Boolean,
        default: false,
      },
      isPolicyDialogVisible: {
        type: Boolean,
        default: false,
      },
    };
  },
  async created() {
    if (getCookie(`${cookieNameSpace}-auth`)) {
      try {
        const user = await getUser();

        setSignedIn(user);
      } catch {
        // do nothing
      }
    }
  },
  computed: {
    isMobile() {
      return this.mqMobile;
    },
  },
  methods: {
    ...mapActions(useEventsStore, ['setEvents']),
    showTermsDialog() {
      this.isTermsDialogVisible = true;
    },
    showPolicyDialog() {
      this.isPolicyDialogVisible = true;
    },
  },
};
</script>

<style lang="scss">
@import url('https://fonts.googleapis.com/css?family=Roboto+Condensed');

body, html {
  height: 100%;
  font-family: 'Roboto', sans-serif;
  -ms-overflow-style: -ms-autohiding-scrollbar;
  box-sizing: border-box;
}

#app {
  font-family: 'Roboto', sans-serif;
  display: flex;
  flex-direction: column;
}

.main {
  display: flex;
  flex-direction: column;
  height: 100%;
  padding-bottom: 2em;
}
</style>
