<template>
  <div class="class-dashboard-container">
    <h2 class="page-title">My Classes</h2>

    <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>

    <button @click="createClass" class="create-class-btn">Create new class</button>

    <div v-if="classes.length === 0" class="no-classes">
      <p>No classes found. Create one to get started.</p>
    </div>

    <div v-else>
      <div
        v-for="cls in classes"
        :key="cls.class_id"
        class="class-card"
      >
        <div class="class-header">
          <span class="class-code">Class code: {{ cls.class_code }}</span>
          <button 
            @click="cls.showStudents = !cls.showStudents" 
            class="students-btn"
          >
            Students
          </button>
        </div>

        <transition name="slide-fade">
          <div v-if="cls.showStudents" class="students-section">
            <h4>Students:</h4>
            <ul>
              <li
                v-for="student in cls.students"
                :key="student.user_id"
              >
                <a href="#" @click.prevent="openStudentProgress(student)">
                  {{ student.username }}
                </a>
              </li>
            </ul>
            <div v-if="cls.students.length === 0">
              <em>No students joined yet.</em>
            </div>
          </div>
        </transition>
      </div>
    </div>

    <!-- Modal for student progress (unchanged) -->
    <div
      class="modal fade"
      id="studentProgressModal"
      tabindex="-1"
      aria-labelledby="studentProgressModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="studentProgressModalLabel">
              {{ selectedStudent ? selectedStudent.username : '' }}'s Progress
            </h5>
            <button
              type="button"
              class="btn-close"
              @click="closeStudentProgress"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <div v-if="studentErrorMessage" class="alert alert-danger">
              {{ studentErrorMessage }}
            </div>
            <div v-if="studentProgress.length === 0 && !studentErrorMessage">
              <p>No progress data available.</p>
            </div>
            <div v-else>
              <div
                v-for="chapter in studentProgress"
                :key="chapter.chapter_id"
                class="card mb-2"
              >
                <div class="card-body">
                  <h6 class="card-title">{{ chapter.title }}</h6>
                  <p class="card-text">
                    Levels completed: {{ chapter.completed_levels }} /
                    {{ chapter.total_levels }}
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              @click="closeStudentProgress"
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
  
  <script>
  import { useLoginStore } from '../stores/loginStore';
  import * as bootstrap from "bootstrap";
  
  export default {
    data() {
      return {
        classes: [],
        errorMessage: '',
        selectedStudent: null,
        studentProgress: [],
        studentErrorMessage: ''
      };
    },
    methods: {
      async createClass() {
        const loginStore = useLoginStore();
        if (!loginStore.user_id) {
          this.errorMessage = 'You must be logged in as a teacher.';
          return;
        }
        try {
          const response = await fetch('./codebara-backend/class-api/CreateClassAPI.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ teacher_id: loginStore.user_id }),
          });
          const data = await response.json();
          if (data.error) {
            this.errorMessage = data.error;
          } else {
            this.loadClasses();
          }
        } catch (error) {
          console.error(error);
          this.errorMessage = 'An error occurred while creating the class.';
        }
      },
      async loadClasses() {
        const loginStore = useLoginStore();
        if (!loginStore.user_id) {
          this.errorMessage = 'You must be logged in as a teacher.';
          return;
        }
        try {
          const response = await fetch(`./codebara-backend/class-api/GetClassDetailsAPI.php?teacher_id=${loginStore.user_id}`);
          const data = await response.json();
          if (data.error) {
            this.errorMessage = data.error;
          } else {
            this.classes = data.classes;
          }
        } catch (error) {
          console.error(error);
          this.errorMessage = 'An error occurred while loading classes.';
        }
      },
      async openStudentProgress(student) {
        this.selectedStudent = student;
        this.studentErrorMessage = '';
        this.studentProgress = [];
        
        try {
          const response = await fetch(`./codebara-backend/level-api/GetStudentLevelsDashboardAPI.php?user_id=${student.user_id}`);
          const data = await response.json();
          if (data.error) {
            this.studentErrorMessage = data.error;
          } else {
            this.studentProgress = data.chapters;
          }
        } catch (error) {
          console.error(error);
          this.studentErrorMessage = 'An error occurred while loading student progress.';
        }
        
        const modalEl = document.getElementById('studentProgressModal');
        const modal = new bootstrap.Modal(modalEl);
        modal.show();
      },

      closeStudentProgress() {
        const modalEl = document.getElementById('studentProgressModal');
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) {
          modal.hide();
        }
        this.selectedStudent = null;
        this.studentProgress = [];
        this.studentErrorMessage = '';
      }
    },
    mounted() {
      this.loadClasses();
    },
  };
  </script>
  
  <style scoped>
  /* Container for the whole dashboard */
  .class-dashboard-container {
    max-width: 600px;
    margin: 20px auto;
    background-color: #fbe2cd; /* Light peach background */
    padding: 20px;
    border-radius: 8px;
    border: 1px solid #f3c9a6;
    font-family: Arial, sans-serif;
  }
  
  /* Page Title */
  .page-title {
    margin-bottom: 20px;
    text-align: center;
    font-weight: bold;
    color: #5a3f2a;
  }
  
  /* Button to create a new class */
  .create-class-btn {
    display: inline-block;
    background-color: #d17c33; 
    color: #fff;
    padding: 10px 16px;
    margin-bottom: 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
  }
  .create-class-btn:hover {
    background-color: #b97c51;
  }
  
  /* "No classes" placeholder text */
  .no-classes {
    text-align: center;
    color: #5a3f2a;
  }
  
  /* Individual class card */
  .class-card {
    background-color: #f5d0ae;
    border: 1px solid #e8b995;
    border-radius: 6px;
    padding: 15px;
    margin-bottom: 15px;
  }
  
  /* The header row (class code + Students button) */
  .class-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  /* Class code text */
  .class-code {
    font-weight: bold;
    color: #5a3f2a;
  }
  
  /* Students button on each card */
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
  
  /* The students section that slides down */
  .students-section {
    margin-top: 15px;
    background-color: #f6e3d3;
    padding: 10px;
    border-radius: 4px;
  }
  
  /* Basic styling for lists */
  .students-section ul {
    list-style: disc;
    padding-left: 20px;
    margin: 0;
  }
  .students-section li {
    margin-bottom: 5px;
  }
  
  /* Transition for showing/hiding student list */
  .slide-fade-enter-active, .slide-fade-leave-active {
    transition: all .3s ease;
  }
  .slide-fade-enter, .slide-fade-leave-to {
    opacity: 0;
    transform: translateY(-5px);
  }
  
  .modal-content {
  background-color: #fbe2cd; /* same light peach color as the container */
  border: 1px solid #f3c9a6; /* matching border color */
  border-radius: 8px;        /* rounded corners */
  font-family: Arial, sans-serif; /* keep the same font */
}

/* Header */
.modal-header {
  border-bottom: 1px solid #f3c9a6;
  background-color: #fbe2cd;
  color: #5a3f2a; /* same text color used on the dashboard */
}

.modal-title {
  font-weight: bold;
}

/* Body */
.modal-body {
  color: #5a3f2a; /* for any text in the body */
}

/* Card styling within the modal body (for each chapter) */
.modal-body .card {
  background-color: #f5d0ae;
  border: 1px solid #e8b995;
  border-radius: 6px;
}
.modal-body .card .card-body {
  padding: 10px;
}

/* Footer */
.modal-footer {
  border-top: 1px solid #f3c9a6;
  background-color: #fbe2cd;
}

/* Close button in footer (if you use .btn-secondary for “Close”) */
.modal-footer .btn-secondary {
  background-color: #d17c33;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-weight: bold;
  padding: 6px 12px;
  cursor: pointer;
}
.modal-footer .btn-secondary:hover {
  background-color: #b97c51;
}
  </style>
  