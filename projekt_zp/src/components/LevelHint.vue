<template>
    <div class="level-hint-container">
      <h3>Hint</h3>
      <p v-if="hint">{{ hint }}</p>
      <p v-else>No hint provided.</p>
    </div>
  </template>
  
  <script>
  export default {
    name: "LevelHint",
    props: {
      hint: {
        type: String,
        default: "",
      },
    },
  };
  </script>
  
  <style scoped>
  .level-hint-container {
    width: 80%;
    max-width: 1400px;
    padding: 15px;
    margin: 10px 0;
    border: 1px solid #eba857; 
    border-radius: 8px;
    background-color: #f5d1a3; 
    color: #3e2c17;            
    font-size: 18px;           
    font-weight: bold;         
    text-align: center;        
    box-sizing: border-box;
  }
  
  .level-hint-container h3 {
    margin-bottom: 8px;
    font-size: 20px; 
    font-weight: bold;
  }
  </style>
  