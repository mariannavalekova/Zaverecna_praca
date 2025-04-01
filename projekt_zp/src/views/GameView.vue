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
      heroPosition: { x: 53, y: 55 },
      heroImage: "/img/idle.png",
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
      if (animationKey === "movel") {
        this.heroImage = "/img/left.png";
      } else if (animationKey === "mover") {
        this.heroImage = "/img/right.png";
      } else {
        this.heroImage = "/img/idle.png";
      }
    },

    resetCapy() {
      this.heroPosition = { x: 53, y: 55 };
      this.heroImage = "/img/idle.png";
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
        await executePythonAsync(
          userCode,
          (res) => {
            console.log("Execution completed.");
          },
          (err) => {
            this.errorMessage = err.toString();
          }
        );
      } catch (error) {
        this.errorMessage = error.message || error.toString();
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
        this.originalObstacles = JSON.parse(JSON.stringify(data.obstacles || []));
      } catch (error) {
        console.error("Failed to load level data:");
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
