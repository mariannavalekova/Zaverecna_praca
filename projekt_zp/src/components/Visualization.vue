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
    background-color: #c4f5ff; 
    overflow: hidden;
  }
  
  .hero {
    position: absolute;
    width: 80px;
    height: 80px;
    background-size: contain;
    background-repeat: no-repeat;
   /* transition: all 0.5s ease-in-out; Smooth movement */
  }
  </style>
  