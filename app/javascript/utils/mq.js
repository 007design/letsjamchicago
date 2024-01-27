export default {
  data() {
    return {
      mqMobile: false,
    };
  },
  created() {
    window.addEventListener('resize', this.resizeHandler);
    this.resizeHandler();
  },
  methods: {
    resizeHandler() {
      this.mqMobile = document.documentElement.clientWidth < 768;
    },
  },
};
