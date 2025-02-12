<template>
  <div class="container mt-4">
    <h2>Levels Dashboard</h2>
    
    <!-- Display an error message if something goes wrong -->
    <div v-if="errorMessage" class="alert alert-danger">
      {{ errorMessage }}
    </div>
    
    <!-- If no chapters are available -->
    <div v-if="chapters.length === 0 && !errorMessage">
      <p>No chapters found.</p>
    </div>
    
    <!-- List the chapters -->
    <div v-else>
      <div
        v-for="chapter in chapters"
        :key="chapter.chapter_id"
        class="card mb-3"
      >
        <div class="card-body">
          <h5 class="card-title">
            {{ chapter.title }}
          </h5>
          <p class="card-text">
            Levels completed: {{ chapter.completed_levels }} / {{ chapter.total_levels }}
          </p>

          <!-- Show the list of levels in this chapter -->
          <ul class="list-group">
            <li
              v-for="level in chapter.levels"
              :key="level.level_id"
              class="list-group-item list-group-item-action"
              @click="goToLevel(level.level_id)"
            >
              {{ level.title }}
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { useLoginStore } from "@/stores/loginStore";

export default {
  data() {
    return {
      chapters: [],
      errorMessage: "",
    };
  },
  methods: {
    async loadChapters() {
      const loginStore = useLoginStore();
      if (!loginStore.user_id) {
        this.errorMessage = "You must be logged in.";
        return;
      }
      try {
        const response = await fetch(
          `./codebara-backend/level-api/GetStudentLevelsDashboardAPI.php?user_id=${loginStore.user_id}`
        );
        const data = await response.json();
        if (data.error) {
          this.errorMessage = data.error;
        } else {
          // We expect data.chapters to include "levels" for each chapter
          this.chapters = data.chapters;
        }
      } catch (error) {
        console.error(error);
        this.errorMessage = "An error occurred while loading chapters.";
      }
    },
    goToLevel(levelId) {
      // Navigate to the game view, passing level_id as a param
      // Adjust the route name and param as needed
      this.$router.push({ name: "game", params: { level_id: levelId } });
    },
  },
  mounted() {
    this.loadChapters();
  },
};
</script>

<style scoped>
.container {
  max-width: 800px;
}

.card {
  border: 1px solid #ccc;
  margin-bottom: 20px;
}

/* Make levels clickable */
.list-group-item-action {
  cursor: pointer;
}
.list-group-item-action:hover {
  background-color: #f0f0f0;
}
</style>
