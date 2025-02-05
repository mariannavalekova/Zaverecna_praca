<template>
    <div class="container mt-4">
      <h2>Student Class Dashboard</h2>
      
      <!-- Form to join a class -->
      <div class="join-class-form mb-4">
        <label for="classCode">Enter Class Code:</label>
        <input
          type="text"
          id="classCode"
          v-model="classCode"
          placeholder="Enter 10-character class code"
          class="form-control"
        />
        <button class="btn btn-primary mt-2" @click="joinClass">Join Class</button>
      </div>
      
      <!-- Display messages -->
      <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>
      <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>
      
      <!-- Display the joined classes -->
      <div v-if="classes.length">
        <h3>Your Joined Classes</h3>
        <div v-for="cls in classes" :key="cls.class_id" class="card mb-3">
          <div class="card-body">
            <h5 class="card-title">Class Code: {{ cls.class_code }}</h5>
            <p class="card-text">Class ID: {{ cls.class_id }}</p>
            <h6>Students:</h6>
            <ul>
              <li v-for="student in cls.students" :key="student.user_id">
                {{ student.username }} (ID: {{ student.user_id }})
              </li>
            </ul>
            <div v-if="cls.students.length === 0">
              <em>No students have joined this class yet.</em>
            </div>
          </div>
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
        // Clear previous messages
        this.errorMessage = '';
        this.successMessage = '';
        
        const loginStore = useLoginStore();
        if (!loginStore.user_id) {
          this.errorMessage = 'You must be logged in.';
          return;
        }
        
        // Validate the class code length (should be 10 characters)
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
            // Refresh the list of joined classes
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
          const response = await fetch(`./codebara-backend/class-api/GetStudentClassesAPI.php?student_id=${loginStore.user_id}`);
          const data = await response.json();
          if (data.error) {
            this.errorMessage = data.error;
          } else {
            this.classes = data.classes;
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
  .container {
    max-width: 800px;
  }
  .join-class-form {
    margin-bottom: 20px;
  }
  </style>
  