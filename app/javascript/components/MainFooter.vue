<template>
  <div class="main-footer">
    <ul>
      <li>
        <Button
          class="footer-button"
          label="Terms of Use"
          link
          @click="showTermsDialog"
        />
        <Button
          class="footer-button"
          label="Privacy Policy"
          link
          @click="showPolicyDialog"
        />
        <Button
          class="footer-button"
          label="Help / About"
          link
          @click="() => $router.push({ name: 'About' })"
        />
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'MainFooter',
  inject: [
    'showTermsDialog',
    'showPolicyDialog',
  ],
};
</script>

<style lang="scss" scoped>
.main-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  display: flex;
  justify-content: center;
  background: #44B6E5;
  padding-bottom: .5em;
}

ul {
  list-style: none;
  display: flex;
  margin: 0;
  padding: 0;
}

.footer-button {
  color: white;
  padding: 0;
  margin: 0 1em;
  font-size: 12px;
}
</style>
