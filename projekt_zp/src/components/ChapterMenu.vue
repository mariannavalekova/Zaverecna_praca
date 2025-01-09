<template>
  <div class="chapters">
    <div v-for="chapter in chapters" :key="chapter.title" class="chapter-item">
      <h1>{{ chapter.title }}</h1>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      chapters: [
        { title: "Introduction" },
        { title: "Variables" },
        { title: "Loops" },
        { title: "Conditions (if else)" },
      ],
    };
  },
};
</script>

<style scoped>
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
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Adds shadow for a clean look */
  transition: transform 0.2s, box-shadow 0.2s;
}

.chapter-item:hover {
  transform: scale(1.02); /* Slight zoom on hover */
  box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15); /* Darker shadow on hover */
}

h1 {
  font-size: 18px;
  font-family: Arial, sans-serif;
  font-weight: bold;
  color: #333;
  margin: 0;
}

.chapter-item:hover h1 {
  color: #d17c33; /* Matches the orange theme of your navbar */
}
</style>
