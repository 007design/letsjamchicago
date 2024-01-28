<template>
  <Card class="register-card">
    <template #content>
      <div class="flex flex-column gap-1 mb-2">
        <label for="name" class="text-sm">Your name</label>
        <InputText id="name" type="text" v-model="user.name" />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="email" class="text-sm">Email address</label>
        <InputText id="email" type="text" v-model="user.email" />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="password" class="text-sm">Password</label>
        <InputText id="password" type="password" v-model="user.password" />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="confirmPassword" class="text-sm">Retype password</label>
        <InputText id="confirmPassword" type="password" v-model="confirmPassword" />
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
        <Button label="Register" @click="doLogin" :disabled="!isFormValid" />
      </div>
      <div class="terms-message">
        By using this site you agree to the
        <Button label="Terms of Use" link @click="showTermsDialog()" />
      </div>
    </template>
  </Card>
</template>

<script>
import { signUp, setSignedIn } from '@/services/auth';

export default {
  name: 'RegisterView',
  inject: ['showTermsDialog'],
  data() {
    return {
      user: {},
      confirmPassword: '',
      alert: null,
    };
  },
  computed: {
    isFormValid() {
      return this.user.name
        && this.user.email
        && this.user.password
        && this.user.password.length > 5
        && this.user.password === this.confirmPassword;
    },
  },
  methods: {
    async doLogin() {
      try {
        const user = await signUp(this.user);

        setSignedIn(user);
        document.location.href = '/';
      } catch {
        this.alert = {
          message: 'Could not sign you up. Please verify your email address and password and try again.',
          type: 'error',
        };
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.register-card {
  max-width: 320px;
  margin-top: 1em;
  align-self: center;

  .footer-buttons {
    display: flex;
    justify-content: right;
  }
}

.alert-message {
  :deep(.p-message-text) {
    font-size: 12px;
  }
}

.terms-message {
  margin-top: 1em;
  font-size: 12px;

  button {
    padding: 0;
    margin: 0;
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
