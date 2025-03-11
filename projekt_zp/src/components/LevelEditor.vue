<template>
  <div class="level-editor-container">
    <h2>Edit Level</h2>

    <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>
    <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>

    <div class="mb-3">
      <label for="levelTitle" class="form-label">Level Title</label>
      <input
        type="text"
        class="form-control"
        id="levelTitle"
        v-model="form.title"
      />
    </div>

    <div class="mb-3">
      <label for="levelDescription" class="form-label">Level Description</label>
      <textarea
        class="form-control"
        id="levelDescription"
        rows="3"
        v-model="form.description"
      ></textarea>
    </div>

    <div class="mb-3">
      <label for="tangerineCount" class="form-label">Tangerine Count</label>
      <input
        type="number"
        class="form-control"
        id="tangerineCount"
        v-model.number="form.tangerine_count"
      />
    </div>

    <div class="mb-3">
      <label for="levelHint" class="form-label">Level Hint</label>
      <textarea
        class="form-control"
        id="levelHint"
        rows="2"
        v-model="form.level_hint"
      ></textarea>
    </div>

    <div class="obstacle-toolbar">
      <h5>Place Obstacles:</h5>
      <button
        v-for="(item, index) in obstacleItems"
        :key="index"
        class="btn btn-sm btn-secondary me-2"
        @click="addObstacle(item)"
      >
        <img :src="item.image_path" alt="obstacle" class="toolbar-icon" />
        {{ item.label }}
      </button>
    </div>

    <div class="mb-3">
      <button
        @click="toggleDeletionMode"
        :class="['btn', isDeletionMode ? 'btn-warning' : 'btn-outline-warning']"
      >
        {{ isDeletionMode ? 'Exit Deletion Mode' : 'Enter Deletion Mode' }}
      </button>
    </div>

    <v-stage
      class="konva-stage"
      :config="{ width: stageWidth, height: stageHeight }"
    >
      <v-layer>
        <v-image
          v-if="backgroundImage"
          :config="{
            x: 0,
            y: 0,
            image: backgroundImage,
            width: stageWidth,
            height: stageHeight,
            listening: false
          }"
        />
        <v-image
          v-for="(obs, i) in obstacles"
          :key="i"
          :config="{
            x: obs.x,
            y: obs.y,
            image: obs.imageObj,
            draggable: true,
            name: obs.type
          }"
          @dragend="onObstacleDragEnd($event, obs)"
          @click="onObstacleClick(obs)"
        />
      </v-layer>
    </v-stage>

    <div class="editor-actions mt-3">
      <button class="btn btn-primary me-2" @click="saveChanges">Save</button>
      <button class="btn btn-danger" @click="openCancelModal">Cancel</button>
    </div>

    <div
      class="modal fade"
      id="cancelModal"
      tabindex="-1"
      aria-labelledby="cancelModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="cancelModalLabel">Confirm Cancel</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            Are you sure you want to discard your changes?
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              No
            </button>
            <button type="button" class="btn btn-danger" @click="discardChanges">
              Yes
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import * as bootstrap from "bootstrap";

