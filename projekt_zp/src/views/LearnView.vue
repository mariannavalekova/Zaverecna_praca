<template>
    <div class="learn">
      <div class="sidebar">
        <ChapterMenu />
      </div>
      <div class="content">
        <Lecture />
      </div>
    </div>
  </template>
  
  <script>
  import ChapterMenu from '@/components/ChapterMenu.vue';
  import Lecture from '@/components/Lecture.vue';
  
  export default {
    components: {
      ChapterMenu,
      Lecture,
    },
  };
  </script>
  
  <style scoped>
  .learn {
    display: flex;
    background-color: #f5f4eb;
    height: 100vh;
  }
  
  .sidebar {
    width: 20%;
    display: flex;
    flex-direction: column;
    padding: 10px;
    box-sizing: border-box;
    background: #f3d3a47e;
  }
  
  .content {
    flex: 1;
    padding: 10px;
    box-sizing: border-box;
  }
  </style>
  