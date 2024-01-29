<template>
  <TabView class="about-tabs">
    <TabPanel header="About">
      This is obviously not done. Still to do:
      <ul>
        <li>Terms and Privacy Policy</li>
        <li>Update password functionality</li>
        <li>Registration confirmation (email and page)</li>
        <li>Add to calendar button</li>
        <li>Better exception handling</li>
        <li>Recaptcha</li>
      </ul>
    </TabPanel>
    <TabPanel header="Help">
      <div class="help-tab">
        <Card class="contact-card">
          <template #header>
            <h3>Email me</h3>
          </template>
          <template #content>
            <div class="flex flex-column gap-1 mb-2">
              <label for="name" class="text-sm">Your name</label>
              <InputText
                v-if="user"
                id="name"
                type="text"
                v-model="emailUser.name"
                disabled
              />
              <InputText
                v-else
                id="name"
                type="text"
                v-model="emailUser.name"
              />
            </div>
            <div class="flex flex-column gap-1 mb-2">
              <label for="email" class="text-sm">Your email</label>
              <InputText
                v-if="user"
                id="email"
                type="text"
                v-model="emailUser.email"
                disabled
              />
              <InputText
                v-else
                id="email"
                type="text"
                v-model="emailUser.email"
              />
            </div>
            <div class="flex flex-column gap-1 mb-2">
              <label for="message" class="text-sm">What do you want to say?</label>
              <Textarea id="message" v-model="message" auto-resize rows="5" />
            </div>
          </template>
          <template #footer>
            <div class="footer-buttons">
              <Button label="Send email" @click="sendEmail" :disabled="!isFormValid" />
            </div>
          </template>
        </Card>
      </div>
      <Message
        v-if="alert"
        :severity="alert.type"
        class="alert-message"
        @close="alert = null"
      >
        {{ alert.message }}
      </Message>
    </TabPanel>
    <TabPanel header="Contribute">
      Buy me a beer
    </TabPanel>
  </TabView>
</template>

<script>
import { mapState } from 'pinia';
import { sendContactEmail } from '@/services/auth';
import { useAuthStore } from '@/stores/auth';

export default {
  name: 'AboutView',
  data() {
    return {
      alert: null,
      emailUser: {},
      message: '',
    };
  },
  computed: {
    ...mapState(useAuthStore, ['user']),
    isFormValid() {
      return this.emailUser.email
        && this.emailUser.name
        && this.message.length;
    },
  },
  watch: {
    user() {
      if (this.user) {
        this.emailUser.name = this.user.name;
        this.emailUser.email = this.user.email;
      }
    },
  },
  methods: {
    async sendEmail() {
      try {
        await sendContactEmail({
          name: this.emailUser.name,
          email: this.emailUser.email,
          message: this.message,
        });
        this.alert = {
          message: 'Email sent successfully.',
          type: 'success',
        };
      } catch {
        this.alert = {
          message: 'Could not send email.',
          type: 'error',
        };
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.about-tabs {
  :deep(.p-tabview-nav-link) {
    color: #44B6E5;
  }

  :deep(.p-tabview-ink-bar) {
    background-color: #44B6E5;
  }
}

h3 {
  margin-left: 1em;
}

.footer-buttons {
  text-align: right;
}

.p-button {
  background: #44B6E5;
  border-color: #44B6E5;
}
</style>
