<template>
  <div class="update-user-view">
    <Card class="update-user-card">
      <template #header>
        <h3>Update your password</h3>
      </template>
      <template #content>
        <div class="flex flex-column gap-1 mb-2">
          <label for="password" class="text-sm">Current password</label>
          <InputText id="password" type="password" v-model="user.current_password" />
        </div>
        <div class="flex flex-column gap-1 mb-2">
          <label for="password" class="text-sm">New password</label>
          <InputText id="password" type="password" v-model="user.new_password" />
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
import { updateUser, setSignedIn } from '@/services/auth';

export default {
  name: 'EditUserView',
  data() {
    return {
      user: {},
      alert: null,
      confirmPassword: null,
    };
  },
  computed: {
    isFormValid() {
      return this.user.current_password
        && this.user.new_password
        && this.user.new_password.length > 5
        && this.user.new_password === this.confirmPassword;
    },
  },
  methods: {
    async doUpdate() {
      try {
        const { user } = await updateUser(this.user);
        setSignedIn(user);
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
  justify-content: center;
}

.update-user-card {
  max-width: 320px;
  margin-top: 1em;

  .footer-buttons {
    display: flex;
    justify-content: space-between;
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
</style>
