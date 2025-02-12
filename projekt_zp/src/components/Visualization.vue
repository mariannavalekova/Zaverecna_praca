<template>
  <div class="visualization-view">
    <!-- The background image (level background, if any) -->
    <div
      class="hero"
      :style="{
        top: heroPosition.y + 'px',
        left: heroPosition.x + 'px',
        backgroundImage: 'url(' + heroImage + ')',
      }"
    ></div>

    <!-- Obstacles -->
    <div
      v-for="(obs, i) in obstacles"
      :key="i"
      class="obstacle"
      :style="{
        top: obs.position_y + 'px',
        left: obs.position_x + 'px',
        backgroundImage: 'url(' + relativeImagePath(obs.image_path) + ')'
      }"
    >
    </div>
  </div>
</template>

<script>
export default {
  props: ["heroPosition", "heroImage", "obstacles", "level"],
  methods: {
    relativeImagePath(fullPath) {
      if (!fullPath) return "";
      // Example to remove "http://localhost:5173/"
      return fullPath.replace(/^http:\/\/localhost:\d+\//, "");
    },
  },
};
</script>

<style scoped>
.visualization-view {
  position: relative;
  width: 700px;   /* fixed width matching the level editor */
  height: 700px;  /* fixed height matching the level editor */
  background-image: url("/src/assets/rb_1308.png");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  overflow: hidden;
}

.hero {
  position: absolute;
  width: 100px;
  height: 100px;
  background-size: contain;
  background-repeat: no-repeat;
}

/* style the obstacles */
.obstacle {
  position: absolute;
  width: 80px;
  height: 80px;
  background-size: contain;
  background-repeat: no-repeat;
}
</style>