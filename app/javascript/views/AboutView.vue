<template>
  <TabView class="about-tabs">
    <TabPanel header="About">
      I made a thing
    </TabPanel>
    <TabPanel header="Help">
      Don't @ me
    </TabPanel>
    <TabPanel header="Contribute">
      Buy me a beer
    </TabPanel>
  </TabView>
</template>

<script>
export default {
  name: 'AboutView',
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
</style>
