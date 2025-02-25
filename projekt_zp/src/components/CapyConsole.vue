<template>
    <div class="capy-console-container">
      <div class="capy-console-image-wrap">
        <img 
          class="capy-console-image" 
          src="@/assets/capy_head.png" 
          alt="Capy"
        />
      </div>
  
      <div class="capy-console-bubble">
        <div 
          v-for="(msg, index) in messages" 
          :key="index" 
          class="bubble-line"
        >
          {{ msg }}
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: "CapyConsole",
    props: {
      messages: {
        type: Array,
        default: () => []
      },
    },
  };
  </script>
  
  <style scoped>
  .capy-console-container {
    display: flex;
    width: 100%;
    background-color: #f9f9f9;
    border: 1px solid #ccc;
    margin-top: 10px;
    padding: 10px;
    box-sizing: border-box;
    min-height: 100px; 
  }
  
  .capy-console-image-wrap {
    flex: 0 0 25%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin-right: 10px;
  }
  
  .capy-console-image {
    max-width: 100%;
    max-height: 80px; 
    object-fit: contain; 
  }
  
  .capy-console-bubble {
    flex: 1;              
    background-color: #fff;
    border-radius: 10px;
    padding: 10px;
    box-sizing: border-box;
    border: 1px solid #ddd;
    max-height: 150px;    
    overflow-y: auto;     
  }
  
  .bubble-line {
    margin-bottom: 5px;
    font-size: 14px;
    line-height: 1.4;
  }
  </style>
  