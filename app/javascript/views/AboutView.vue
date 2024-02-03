<template>
  <TabView class="about-tabs">
    <TabPanel header="About">
      <p>This site is, and will always be, free to use and ad-free.
        I created it primarily to find other, local musicians for me to jam with
        after failing to do so via Craigslist and Meetup and so forth.</p>
      <p>Please be respectful and polite. Don't try and post some hateful nonsense,
        I'll just remove it and ban you. If your event is at a bar or something where kids
        aren't allowed, please note that in the description. If you want to exclude people
        for any other reason, go somewhere else.</p>
      <p><strong>Don't be that guy/gal!</strong></p>
      <p>I'll never sell or disclose your information, email address, etc.
        I'm not out to make a dime, I just want to help musicians find each other so we can
        all become better, happier musicians. If you feel like contributing, the project is
        open source and on Github. Check out the Contribute tab above.</p>

      <Divider />

      This is not done. Still to do:
      <ul>
        <li>Better exception handling</li>
        <li>Recaptcha</li>
        <li>About etc. wording</li>
      </ul>
    </TabPanel>
    <TabPanel header="Contact">
      <div class="help-tab">
        <Message
          v-if="alert"
          :severity="alert.type"
          class="alert-message"
          @close="alert = null"
        >
          {{ alert.message }}
        </Message>
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
    user: {
      handler() {
        if (this.user) {
          this.emailUser.name = this.user.name;
          this.emailUser.email = this.user.email;
        }
      },
      immediate: true,
    },
  },
  methods: {
    async sendEmail() {
      try {
        await sendContactEmail({
          from: this.emailUser.name,
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

:deep(.p-message-text) {
  flex: 1;
}
</style>
