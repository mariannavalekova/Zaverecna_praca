<template>
    <div class="level-editor-container">
      <h2>Edit Level</h2>
  
      <!-- Display errors or success messages -->
      <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>
      <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>
  
      <!-- Title & Description -->
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
  
      <!-- Obstacle Toolbar -->
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
  
      <!-- Konva Stage & Layer (auto-registered by vue-konva plugin) -->
      <v-stage
        class="konva-stage"
        :config="{ width: stageWidth, height: stageHeight }"
      >
        <v-layer>
          <!-- BACKGROUND IMAGE -->
          <v-image
            v-if="backgroundImage"
            :config="{
              x: 0,
              y: 0,
              image: backgroundImage,
              width: stageWidth,
              height: stageHeight,
              listening: false // so it doesn't block obstacle interaction
            }"
          />
          <!-- Render each obstacle as a <v-image> -->
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
          />
        </v-layer>
      </v-stage>
  
      <!-- Save/Cancel Buttons -->
      <div class="editor-actions mt-3">
        <button class="btn btn-primary me-2" @click="saveChanges">Save</button>
        <button class="btn btn-danger" @click="openCancelModal">Cancel</button>
      </div>
  
      <!-- Cancel Modal -->
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
        levelId: null, // from route param
        form: {
          title: "",
          description: "",
        },
        // The background image path. Adjust as needed.
        backgroundSrc: "/src/assets/rb_1308.png",
        backgroundImage: null, // will store an <img> object for the background
  
        obstacleItems: [
          {
            label: "Rock",
            image_path: "/src/assets/rock.jpg",
            type: "rock",
          },
          {
            label: "Tree",
            image_path: "/src/assets/tangerine.png",
            type: "tree",
          },
          {
            label: "Finish",
            image_path: "/src/assets/finish.png",
            type: "finish",
          },
        ],
        obstacles: [], // each { x, y, type, imageObj }
        originalData: null,
        stageWidth: 700,
        stageHeight: 700,
        errorMessage: "",
        successMessage: "",
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
          // Populate form fields
          this.form.title = data.level.title;
          this.form.description = data.level.description;
  
          // Convert DB obstacles to local obstacles
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
            obstacles: obstaclesData,
          };
          const response = await fetch("/codebara-backend/level-api/SaveLevelDetailsAPI.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload),
          });
          const data = await response.json();
          if (data.error) {
            this.errorMessage = data.error;
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
        // Revert form fields
        this.form.title = this.originalData?.level?.title || "";
        this.form.description = this.originalData?.level?.description || "";
  
        // Clear obstacles
        this.obstacles = [];
        if (this.originalData?.obstacles) {
          // Re-add from original data
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
  
        // Hide modal
        const modalEl = document.getElementById("cancelModal");
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();
      },
      async loadBackground() {
        // Load the background image once
        try {
          this.backgroundImage = await this.loadImage(this.backgroundSrc);
        } catch (error) {
          console.error("Failed to load background:", error);
          // Not critical, but we can show an error if needed
        }
      },
    },
    async mounted() {
      // 1. Load the background image
      await this.loadBackground();
  
      // 2. Get level_id from route params
      this.levelId = this.$route.params.level_id;
  
      // 3. Load data from server
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
    width: 700px;
    height: 700px;
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
  