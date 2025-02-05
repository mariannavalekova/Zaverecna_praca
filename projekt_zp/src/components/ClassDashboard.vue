<template>
    <div class="container mt-4">
      <h2>Class Dashboard</h2>
      <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>
      
      <!-- Button to create a new class -->
      <div class="mb-3">
        <button @click="createClass" class="btn btn-primary">Create Class</button>
      </div>
      
      <!-- Display a message if no classes are found -->
      <div v-if="classes.length === 0">
        <p>No classes found. Create one to get started.</p>
      </div>
      
      <!-- List of classes -->
      <div v-else>
        <div v-for="cls in classes" :key="cls.class_id" class="card mb-3">
          <div class="card-body">
            <h5 class="card-title">Class Code: {{ cls.class_code }}</h5>
            <p class="card-text">Class ID: {{ cls.class_id }}</p>
            <h6>Students:</h6>
            <ul>
              <li
                v-for="student in cls.students"
                :key="student.user_id"
              >
                <a href="#" @click.prevent="openStudentProgress(student)">
                  {{ student.username }} (ID: {{ student.user_id }})
                </a>
              </li>
            </ul>
            <div v-if="cls.students.length === 0">
              <em>No students joined yet.</em>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Student Progress Modal -->
      <div class="modal fade" id="studentProgressModal" tabindex="-1" aria-labelledby="studentProgressModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="studentProgressModalLabel">
                {{ selectedStudent ? selectedStudent.username : '' }}'s Progress
              </h5>
              <button type="button" class="btn-close" @click="closeStudentProgress" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              <div v-if="studentErrorMessage" class="alert alert-danger">
                {{ studentErrorMessage }}
              </div>
              <div v-if="studentProgress.length === 0 && !studentErrorMessage">
                <p>No progress data available.</p>
              </div>
              <div v-else>
                <div v-for="chapter in studentProgress" :key="chapter.chapter_id" class="card mb-2">
                  <div class="card-body">
                    <h6 class="card-title">{{ chapter.title }}</h6>
                    <p class="card-text">
                      Levels completed: {{ chapter.completed_levels }} / {{ chapter.total_levels }}
                    </p>
                  </div>
                </div>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" @click="closeStudentProgress">Close</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  // Import the login store and Bootstrap's modal functionality.
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
      // Create a new class by calling the CreateClass API endpoint.
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
            // Reload the classes to include the new one.
            this.loadClasses();
          }
        } catch (error) {
          console.error(error);
          this.errorMessage = 'An error occurred while creating the class.';
        }
      },
      // Load all classes created by the teacher.
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
      // When a student is clicked, load their progress and open the modal.
      async openStudentProgress(student) {
        this.selectedStudent = student;
        this.studentErrorMessage = '';
        this.studentProgress = [];
        
        try {
          // Use the same API endpoint as StudentLevelsDashboard.vue.
          const response = await fetch(`./codebara-backend/levels-api/GetStudentLevelsDashboardAPI.php?user_id=${student.user_id}`);
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
        
        // Open the modal using Bootstrap's modal API.
        const modalEl = document.getElementById('studentProgressModal');
        const modal = new bootstrap.Modal(modalEl);
        modal.show();
      },
      // Close the modal and clear the student progress data.
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
  .container {
    max-width: 800px;
  }
  .card {
    border: 1px solid #ccc;
  }
  
  /* Style clickable student links */
  a {
    cursor: pointer;
    color: #007bff;
    text-decoration: none;
  }
  a:hover {
    text-decoration: underline;
  }
  </style>
  