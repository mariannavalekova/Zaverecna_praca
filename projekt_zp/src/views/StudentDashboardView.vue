<template>
    <div class="dashboard-container">
      <div class="dashboard-section">
        <StudentClassDashboard />
      </div>
      <div class="dashboard-section">
        <StudentLevelsDashboard />
      </div>
    </div>
  </template>
  
  <script>
  import StudentClassDashboard from '../components/StudentClassDashboard.vue';
  import StudentLevelsDashboard from '../components/StudentLevelsDashboard.vue';
  
  export default {
    components: {
      StudentClassDashboard,
      StudentLevelsDashboard,
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
    background-color: #f9f9f9;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  @media (max-width: 768px) {
    .dashboard-container {
      flex-direction: column;
    }
  }
  </style>
  