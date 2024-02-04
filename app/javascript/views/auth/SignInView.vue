<template>
  <Card class="signin-card">
    <template #content>
      <div class="flex flex-column gap-1 mb-2">
        <label for="email" class="text-sm">Email address</label>
        <InputText id="email" type="text" v-model="user.email" />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="password" class="text-sm">Password</label>
        <InputText id="password" type="password" v-model="user.password" />
      </div>
      <Message
        v-if="alert"
        :severity="alert.type"
        class="alert-message"
        @close="alert = null"
      >
        {{ alert.message }}
      </Message>
    </template>
    <template #footer>
      <div class="footer-buttons">
        <Button label="Sign up" link @click="() => $router.push({ name: 'SignUp' })" />
        <Button label="Sign in" @click="doLogin" :disabled="!isFormValid" />
      </div>
      <div class="terms-message">
        By using this site you agree to the
        <Button label="Terms of Use" link @click="showTermsDialog" />
      </div>
    </template>
  </Card>
  <Button label="Forgot password?" link @click="() => $router.push({ name: 'ForgotPassword' })" />
</template>

<script>
// import axios from 'axios';
import { mapActions } from 'pinia';
import { useAuthStore } from '@/stores/auth';
import { signIn } from '@/services/auth';

// const apiKey = import.meta.env.VITE_GOOGLE_RECAPTCHA_KEY;

export default {
  name: 'SignInView',
  inject: ['showTermsDialog'],
  data() {
    return {
      user: {},
      alert: null,
    };
  },
  computed: {
    isFormValid() {
      return this.user.email
        && this.user.password;
    },
  },
  methods: {
    ...mapActions(useAuthStore, ['setUser']),
    async doLogin() {
      // await this.$recaptchaLoaded();

      // const token = await this.$recaptcha('login');
      // const { riskAnalysis } = await axios.post(`https://recaptchaenterprise.googleapis.com/v1/projects/letsjamchicago/assessments?key=${apiKey}`, {
      //   event: {
      //     token,
      //     siteKey: `${apiKey}`,
      //     expectedAction: 'login',
      //   },
      // });
      // if (riskAnalysis.score < 0.9) {
      //   console.log('robot!');
      // }

      try {
        const { user } = await signIn(this.user);
        this.setUser(user);
        this.$router.push({ name: 'Home' });
      } catch (error) {
        this.alert = {
          message: 'Could not sign you in. Please verify your email address and password and try again.',
          type: 'error',
        };
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.signin-card {
  max-width: 320px;
  margin-top: 1em;
  align-self: center;

  .footer-buttons {
    display: flex;
    justify-content: space-between;
  }
}

.terms-message {
  margin-top: 1em;
  font-size: 12px;
  white-space: nowrap;

  button {
    padding: 0;
    margin: 0;
  }
}

.alert-message {
  :deep(.p-message-text) {
    font-size: 12px;
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
