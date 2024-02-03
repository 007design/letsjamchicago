<template>
  <Card class="forgot-card">
    <template #content>
      <div class="flex flex-column gap-1 mb-2">
        <label for="email" class="text-sm">Email address</label>
        <InputText id="email" type="text" v-model="user.email" />
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
        <Button label="Reset password" @click="doResetPassword" />
      </div>
    </template>
  </Card>
</template>

<script>
import { forgotPassword } from '@/services/auth';

export default {
  name: 'ForgotPasswordView',
  data() {
    return {
      user: {},
      alert: null,
    };
  },
  computed: {
    isFormValid() {
      return this.user.email;
    },
  },
  methods: {
    async doResetPassword() {
      try {
        await forgotPassword(this.user);
        this.alert = {
          message: 'A link to reset your password has been emailed to you. Please check your spam folder.',
          type: 'success',
        };
      } catch (error) {
        this.alert = {
          message: 'An error occurred. Please verify your email address and try again.',
          type: 'error',
        };
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.forgot-card {
  max-width: 320px;
  margin-top: 1em;
  align-self: center;

  .footer-buttons {
    display: flex;
    justify-content: end;
  }
}

.alert-message {
  :deep(.p-message-text) {
    font-size: 12px;
  }
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
