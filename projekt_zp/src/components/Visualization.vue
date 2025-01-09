<template>
    <div class="visualization-view">
      <div
        class="hero"
        :style="{
          top: heroPosition.y + 'px',
          left: heroPosition.x + 'px',
          backgroundImage: 'url(' + heroImage + ')',
        }"
      ></div>
    </div>
  </template>
  
  <script>
  export default {
    props: ["heroPosition", "heroImage"],
  };
  </script>
  
  <style scoped>
  .visualization-view {
  position: relative;
  width: 100%;
  height: 100%;
  background-image: url("src/assets/rb_1308.png");
  background-size: cover; /* Ensures the image covers the entire div */
  background-position: center; /* Centers the image in the div */
  background-repeat: no-repeat; /* Prevents the image from repeating */
  overflow: hidden;
}
  
  .hero {
    position: absolute;
    width: 100px;
    height: 100px;
    background-size: contain;
    background-repeat: no-repeat;
   /* transition: all 0.5s ease-in-out; Smooth movement */
  }
  </style>
  