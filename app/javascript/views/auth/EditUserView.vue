<template>
  <div class="update-user-view">
    <Card class="preferences-card">
      <template #content>
        <div class="flex flex-column gap-1 mb-2">
          <label for="username" class="text-sm">Your name</label>
          <InputGroup class="inline-update">
            <InputText id="username" v-model="updatedUser.name" />
            <Button
              v-if="updatedUser.name !== user.name"
              icon="pi pi-check"
              severity="success"
              @click="doUpdateUser"
            />
            <Button
              v-else
              icon="pi pi-check"
              severity="success"
              disabled
            />
          </InputGroup>
        </div>
        <div class="flex flex-column gap-1 mb-2">
          <label for="email" class="text-sm">Your email (cannot be changed)</label>
          <InputText id="email" v-model="user.email" disabled />
        </div>
        <div class="flex align-items-top mt-4">
          <Checkbox
            v-model="updatedUser.show_attending"
            inputId="showAttending"
            :binary="true"
            @change="doUpdateUser"
          />
          <label for="showAttending" class="ml-2">
            Allow signed-in users to see that I'm attending an event.
          </label>
        </div>
        <div class="flex flex-column gap-1 mt-3">
          <div class="input-header">
            <label for="neighborhood" class="text-sm">Your neighborhood(s)</label>
            <Badge
              value="?"
              severity="info"
              @click="toggleNeighborhoodTooltip"
            />
          </div>
          <MultiSelect
            v-model="updatedUser.neighborhoods"
            display="chip"
            :options="neighborhoods"
            :show-toggle-all="false"
            filter
            placeholder="Select neighborhood(s)"
            @update:modelValue="doUpdateUser"
          />
          <OverlayPanel ref="neighborhoodTooltip">
            Select a neighborhood to help local musicians find you.
          </OverlayPanel>
        </div>
      </template>
    </Card>
    <Panel
      class="update-password-panel"
      toggleable
      collapsed
    >
      <template #header>
        <h3>Update your password</h3>
      </template>
      <div class="flex flex-column gap-1 mb-2">
        <label for="password" class="text-sm">Current password</label>
        <InputText id="password" type="password" v-model="currentPassword" />
      </div>
      <div class="flex flex-column gap-1 mb-2">
        <label for="newPassword" class="text-sm">New password</label>
        <InputText id="newPassword" type="password" v-model="newPassword" />
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
      <div class="footer-buttons">
        <Button
          class="update-password-button"
          label="Update password"
          @click="doUpdatePassword"
          :disabled="!isPasswordFormValid"
        />
      </div>
    </Panel>
    <Panel
      class="delete-user-panel"
      toggleable
      collapsed
    >
      <template #header>
        <h3>Delete your account</h3>
      </template>
      <p><strong>This cannot be undone!</strong></p>
      <p>All events you have created will also be deleted
        and you will be removed from any events you are attending.</p>
      <div class="footer-buttons">
        <Button class="delete-button" label="Delete" @click="doDelete" />
      </div>
    </Panel>
  </div>
  <ConfirmDialog></ConfirmDialog>
</template>

<script>
import { mapActions, mapState } from 'pinia';
import { useAuthStore } from '@/stores/auth';
import { updateUser, deleteUser, signOut } from '@/services/auth';
import { neighborhoods } from '@/utils/common';

export default {
  name: 'EditUserView',
  data() {
    return {
      updatedUser: {},
      alert: null,
      currentPassword: null,
      newPassword: null,
      confirmPassword: null,
      neighborhoods,
    };
  },
  computed: {
    ...mapState(useAuthStore, ['user']),
    isPasswordFormValid() {
      return this.newPassword
        && this.newPassword.length > 5
        && this.newPassword === this.confirmPassword;
    },
  },
  watch: {
    user: {
      handler() {
        const { id, ...user } = this.user;

        const replaced = user.neighborhoods
          ? user.neighborhoods.replace(/\\"/g, '"').replace(/^["|']\[/, '[').replace(/\]["|']$/, ']')
          : [];

        this.updatedUser = {
          ...user,
          neighborhoods: JSON.parse(replaced),
        };
      },
      immediate: true,
    },
  },
  methods: {
    ...mapActions(useAuthStore, ['setUser']),
    toggleNeighborhoodTooltip(e) {
      this.$refs.neighborhoodTooltip.toggle(e);
    },
    async doUpdateUser() {
      try {
        const user = await updateUser({
          ...this.updatedUser,
          neighborhoods: JSON.stringify(this.updatedUser.neighborhoods),
        });
        this.setUser(user);
      } catch {
        this.alert = {
          message: 'Could not update your name.',
          type: 'error',
        };
      }
    },
    async doUpdatePassword() {
      try {
        const user = await updateUser({
          ...this.user,
          current_password: this.currentPassword,
          password: this.newPassword,
        });
        this.setUser(user);
        this.alert = {
          message: 'Password updated successfully',
          type: 'success',
        };

        this.currentPassword = null;
        this.newPassword = null;
        this.confirmPassword = null;
      } catch {
        this.alert = {
          message: 'Could not update your password. Please check your current password and try again.',
          type: 'error',
        };
      }
    },
    async doDelete() {
      this.$confirm.require({
        message: 'Are you sure you want to delete your account? This cannot be undone!',
        header: 'Confirmation',
        icon: 'pi pi-exclamation-triangle',
        rejectClass: 'p-button-secondary p-button-outlined',
        rejectLabel: 'Go back',
        acceptClass: 'p-button-danger delete-button',
        acceptLabel: 'Delete account',
        accept: async () => {
          try {
            await deleteUser();
            await signOut();
            document.location.href = '/';
          } catch {
            this.$toast.add({
              severity: 'danger',
              summary: 'Error',
              detail: 'Could not delete your account. Please sign in again.',
              life: 3000,
            });
          }
        },
      });
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
  margin: 0;
}

.update-password-button {
  background: #44B6E5;
  border-color: #44B6E5;
}

.preferences-card,
.update-password-panel,
.delete-user-panel {
  width: 100%;
  max-width: 320px;
  margin-top: 1em;

  button {
    width: 100%;
  }
}

.input-header {
  .p-badge {
    cursor: pointer;
  }
}

.delete-button {
  color: white;
  background: red;
  border-color: red;
}

.inline-update {
  input {
    flex: 1 0 auto;
  }
  button {
    flex: 0;
    padding: 0 .5em;
  }
}

.alert-message {
  :deep(.p-message-text) {
    font-size: 12px;
  }
}
</style>
