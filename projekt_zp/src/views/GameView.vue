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
        <CapyConsole :messages="capyMessages" />
      </div>
    </div>

    <LevelHint v-if="level" :hint="level.level_hint" />
  </div>
</template>

<script>
import { executePythonAsync } from "@/services/skulptRunner";
import { addCapyToSkulpt } from "@/services/capy";
import VisualizationView from "@/components/Visualization.vue";
import ErrorDisplayView from "@/components/ErrorDisplay.vue";
import CodeInputView from "@/components/CodeInput.vue";
import CapyConsole from "@/components/CapyConsole.vue";
import LevelHint from "@/components/LevelHint.vue"; 

import { useLoginStore } from "@/stores/loginStore"; 

export default {
  name: "GameView",
  components: {
    VisualizationView,
    ErrorDisplayView,
    CodeInputView,
    CapyConsole,
    LevelHint, 
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
      capyMessages: [],
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

    updateHeroAnimation(animationKey) {
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
      this.heroImage = animations[animationKey] || "/src/assets/idle.gif";
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
      this.capyMessages = [];

      try {
        addCapyToSkulpt(this);
        const result = await executePythonAsync(
          userCode,
          (res) => {
            console.log("Execution completed.", res);
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
        const response = await fetch("/codebara-backend/level-api/CompleteLevelAPI.php", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            user_id: this.userId,
            level_id: this.level.level_id,
          }),
        });
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

.game-container {
  width: 80%;
  max-width: 1400px;
  display: flex;
  flex-direction: row;
  overflow: hidden;
  margin-bottom: 20px;
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
  flex: 1;
  min-width: 300px;
  display: flex;
  flex-direction: column;
  padding: 10px;
  box-sizing: border-box;
  height: 500px;
}

.input-container textarea {
  height: 250px !important;
  max-height: 250px;
}

.error-display {
  margin-bottom: 10px;
}


@media screen and (max-width: 900px) {
  .game-container {
    flex-direction: column;
    width: 90%;
  }
  .visualization-container,
  .input-container {
    width: 100%;
    height: auto;
    margin-bottom: 20px;
  }
}
</style>
