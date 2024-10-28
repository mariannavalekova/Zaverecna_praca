<template>
  <div id="app">
    <div class="main-container">
      <div class="canvas-section">
        <Canvas ref="canvas"/>
      </div>
      <div class="editor-section">
        <TextArea @executeCommands="executeCommands" />
      </div>
    </div>
    <div class="console-section">
      just a plain area for thoughts and stuff :)
    </div>
  </div>
</template>

<script>
import TextArea from "../components/TextArea.vue";
import Canvas from "../components/GameCanvas.vue";

export default {
  components: {
    TextArea,
    Canvas,
  },
  methods: {
    executeCommands(commands) {
      console.log("Executing Commands:", commands); 
      this.$refs.canvas.runCommands(commands);
    },
  },
};
</script>
<style scoped>

.main-container {
  display: flex;
  height: 70vh; 
}


.canvas-section {
  flex: 2;
  background-color: #c6ff90; 
  display: flex;
  justify-content: center;
  align-items: center;
  border-right: 2px solid #333; 
}


.editor-section {
  flex: 1;
  background-color: #ffffff; 
  display: flex;
  justify-content: center;
  align-items: center;
}


.console-section {
  height: 30vh; 
  background-color: #e8e4d1; 
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 1.2em;
  color: #333;
  border-top: 2px solid #333; 
}
</style>
