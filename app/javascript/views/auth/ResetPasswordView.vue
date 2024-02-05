<template>
  <div class="update-user-view">
    <Card class="update-user-card">
      <template #header>
        <h3>Update your password</h3>
      </template>
      <template #content>
        <div class="flex flex-column gap-1 mb-2">
          <label for="newPassword" class="text-sm">New password</label>
          <InputText id="newPassword" type="password" v-model="user.newPassword" />
        </div>
        <div class="flex flex-column gap-1 mb-2">
          <label for="confirmPassword" class="text-sm">Retype new password</label>
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
          <Button label="Update password" @click="doUpdate" :disabled="!isFormValid" />
        </div>
      </template>
    </Card>
  </div>
</template>

<script>
import { mapActions } from 'pinia';
import { useAuthStore } from '@/stores/auth';
import { updateUser } from '@/services/auth';

export default {
  name: 'ResetPasswordView',
  props: {
    token: {
      type: String,
      required: true,
    },
  },
  data(vm) {
    return {
      user: {
        reset_password_token: vm.token,
      },
      alert: null,
      confirmPassword: null,
    };
  },
  computed: {
    isFormValid() {
      return (this.token ? true : this.user.current_password)
        && this.user.newPassword
        && this.user.newPassword.length > 5
        && this.user.newPassword === this.confirmPassword;
    },
  },
  methods: {
    ...mapActions(useAuthStore, ['setUser']),
    async doUpdate() {
      try {
        const { user } = await updateUser({
          ...this.user,
          password: this.user.newPassword,
        });
        this.setUser(user);
        this.alert = {
          message: 'Password updated successfully',
          type: 'success',
        };
      } catch (error) {
        this.alert = {
          message: 'Could not update your password. Please check your current password and try again.',
          type: 'error',
        };
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.update-user-view {
  display: flex;
  flex-direction: column;
  align-items: center;
}

h3 {
  margin-left: 1em;
}

.p-button {
  background: #44B6E5;
  border-color: #44B6E5;
}

.update-user-card {
  width: 100%;
  max-width: 320px;
  margin-top: 1em;

  button {
    width: 100%;
  }
}

.alert-message {
  :deep(.p-message-text) {
    font-size: 12px;
  }
}
</style>
