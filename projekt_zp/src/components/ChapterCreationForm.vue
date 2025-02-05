<template>
    <div class="chapter-creation-form">
      <h2>Create New Chapter</h2>
      <form @submit.prevent="createChapter">
        <div class="mb-3">
          <label for="chapterTitle" class="form-label">Chapter Title</label>
          <input
            type="text"
            id="chapterTitle"
            v-model="chapterTitle"
            class="form-control"
            placeholder="Enter chapter title"
            required
          />
        </div>
        <div v-if="errorMessage" class="alert alert-danger mt-2">
          {{ errorMessage }}
        </div>
        <div v-if="successMessage" class="alert alert-success mt-2">
          {{ successMessage }}
        </div>
        <button type="submit" class="btn btn-primary mt-3">Create Chapter</button>
      </form>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        chapterTitle: "",
        errorMessage: "",
        successMessage: ""
      };
    },
    methods: {
      async createChapter() {
        this.errorMessage = "";
        this.successMessage = "";
  
        try {
          const response = await fetch("/codebara-backend/chapter-api/CreateChapterAPI.php", {
            method: "POST",
            headers: {
              "Content-Type": "application/json"
            },
            body: JSON.stringify({ title: this.chapterTitle })
          });
  
          const data = await response.json();
          if (!response.ok) {
            this.errorMessage = data.error || "An error occurred while creating the chapter.";
          } else {
            this.successMessage = "Chapter created successfully!";
            this.chapterTitle = "";
          }
        } catch (error) {
          console.error("Error creating chapter:", error);
          this.errorMessage = "An error occurred: " + error.message;
        }
      }
    }
  };
  </script>
  
  <style scoped>
  .chapter-creation-form {
    max-width: 500px;
    margin: 0 auto;
    padding: 20px;
  }
  </style>
  