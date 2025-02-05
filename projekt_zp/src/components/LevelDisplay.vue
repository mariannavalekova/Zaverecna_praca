<template>
    <div class="container mt-4">
      <h2>Chapters and Their Levels</h2>
      <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>
      <div v-if="chapters.length === 0 && !errorMessage" class="alert alert-info">
        No chapters found.
      </div>
      <div v-for="chapter in chapters" :key="chapter.chapter_id" class="mb-4">
        <h3>Chapter {{ chapter.chapter_id }}: {{ chapter.title }}</h3>
        <div v-if="!chapter.levels || chapter.levels.length === 0">
          <p>No levels found for this chapter.</p>
        </div>
        <table v-if="chapter.levels && chapter.levels.length > 0" class="table">
          <thead>
            <tr>
              <th>Level ID</th>
              <th>Title</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="level in chapter.levels" :key="level.level_id">
              <td>{{ level.level_id }}</td>
              <td>{{ level.title }}</td>
              <td>
                <button class="btn btn-sm btn-primary me-2" @click="editLevel(level)">
                  Edit
                </button>
                <button class="btn btn-sm btn-danger" @click="deleteLevel(chapter.chapter_id, level.level_id)">
                  Delete
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        <!-- Add Level Button for this chapter -->
        <button class="btn btn-success mt-2" @click="openAddModal(chapter)">
          Add Level
        </button>
      </div>
  
      <!-- Add Level Modal -->
      <div class="modal fade" id="addLevelModal" tabindex="-1" aria-labelledby="addLevelModalLabel" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="addLevelModalLabel">Add Level</h5>
              <button type="button" class="btn-close" @click="closeAddModal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              <div class="mb-3">
                <label for="newLevelTitle" class="form-label">Level Title</label>
                <input
                  type="text"
                  id="newLevelTitle"
                  class="form-control"
                  v-model="newLevelTitle"
                  required
                />
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" @click="closeAddModal">
                Cancel
              </button>
              <button type="button" class="btn btn-primary" @click="createLevel">
                Create Level
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
    data() {
      return {
        chapters: [],        // Array of chapter objects; each may include a 'levels' array
        errorMessage: "",
        newLevelTitle: "",
        selectedChapterId: null, // For adding a new level, store the chapter ID
      };
    },
    methods: {
      // Load all chapters from the database
      async loadChapters() {
        try {
          const response = await fetch("/codebara-backend/chapter-api/GetChaptersAPI.php");
          const data = await response.json();
          if (data.error) {
            this.errorMessage = data.error;
          } else {
            this.chapters = data.chapters;
            // For each chapter, load its levels
            for (let chapter of this.chapters) {
              await this.loadLevelsForChapter(chapter);
            }
          }
        } catch (error) {
          console.error("Error loading chapters:", error);
          this.errorMessage = "An error occurred while loading chapters.";
        }
      },
      // Load levels for a given chapter using its chapter_id
      async loadLevelsForChapter(chapter) {
        try {
          const response = await fetch(`/codebara-backend/level-api/GetLevelsAPI.php?chapter_id=${chapter.chapter_id}`);
          const data = await response.json();
          if (data.error) {
            this.errorMessage = data.error;
          } else {
            // Directly assign levels; Vue 3's reactivity will track this change.
            chapter.levels = data.levels;
          }
        } catch (error) {
          console.error(`Error loading levels for chapter ${chapter.chapter_id}:`, error);
          this.errorMessage = `An error occurred while loading levels for chapter ${chapter.chapter_id}.`;
        }
      },
      openAddModal(chapter) {
        this.selectedChapterId = chapter.chapter_id;
        const modalEl = document.getElementById("addLevelModal");
        const modal = new bootstrap.Modal(modalEl);
        modal.show();
      },
      closeAddModal() {
        const modalEl = document.getElementById("addLevelModal");
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();
        this.newLevelTitle = "";
        this.selectedChapterId = null;
      },
      async createLevel() {
        if (!this.newLevelTitle || !this.selectedChapterId) return;
        try {
          const response = await fetch("/codebara-backend/level-api/CreateLevelAPI.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              chapter_id: this.selectedChapterId,
              title: this.newLevelTitle,
            }),
          });
          const data = await response.json();
          if (data.error) {
            this.errorMessage = data.error;
          } else {
            // Reload levels for the affected chapter
            const chapter = this.chapters.find(ch => ch.chapter_id === this.selectedChapterId);
            if (chapter) {
              await this.loadLevelsForChapter(chapter);
            }
            this.closeAddModal();
          }
        } catch (error) {
          console.error("Error creating level:", error);
          this.errorMessage = "An error occurred while creating the level.";
        }
      },
      editLevel(level) {
        // Redirect to LevelEditorView.vue with the level_id as parameter.
        // Ensure you have a route named "level-editor" that accepts a level_id param.
        this.$router.push({ name: "level-editor", params: { level_id: level.level_id } });
      },
      async deleteLevel(chapterId, levelId) {
        if (!confirm("Are you sure you want to delete this level?")) return;
        try {
          const response = await fetch("/codebara-backend/level-api/DeleteLevelAPI.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ level_id: levelId }),
          });
          const data = await response.json();
          if (data.error) {
            this.errorMessage = data.error;
          } else {
            // Reload levels for the chapter
            const chapter = this.chapters.find(ch => ch.chapter_id === chapterId);
            if (chapter) {
              await this.loadLevelsForChapter(chapter);
            }
          }
        } catch (error) {
          console.error("Error deleting level:", error);
          this.errorMessage = "An error occurred while deleting the level.";
        }
      },
    },
    mounted() {
      this.loadChapters();
    },
  };
  </script>
  
  <style scoped>
  .container {
    max-width: 900px;
  }
  .table {
    margin-top: 20px;
  }
  </style>
  