<template>
  <div class="levels-dashboard-container">
    <h2 class="page-title">Levels Dashboard</h2>

    <div v-if="errorMessage" class="alert alert-danger">
      {{ errorMessage }}
    </div>

    <div v-if="chapters.length === 0 && !errorMessage" class="no-chapters">
      <p>No chapters found.</p>
    </div>

    <div v-else>
      <div
        v-for="chapter in chapters"
        :key="chapter.chapter_id"
        class="level-card"
      >
        <div class="level-card-header" @click="toggleChapter(chapter)">
          <h5>{{ chapter.title }}</h5>
          <small>
            Levels completed: {{ chapter.completed_levels }} / {{ chapter.total_levels }}
          </small>
        </div>

        <transition name="slide-fade">
          <div v-if="chapter.expanded" class="level-card-body">
            <div class="levels-container">
              <ul>
                <li
                  v-for="level in chapter.levels"
                  :key="level.level_id"
                  @click.stop="goToLevel(level.level_id)"
                >
                  {{ level.title }}
                </li>
              </ul>
            </div>
          </div>
        </transition>
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
/* Main container styling to match the peachy look */
.levels-dashboard-container {
  max-width: 600px;
  margin: 20px auto;
  background-color: #fbe2cd; /* Light peach background */
  padding: 20px;
  border-radius: 8px;
  border: 1px solid #f3c9a6;
  font-family: Arial, sans-serif;
}

.page-title {
  margin-bottom: 20px;
  text-align: center;
  font-weight: bold;
  color: #5a3f2a;
}

.no-chapters {
  text-align: center;
  color: #5a3f2a;
}

/* Level card styling (similar to class cards) */
.level-card {
  background-color: #f5d0ae;
  border: 1px solid #e8b995;
  border-radius: 6px;
  margin-bottom: 15px;
}

/* Header of each level card */
.level-card-header {
  cursor: pointer;
  padding: 10px;
  border-bottom: 1px solid #e8b995;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.level-card-header h5 {
  margin: 0;
  color: #5a3f2a;
}
.level-card-header small {
  color: #5a3f2a;
  opacity: 0.8;
}

/* Expanded card body */
.level-card-body {
  padding: 10px;
  background-color: #f6e3d3;
  border-radius: 0 0 6px 6px;
}

/* Container for levels list */
.levels-container {
  max-height: 150px;
  overflow-y: auto;
  background-color: #fff;
  border-radius: 4px;
  border: 1px solid #e8b995;
  padding: 10px;
}

.levels-container ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
}

.levels-container li {
  cursor: pointer;
  padding: 5px;
  border-bottom: 1px solid #e8b995;
}

.levels-container li:hover {
  background-color: #f0f0f0;
}

/* Simple transition for expanding/collapsing chapters */
.slide-fade-enter-active,
.slide-fade-leave-active {
  transition: all 0.3s ease;
}
.slide-fade-enter,
.slide-fade-leave-to {
  opacity: 0;
  transform: translateY(-5px);
}
</style>
