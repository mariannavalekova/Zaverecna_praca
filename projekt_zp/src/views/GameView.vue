<template>
  <div id="game">
    <!-- Display the level description from the database -->
    <div class="assignment-text">
      <span v-if="level && level.description">
        {{ level.description }}
      </span>
      <span v-else>
        Loading or no description available...
      </span>
    </div>

    <div class="game-container">
      <div class="visualization-container">
        <!-- Pass the loaded obstacles and level data into Visualization -->
        <VisualizationView
          :heroPosition="heroPosition"
          :heroImage="heroImage"
          :obstacles="obstacles"
          :level="level"
        />
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

      level: null, // e.g. { level_id, title, description }
      obstacles: [], // array of obstacles
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
          () => { console.log("Execution completed."); },
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

    async fetchLevelData(levelId) {
      try {
        const response = await fetch(`/codebara-backend/level-api/GetLevelDetailsAPI.php?level_id=${levelId}`);
        const data = await response.json();
        if (data.error) {
          this.errorMessage = data.error;
          return;
        }
        // Store the loaded data in local state
        this.level = data.level;
        this.obstacles = data.obstacles || [];
      } catch (error) {
        console.error("Failed to load level data:", error);
        this.errorMessage = "Failed to load level data.";
      }
    },
  },

  mounted() {
    const levelId = this.$route.params.level_id || 2;
    this.fetchLevelData(levelId);
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
  height: 80vh; /* or you can remove this so it doesn't constrain the 700x700 view */
  border: 1px solid #ccc;
  border-radius: 8px;
  overflow: hidden;
}

/* The left half container that houses the 700x700 area */
.visualization-container {
  display: flex;
  justify-content: center;
  align-items: center;
  border-right: 1px solid #ccc;
  width: 50%;
  /* You could let it auto-size around 700x700 or keep fixed constraints. 
     For example: min-width: 700px; if you want enough space. */
}

.input-container {
  width: 50%;
  display: flex;
  flex-direction: column;
  padding: 10px;
  box-sizing: border-box;
}

.error-display {
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