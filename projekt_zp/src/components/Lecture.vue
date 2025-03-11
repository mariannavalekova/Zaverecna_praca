<template>
  <div class="learn">
    <div class="sidebar">
      <div class="chapters">
        <div
          v-for="chapter in chapters"
          :key="chapter.chapter_id"
          class="chapter-item"
          @click="fetchArticle(chapter.chapter_id)"
        >
          <h1>{{ chapter.title }}</h1>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="lecture-content" v-if="articleContent">
        <div v-html="articleContent"></div>
      </div>
      <div class="lecture-content" v-else>
        <p>Select a chapter to see its article.</p>
      </div>
    </div>
  </div>
</template>

<script>
import hljs from 'highlight.js'; 

export default {
  name: "LearnSingleComponent",
  data() {
    return {
      chapters: [],
      articleContent: "", 
    };
  },
  mounted() {
    this.fetchChapters();
  },
  methods: {
    fetchChapters() {
      fetch("/codebara-backend/chapter-api/GetChaptersAPI.php")
        .then((response) => {
          if (!response.ok) {
            throw new Error(`Error: ${response.status}`);
          }
          return response.json();
        })
        .then((data) => {
          this.chapters = data.chapters || [];
        })
        .catch((error) => {
          console.error("Error fetching chapters:", error);
        });
    },

    fetchArticle(chapterId) {
      fetch(`/codebara-backend/article-api/GetArticleAPI.php?chapter_id=${chapterId}`)
        .then((response) => {
          if (!response.ok) {
            throw new Error(`Error: ${response.status}`);
          }
          return response.json();
        })
        .then((data) => {
          if (data.article && data.article.content) {
            this.articleContent = data.article.content;
            this.$nextTick(() => {
              hljs.highlightAll();
            });
          } else {
            this.articleContent = "<p>No article found for this chapter.</p>";
          }
        })
        .catch((error) => {
          console.error("Error fetching article:", error);
          this.articleContent = "<p>Failed to load article.</p>";
        });
    },
  },
};
</script>

<style scoped>
.learn {
  display: flex;
  background-color: #f5f4eb;
  min-height: 100vh;
}

.sidebar {
  width: 20%;
  display: flex;
  flex-direction: column;
  padding: 10px;
  box-sizing: border-box;
  background: #f3d3a47e;
}

.content {
  flex: 1;
  padding: 10px;
  box-sizing: border-box;
}

.chapters {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 10px;
}

.chapter-item {
  background: #e9b160;
  padding: 15px;
  border-radius: 5px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, box-shadow 0.2s;
  cursor: pointer;
}

.chapter-item:hover {
  transform: scale(1.02);
  box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
}

.chapter-item:hover h1 {
  color: #d17c33;
}

.chapter-item h1 {
  font-size: 18px;
  font-family: Arial, sans-serif;
  font-weight: bold;
  color: #333;
  margin: 0;
}

.lecture-content {
  width: 100%;
  height: 100%;
  padding: 40px;
  font-family: Arial, sans-serif;
  color: #000;
}

.lecture-content h1 {
  font-size: 32px;
  font-weight: bold;
  margin-bottom: 20px;
}

.lecture-content h2 {
  font-size: 24px;
  font-weight: bold;
  margin-top: 30px;
  margin-bottom: 10px;
}

.lecture-content p {
  font-size: 18px;
  line-height: 1.6;
  margin-bottom: 10px;
}

.lecture-content pre {
  background: #f3d3a47e;
  padding: 15px;
  border-radius: 5px;
  font-size: 18px;
  line-height: 1.6;
  font-family: "Courier New", monospace;
  overflow: auto;
}

.practice-button {
  margin-top: 20px;
  padding: 10px 20px;
  background-color: #d17c33;
  color: white;
  font-size: 16px;
  font-weight: bold;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.2s;
}

.practice-button:hover {
  background-color: #b7692b;
  transform: scale(1.05);
}

.practice-button:active {
  transform: scale(1);
}

.section {
  margin-bottom: 30px;
}
.hljs-language-select,
.hljs-badge {
  display: none !important;
}
</style>
