<template>
  <nav>
    <ul>
      <li>
        <Button
          link
          size="small"
          @click="() => $router.push({ name: 'NewEvent' })"
        >
          Create an Event
        </Button>
      </li>
      <li>
        <Button link size="small">
          Your Events
        </Button>
      </li>
      <li>
        <Button link size="small">
          Account Settings
        </Button>
      </li>
      <li>
        <Button link size="small">
          Help
        </Button>
      </li>
    </ul>
  </nav>
</template>

<script>
export default {
  name: 'UserToolbar',
};
</script>

<style lang="scss" scoped>
nav {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  padding: .25em 1em;
  background: white;
  box-shadow: 0 1px 3px rgba(0, 0, 0, .25);
  display: flex;
  justify-content: center;
  align-items: center;
}

ul {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;

  li {
    padding: 0 .75em;

    .mobile & {
      padding: 0 .5em;
    }

    &:first-of-type {
      padding-left: 0;
    }

    &:last-of-type {
      padding-right: 0;
    }
  }

  button {
    padding: 0;

    .mobile & {
      font-size: 12px;
    }
  }
}

.p-button.p-button-link {
  color: #44B6E5;
  background: transparent;
}
</style>
