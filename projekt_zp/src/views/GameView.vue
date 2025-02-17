<template>
  <div id="game">
    <div class="assignment-text">
      <span v-if="level && level.description">
        {{ level.description }}
      </span>
      <span v-else>
        Loading or no description available...
      </span>
    </div>

    <div class="tangerine-count">
      Tangerines Collected: {{ tangerinesCollected }}
    </div>

    <div class="game-container">
      <div class="visualization-container">
        <VisualizationView
          :key="visualizationKey"
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
import { executePythonAsync } from "@/services/skulptRunner";
import { addCapyToSkulpt } from "@/services/capy";

import VisualizationView from "@/components/Visualization.vue";
import ErrorDisplayView from "@/components/ErrorDisplay.vue";
import CodeInputView from "@/components/CodeInput.vue";

import { useLoginStore } from "@/stores/loginStore"; 

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
      level: null,             
      obstacles: [],
      originalObstacles: [],   
      tangerinesCollected: 0,
      visualizationKey: 0,     

      userId: null,
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

    async executeUserCode(userCode) {
      if (!userCode || userCode.trim() === "") {
        this.errorMessage = "No code to execute. Please write some code.";
        return;
      }
      this.resetCapy();
      this.tangerinesCollected = 0;
      this.obstacles = JSON.parse(JSON.stringify(this.originalObstacles));
      this.visualizationKey++;

      this.errorMessage = "";
      try {
        addCapyToSkulpt(this);
        const result = await executePythonAsync(
          userCode,
          (result) => {
            console.log("Execution completed.", result);
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

    async fetchLevelData(levelId) {
      try {
        const response = await fetch(
          `/codebara-backend/level-api/GetLevelDetailsAPI.php?level_id=${levelId}`
        );
        const data = await response.json();
        if (data.error) {
          this.errorMessage = data.error;
          return;
        }

        this.level = data.level; 
        this.obstacles = data.obstacles || [];

        this.originalObstacles = JSON.parse(
          JSON.stringify(data.obstacles || [])
        );
      } catch (error) {
        console.error("Failed to load level data:", error);
        this.errorMessage = "Failed to load level data.";
      }
    },

    async levelCompleted() {
      if (this.tangerinesCollected < this.level.tangerine_count) {
        alert(
          `You need at least ${this.level.tangerine_count} tangerines to finish. Currently: ${this.tangerinesCollected}`
        );
        return;
      }

      try {
        const response = await fetch(
          "/codebara-backend/level-api/CompleteLevelAPI.php",
          {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              user_id: this.userId,            
              level_id: this.level.level_id,
            }),
          }
        );

        const data = await response.json();
        if (data.success) {
          alert("Level Completed!");
          this.$router.push("/student-dashboard");
        } else {
          this.errorMessage = data.error || "Error completing level.";
          alert(this.errorMessage);
        }
      } catch (err) {
        this.errorMessage = err.message || err.toString();
        alert(this.errorMessage);
      }
    },
  },

  mounted() {
    const loginStore = useLoginStore();
    this.userId = Number(loginStore.user_id) || null;
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

.tangerine-count {
  margin-bottom: 10px;
  font-size: 16px;
  font-weight: bold;
}

.visualization-container {
  width: 500px;
  height: 500px;
  min-width: 500px;
  min-height: 500px;
  border-right: 1px solid #ccc;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-shrink: 0;
  overflow: hidden;
  position: relative;
}

.input-container {
  width: 50%;
  min-width: 300px;
  max-width: 500px;
  height: 500px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 10px;
  box-sizing: border-box;
}

.game-container {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  min-width: 500px;
  flex-wrap: nowrap;
  overflow: hidden;
}

@media screen and (max-width: 900px) {
  .game-container {
    flex-direction: column;
    align-items: center;
  }
  .visualization-container {
    width: 500px;
    height: 500px;
    min-width: 500px;
    min-height: 500px;
    overflow: visible;
  }
  .input-container {
    width: 90%;
    max-width: 500px;
    height: 500px;
  }
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
