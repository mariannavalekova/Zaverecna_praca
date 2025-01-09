<template>
  <div id="game">
    <div class="assignment-text">
      Write code to move around the stone and reach the orange. 
    </div>
    <div class="game-container">
      <div class="visualization-container">
        <VisualizationView :heroPosition="heroPosition" :heroImage="heroImage" />
      </div>
      <div class="input-container">
        <ErrorDisplayView :errorMessage="errorMessage" />
        <CodeInputView @executeCode="executeUserCode" />
      </div>
    </div>
  </div>
</template>

<script>
import { executePythonSync } from "@/services/skulptRunner";
import { addCapyToSkulpt } from "@/services/capy";
import VisualizationView from "@/components/Visualization.vue";
import ErrorDisplayView from "@/components/ErrorDisplay.vue";
import CodeInputView from "@/components/CodeInput.vue";

export default {
  components: {
    VisualizationView,
    ErrorDisplayView,
    CodeInputView,
  },
  data() {
    return {
      heroPosition: { x: 100, y: 100 },
      heroImage: "/src/assets/idle.gif",
      errorMessage: "",
    };
  },
  methods: {
    smoothMove(newX, newY, duration = 800) {
      const startX = this.heroPosition.x;
      const startY = this.heroPosition.y;
      const startTime = performance.now();

      const animate = (currentTime) => {
        const elapsed = currentTime - startTime;
        const fraction = Math.min(elapsed / duration, 1);

        const currentX = startX + (newX - startX) * fraction;
        const currentY = startY + (newY - startY) * fraction;

        this.heroPosition = { x: currentX, y: currentY };

        if (fraction < 1) {
          requestAnimationFrame(animate);
        }
      };

      requestAnimationFrame(animate);
    },

    updateHeroAnimation(animation) {
      const animations = {
        idle: "/src/assets/idle.gif",
        moveu: "/src/assets/moveu.gif",
        moved: "/src/assets/moved.gif",
        mover: "/src/assets/mover.gif",
        movel: "/src/assets/movel.gif",
        jump: "/src/assets/jump.gif",
        pickup: "/src/assets/pickup.gif",
        hide: "/src/assets/hide.gif",
        eat: "/src/assets/eat.gif",
      };

      this.heroImage = animations[animation] || "/src/assets/idle.gif";
    },

    resetCapy() {
      this.heroPosition = { x: 100, y: 100 };
      this.heroImage = "/src/assets/idle.gif";
    },

    executeUserCode(userCode) {
      if (!userCode || userCode.trim() === "") {
        this.errorMessage = "No code to execute. Please write some code.";
        return;
      }

      this.resetCapy();

      this.errorMessage = "";

      try {
        addCapyToSkulpt(this);
        const result = executePythonSync(
          userCode,
          () => {
            console.log("Execution completed.");
          },
          (err) => {
            console.error(err.toString());
            this.errorMessage = err.toString();
          }
        );

        console.log("Python execution result:", result);
      } catch (error) {
        this.errorMessage = error.message || error.toString();
        console.error("Execution error:", error);
      }
    },
  },
};
</script>

<style scoped>
#game {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
}

h1 {
  margin-bottom: 20px;
  font-size: 2em;
}

.assignment-text {
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

.game-container {
  display: flex;
  width: 80%; 
  max-width: 1400px; 
  height: 80vh; 
  border: 1px solid #ccc;
  border-radius: 8px;
  overflow: hidden;
}

.visualization-container {
  width: 50%;
  background-color: #f4f4f4;
  display: flex;
  justify-content: center;
  align-items: center;
  border-right: 1px solid #ccc;
}

.input-container {
  width: 50%;
  display: flex;
  flex-direction: column;
  padding: 10px;
  box-sizing: border-box;
}

.error-display {
  flex-shrink: 0;
  margin-bottom: 10px;
}

textarea {
  flex-grow: 1;
  resize: none;
  width: 100%;
  height: 100%;
  margin-top: 10px;
}
</style>