export default {
  name: "LevelEditor",
  data() {
    return {
      levelId: null,
      form: {
        title: "",
        description: "",
        tangerine_count: 0,
        level_hint: "",
      },
      backgroundSrc: "/src/assets/level_assets/editor_grid.png",
      backgroundImage: null,

      obstacleItems: [
        {
          label: "Rock",
          image_path: "/src/assets/level_assets/rock.png",
          type: "rock",
        },
        {
          label: "Tangerine",
          image_path: "/src/assets/level_assets/tangerine.png",
          type: "tangerine",
        },
        {
          label: "Finish",
          image_path: "/src/assets/level_assets/finish.png",
          type: "finish",
        },
      ],
      obstacles: [],
      originalData: null,
      stageWidth: 500,
      stageHeight: 500,
      errorMessage: "",
      successMessage: "",
      isDeletionMode: false,
    };
  },
  methods: {
    async fetchLevelData() {
      try {
        const response = await fetch(
          `/codebara-backend/level-api/GetLevelDetailsAPI.php?level_id=${this.levelId}`
        );
        const data = await response.json();
        if (data.error) {
          this.errorMessage = data.error;
          return;
        }
        this.form.title = data.level.title;
        this.form.description = data.level.description;
        if (data.level.tangerine_count !== undefined) {
          this.form.tangerine_count = data.level.tangerine_count;
        }
        if (data.level.level_hint !== undefined) {
          this.form.level_hint = data.level.level_hint;
        }

        if (data.obstacles && Array.isArray(data.obstacles)) {
          const loadedObstacles = [];
          for (const obs of data.obstacles) {
            const imageObj = await this.loadImage(obs.image_path);
            loadedObstacles.push({
              x: obs.position_x,
              y: obs.position_y,
              type: obs.type,
              imageObj,
            });
          }
          this.obstacles = loadedObstacles;
        }
        this.originalData = JSON.parse(JSON.stringify(data));
      } catch (error) {
        console.error("Error fetching level data:", error);
        this.errorMessage = "Failed to load level data.";
      }
    },
    loadImage(src) {
      return new Promise((resolve, reject) => {
        const img = new window.Image();
        img.src = src;
        img.onload = () => resolve(img);
        img.onerror = reject;
      });
    },
    addObstacle(item) {
      this.loadImage(item.image_path)
        .then((imageObj) => {
          this.obstacles.push({
            x: 0,
            y: 0,
            type: item.type,
            imageObj,
          });
        })
        .catch((err) => {
          console.error("Failed to load obstacle image:", err);
          this.errorMessage = "Failed to load obstacle image.";
        });
    },
    onObstacleDragEnd(evt, obstacle) {
      const shape = evt.target;
      obstacle.x = shape.x();
      obstacle.y = shape.y();
    },
    onObstacleClick(obs) {
      if (this.isDeletionMode) {
        const index = this.obstacles.indexOf(obs);
        if (index !== -1) {
          this.obstacles.splice(index, 1);
        }
      }
    },
    toggleDeletionMode() {
      this.isDeletionMode = !this.isDeletionMode;
    },
    async saveChanges() {
      const obstaclesData = this.obstacles.map((obs) => ({
        image_path: obs.imageObj?.src || "",
        type: obs.type || "unknown",
        position_x: Math.round(obs.x),
        position_y: Math.round(obs.y),
      }));

      try {
        const payload = {
          level_id: this.levelId,
          title: this.form.title,
          description: this.form.description,
          tangerine_count: this.form.tangerine_count,
          level_hint: this.form.level_hint,
          obstacles: obstaclesData,
        };
        const response = await fetch("/codebara-backend/level-api/SaveLevelDetailsAPI.php", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload),
        });
        const result = await response.json();
        if (result.error) {
          this.errorMessage = result.error;
          return;
        }
        this.successMessage = "Changes saved successfully!";
      } catch (error) {
        console.error("Error saving level changes:", error);
        this.errorMessage = "Failed to save changes.";
      }
    },
    openCancelModal() {
      const modalEl = document.getElementById("cancelModal");
      const modal = new bootstrap.Modal(modalEl);
      modal.show();
    },
    discardChanges() {
      this.form.title = this.originalData?.level?.title || "";
      this.form.description = this.originalData?.level?.description || "";
      this.form.tangerine_count = this.originalData?.level?.tangerine_count || 0;
      this.form.level_hint = this.originalData?.level?.level_hint || "";

      this.obstacles = [];
      if (this.originalData?.obstacles) {
        this.originalData.obstacles.forEach((obs) => {
          this.loadImage(obs.image_path)
            .then((imageObj) => {
              this.obstacles.push({
                x: obs.position_x,
                y: obs.position_y,
                type: obs.type,
                imageObj,
              });
            })
            .catch((err) => {
              console.error("Failed to load obstacle image:", err);
            });
        });
      }
      const modalEl = document.getElementById("cancelModal");
      const modal = bootstrap.Modal.getInstance(modalEl);
      if (modal) modal.hide();
    },
    async loadBackground() {
      try {
        this.backgroundImage = await this.loadImage(this.backgroundSrc);
      } catch (error) {
        console.error("Failed to load background:", error);
      }
    },
  },
  async mounted() {
    await this.loadBackground();

    this.levelId = this.$route.params.level_id;
    await this.fetchLevelData();
  },
};
</script>

<style scoped>
.level-editor-container {
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
}

.konva-stage {
  width: 500px;
  height: 500px;
  border: 1px solid #aaa;
  margin-top: 20px;
  background-color: #f4f4f4;
}

.obstacle-toolbar {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

.toolbar-icon {
  width: 24px;
  height: 24px;
  margin-right: 4px;
  object-fit: contain;
}
</style>
