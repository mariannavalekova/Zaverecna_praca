<template>
    <div class="container custom-container d-flex justify-content-center align-items-center min-vh-100">
      <div class="card p-3 mb-5 bg-white rounded" style="width: 100%; max-width: 500px;">
        <div class="card-body">
          <div class="mb-4 text-center">
            <h3><strong>Registration</strong></h3>
          </div>
          <form @submit.prevent="registerUser">
            <div class="mb-3">
              <label for="username" class="form-label">Username</label>
              <input type="text" class="form-control" id="meno" v-model="user.username" required>
            </div>
            <div class="mb-3">
              <label for="email" class="form-label">Email</label>
              <input type="email" class="form-control" id="email" v-model="user.email" required>
            </div>
            <div class="mb-3">
              <label for="password" class="form-label">Password</label>
              <div class="input-group">
                <input :type="showPassword ? 'text' : 'password'" class="form-control" id="password" v-model="user.password" required>
                <button type="button" class="btn btn-outline-secondary" @click="togglePasswordVisibility">
                  {{ showPassword ? 'Hide' : 'Show' }}
                </button>
              </div>
            </div>
            <div v-if="errorMessage" class="alert alert-danger mt-3">
              {{ errorMessage }}
            </div>
            <div v-if="successMessage" class="alert alert-success mt-3">
              {{ successMessage }}
            </div>
            <div class="d-grid mt-4">
              <button type="submit" class="btn btn-primary btn-block">Register</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        user: {
          username: '',
          email: '',
          password: ''
        },
        errorMessage: '',
        successMessage: '',
        showPassword: false
      };
    },
    methods: {
      validatePassword(password) {
        console.log('Validating password:', password);
        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_])[A-Za-z\d@$!%*?&_]{8,16}$/;
        const isValid = passwordRegex.test(password);
        console.log('Password valid:', isValid);
        return isValid;
      },
      togglePasswordVisibility() {
        this.showPassword = !this.showPassword;
      },
      registerUser() {
        this.errorMessage = '';
        this.successMessage = '';
  
        console.log('data:', this.user);
  
        if (!this.validatePassword(this.user.password)) {
          this.errorMessage = 'Password must be 8-16 characters long, contain at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 symbol.';
          return;
        }
  
        const url = './codebara-backend/auth-api/RegistrationAPI.php';
        console.log('Sending request to:', url);
  
        fetch(url, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(this.user)
        })
        .then(response => {
          console.log('Response status:', response.status);
          if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
          }
          return response.json();
        })
        .then(data => {
          console.log('Response data:', data);
          this.successMessage = 'User registered successfully';
          setTimeout(() => {
            this.$router.push({ path: '/signin' });
          }, 2000);
        })
        .catch(error => {
          console.error('There was an error!', error);
          this.errorMessage = 'There was an error! ' + error.message;
        });
      }
    }
  };
  </script>
  
  <style scoped>
  .alert {
    margin-top: 20px;
  }
  </style>