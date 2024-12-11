<template>
    <div v-if="errorMessage" class="error-display">
      <h2>Error</h2>
      <p>{{ errorMessage }}</p>
    </div>
  </template>
  
  <script>
  export default {
    props: ["errorMessage"],
  };
  </script>
  
  <style scoped>
.error-display {
  background-color: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
  border-radius: 4px;
  padding: 16px;
  margin: 0;
  width: 100%;
  box-sizing: border-box;
}
h2 {
  margin: 0 0 10px 0;
  font-size: 16px;
}
</style>