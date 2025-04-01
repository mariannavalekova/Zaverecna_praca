<template>
  <div class="visualization-view">
    <div
      class="hero"
      :style="{
        top: heroPosition.y + 'px',
        left: heroPosition.x + 'px',
        backgroundImage: 'url(' + heroImage + ')'
      }"
    ></div>

    <div
      v-for="(obs, i) in obstacles"
      :key="i"
      class="obstacle"
      :class="{ 'finish-obstacle': obs.type === 'finish' }"
      :style="{
        top: obs.position_y + 'px',
        left: obs.position_x + 'px'
      }"
    >
      <img :src="relativeImagePath(obs.image_path)" alt="obstacle" />
    </div>
  </div>
</template>

<script>
export default {
  props: ["heroPosition", "heroImage", "obstacles", "level"],
  methods: {
    relativeImagePath(fullPath) {
      if (!fullPath) return "";

      return fullPath.replace(/^http:\/\/localhost:\d+\//, "");
    },
  },
};
</script>

<style scoped>
.visualization-view {
  position: relative;
  width: 500px;
  height: 500px;
  background-image: url("/img/level_grid.png");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  overflow: hidden;
}

.hero {
  position: absolute;
  height: 66px;
  width: 45px;
  background-size: contain;
  background-repeat: no-repeat;
}

.obstacle {
  position: absolute;
}

.obstacle img {
  display: block;
}

</style>
