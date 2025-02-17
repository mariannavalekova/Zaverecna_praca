<template>
  <div class="container mt-4">
    <h2>Levels Dashboard</h2>

    <div v-if="errorMessage" class="alert alert-danger">
      {{ errorMessage }}
    </div>

    <div v-if="chapters.length === 0 && !errorMessage">
      <p>No chapters found.</p>
    </div>

    <div v-else>
      <div v-for="chapter in chapters" :key="chapter.chapter_id" class="card mb-3">
        <div class="card-header clickable" @click="toggleChapter(chapter)">
          <h5 class="card-title mb-0">{{ chapter.title }}</h5>
          <small>
            Levels completed: {{ chapter.completed_levels }} / {{ chapter.total_levels }}
          </small>
        </div>

        <div v-if="chapter.expanded" class="card-body">
          <div class="levels-container">
            <ul class="list-group">
              <li
                v-for="level in chapter.levels"
                :key="level.level_id"
                class="list-group-item list-group-item-action"
                @click.stop="goToLevel(level.level_id)"
              >
                {{ level.title }}
              </li>
            </ul>
          </div>
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
          this.chapters = data.chapters.map(chapter => ({
            ...chapter,
            expanded: false,
          }));
        }
      } catch (error) {
        console.error(error);
        this.errorMessage = "An error occurred while loading chapters.";
      }
    },
    goToLevel(levelId) {
      this.$router.push({ name: "game", params: { level_id: levelId } });
    },
    toggleChapter(chapter) {
      chapter.expanded = !chapter.expanded;
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

.card-header.clickable {
  cursor: pointer;
}

.list-group-item-action {
  cursor: pointer;
}

.list-group-item-action:hover {
  background-color: #f0f0f0;
}

.levels-container {
  max-height: 150px; 
  overflow-y: auto;
}
</style>
