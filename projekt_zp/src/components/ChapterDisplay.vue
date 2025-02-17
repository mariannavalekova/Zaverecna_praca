<template>
    <div class="container mt-4">
      <h2>Chapters</h2>
      <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>
      <div v-if="chapters.length === 0 && !errorMessage" class="alert alert-info">
        No chapters found.
      </div>
      <div v-else>
        <table class="table">
          <thead>
            <tr>
              <th>Chapter ID</th>
              <th>Title</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="chapter in chapters" :key="chapter.chapter_id">
              <td>{{ chapter.chapter_id }}</td>
              <td>{{ chapter.title }}</td>
              <td>
                <button class="btn btn-sm btn-primary me-2" @click="openEditModal(chapter)">Edit</button>
                <button class="btn btn-sm btn-danger" @click="deleteChapter(chapter.chapter_id)">Delete</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
  
      <!-- Edit Chapter Modal -->
      <div class="modal fade" id="editChapterModal" tabindex="-1" aria-labelledby="editChapterModalLabel" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="editChapterModalLabel">Edit Chapter</h5>
              <button type="button" class="btn-close" @click="closeEditModal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              <div class="mb-3">
                <label for="editChapterTitle" class="form-label">Chapter Title</label>
                <input type="text" class="form-control" id="editChapterTitle" v-model="editingTitle" required>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" @click="closeEditModal">Cancel</button>
              <button type="button" class="btn btn-primary" @click="updateChapter">Save Changes</button>
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
        chapters: [],
        errorMessage: "",
        editingChapter: null,
        editingTitle: "",
      };
    },
    methods: {
      async loadChapters() {
        try {
          const response = await fetch("/codebara-backend/chapter-api/GetChaptersAPI.php");
          const data = await response.json();
          if (data.error) {
            this.errorMessage = data.error;
          } else {
            this.chapters = data.chapters;
          }
        } catch (error) {
          console.error("Error loading chapters:", error);
          this.errorMessage = "An error occurred while loading chapters.";
        }
      },
      openEditModal(chapter) {
        this.editingChapter = chapter;
        this.editingTitle = chapter.title;
        const modalEl = document.getElementById("editChapterModal");
        const modal = new bootstrap.Modal(modalEl);
        modal.show();
      },
      closeEditModal() {
        const modalEl = document.getElementById("editChapterModal");
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();
        this.editingChapter = null;
        this.editingTitle = "";
      },
      async updateChapter() {
        if (!this.editingChapter) return;
        try {
          const response = await fetch("/codebara-backend/chapter-api/UpdateChapterAPI.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              chapter_id: this.editingChapter.chapter_id,
              title: this.editingTitle,
            }),
          });
          const data = await response.json();
          if (data.error) {
            this.errorMessage = data.error;
          } else {
            this.loadChapters();
            this.closeEditModal();
          }
        } catch (error) {
          console.error("Error updating chapter:", error);
          this.errorMessage = "An error occurred while updating the chapter.";
        }
      },
      async deleteChapter(chapter_id) {
        if (!confirm("Are you sure you want to delete this chapter?")) return;
        try {
          const response = await fetch("/codebara-backend/chapter-api/DeleteChapterAPI.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ chapter_id }),
          });
          const data = await response.json();
          if (data.error) {
            this.errorMessage = data.error;
          } else {
            this.loadChapters();
          }
        } catch (error) {
          console.error("Error deleting chapter:", error);
          this.errorMessage = "An error occurred while deleting the chapter.";
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
  