<template>
  <div class="student-class-dashboard-container">
    <h2 class="page-title">Student Class Dashboard</h2>

    <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>
    <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>

    <div class="join-class-section">
      <label for="classCode" class="join-class-label">Enter Class Code:</label>
      <input
        type="text"
        id="classCode"
        v-model="classCode"
        placeholder="Enter 10-character class code"
        class="join-class-input"
      />
      <button class="join-class-btn" @click="joinClass">Join Class</button>
    </div>

    <div v-if="classes.length">
      <h3 class="joined-title">Your Joined Classes</h3>
      <div v-for="cls in classes" :key="cls.class_id" class="class-card">
        <div class="class-header">
          <h5 class="class-code">Class Code: {{ cls.class_code }}</h5>
          
          <button 
            @click="cls.showStudents = !cls.showStudents" 
            class="students-btn"
          >
            Students
          </button>
        </div>
        <p class="teacher-info">
          Teacher: {{ cls.teacher_name }} {{ cls.teacher_surname }}
          </p>
        <transition name="slide-fade">
          <div v-if="cls.showStudents" class="students-section">
            <h6>Students:</h6>
            <ul class="students-list">
              <li v-for="student in cls.students" :key="student.user_id">
                {{ student.username }}
              </li>
            </ul>
            <div v-if="cls.students.length === 0">
              <em>No students have joined this class yet.</em>
            </div>
          </div>
        </transition>
      </div>
    </div>
    <div v-else>
      <p>You haven't joined any classes yet.</p>
    </div>
  </div>
</template>

<script>
import { useLoginStore } from '@/stores/loginStore';

export default {
  data() {
    return {
      classCode: '',
      classes: [],
      errorMessage: '',
      successMessage: '',
    };
  },
  methods: {
    async joinClass() {
      this.errorMessage = '';
      this.successMessage = '';

      const loginStore = useLoginStore();
      if (!loginStore.user_id) {
        this.errorMessage = 'You must be logged in.';
        return;
      }

      if (!this.classCode || this.classCode.length !== 10) {
        this.errorMessage = 'Class code must be exactly 10 characters long.';
        return;
      }

      try {
        const response = await fetch('./codebara-backend/class-api/JoinClassAPI.php', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            student_id: loginStore.user_id,
            class_code: this.classCode,
          }),
        });
        const data = await response.json();
        if (data.error) {
          this.errorMessage = data.error;
        } else {
          this.successMessage = 'Successfully joined the class.';
          this.classCode = '';
          this.loadJoinedClasses();
        }
      } catch (error) {
        console.error(error);
        this.errorMessage = 'An error occurred while joining the class.';
      }
    },
    async loadJoinedClasses() {
      this.errorMessage = '';
      const loginStore = useLoginStore();
      if (!loginStore.user_id) {
        this.errorMessage = 'You must be logged in.';
        return;
      }
      try {
        const response = await fetch(
          `./codebara-backend/class-api/GetStudentClassesAPI.php?student_id=${loginStore.user_id}`
        );
        const data = await response.json();
        if (data.error) {
          this.errorMessage = data.error;
        } else {
          this.classes = data.classes.map(cls => ({ 
            ...cls, 
            showStudents: false 
          }));
        }
      } catch (error) {
        console.error(error);
        this.errorMessage = 'An error occurred while loading your classes.';
      }
    },
  },
  mounted() {
    this.loadJoinedClasses();
  },
};
</script>

<style scoped>

.student-class-dashboard-container {
  max-width: 600px;
  margin: 20px auto;
  background-color: #fbe2cd; 
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

.alert {
  margin-bottom: 15px;
}

.join-class-section {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 20px;
  color: #5a3f2a;
}
.join-class-label {
  white-space: nowrap;
}

.join-class-input {
  flex: 1;
  padding: 8px;
  border: 1px solid #f3c9a6;
  border-radius: 4px;
  background-color: #fff;
}

.join-class-btn {
  background-color: #d17c33; 
  color: #fff;
  padding: 10px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
  white-space: nowrap;
}
.join-class-btn:hover {
  background-color: #b97c51;
}

.joined-title {
  margin-top: 30px;
  margin-bottom: 15px;
  color: #5a3f2a;
}

.class-card {
  background-color: #f5d0ae;
  border: 1px solid #e8b995;
  border-radius: 6px;
  padding: 15px;
  margin-bottom: 15px;
}

.class-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.class-code {
  font-weight: bold;
  color: #5a3f2a;
  margin: 0;
}

.teacher-info {
  font-style: italic;
  margin: 0 0 10px 0;
  color: #5a3f2a;
}

.students-btn {
  background-color: #d17c33; 
  color: #fff;
  border: none;
  border-radius: 4px;
  font-weight: bold;
  padding: 6px 12px;
  cursor: pointer;
}
.students-btn:hover {
  background-color: #b97c51;
}

.students-section {
  margin-top: 15px;
  background-color: #f6e3d3;
  padding: 10px;
  border-radius: 4px;
  color: #5a3f2a;
}

.students-list {
  list-style: disc;
  padding-left: 20px;
  margin: 5px 0 10px 0;
}
.students-list li {
  margin-bottom: 4px;
}

.slide-fade-enter-active, .slide-fade-leave-active {
  transition: all .3s ease;
}
.slide-fade-enter, .slide-fade-leave-to {
  opacity: 0;
  transform: translateY(-5px);
}

.students-list a {
  color: #5a3f2a;
  text-decoration: none;
}
.students-list a:hover {
  text-decoration: underline;
  color: #b97c51;
}
</style>
