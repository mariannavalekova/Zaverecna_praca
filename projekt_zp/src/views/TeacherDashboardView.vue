<template>
  <div class="dashboard-container">
    <div class="dashboard-section">
      <ClassDashboard />
    </div>
    <div class="dashboard-section">
      <LevelsDashboard />
    </div>
  </div>
</template>

<script>
import ClassDashboard from '../components/ClassDashboard.vue';
import LevelsDashboard from '../components/StudentLevelsDashboard.vue';

export default {
  components: {
    ClassDashboard,
    LevelsDashboard,
  },
};
</script>

<style scoped>
.dashboard-container {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  padding: 20px;
}

.dashboard-section {
  flex: 1;
  min-width: 300px;
  padding: 20px;

}

@media (max-width: 768px) {
  .dashboard-container {
    flex-direction: column;
  }
}
</style>