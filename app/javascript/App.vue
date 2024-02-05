<template>
  <div :class="['main', { mobile: isMobile }]">
    <MainHeader />
    <RouterView :key="$route.fullPath" />
    <TermsModal v-model:visible="isTermsDialogVisible" />
    <PolicyModal v-model:visible="isPolicyDialogVisible" />
    <MainFooter />
    <ConfirmDialog></ConfirmDialog>
  </div>
</template>

<script>
import { mapActions, mapState } from 'pinia';
// import { setSignedIn } from '@/services/auth';
import { useAuthStore } from '@/stores/auth';
import { useEventsStore } from '@/stores/events';
import MainHeader from '@/components/MainHeader.vue';
import MainFooter from '@/components/MainFooter.vue';
import TermsModal from '@/components/modals/TermsModal.vue';
import PolicyModal from '@/components/modals/PolicyModal.vue';
import mq from '@/utils/mq';

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
  // async created() {
  //   if (!this.user) {
  //     try {
  //       await setSignedIn();
  //     } catch {
  //       // User not logged in
  //     }
  //   }
  // },
  computed: {
    ...mapState(useAuthStore, ['user']),
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
