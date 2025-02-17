<template>
  <div id="app" class="app-container">
    <Navigation />
    <main class="main-content">
      <RouterView />
    </main>
    <Footer />
  </div>
</template>

<script>
import { RouterView } from 'vue-router';
import Navigation from './components/Navigation.vue';
import Footer from './components/Footer.vue';


export default {
  components: {
    Navigation,
    Footer
  }
}
</script>
<style>
#app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #f5f4eb; 
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
</style>