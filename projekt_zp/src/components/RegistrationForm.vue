<template>
  <div class="registration-container">
    <div class="registration-box">
      <h2 class="form-title">Registration</h2>

      <form @submit.prevent="registerUser">
        <div class="mb-3">
          <label for="meno" class="form-label">Username</label>
          <input
            type="text"
            class="form-control"
            id="meno"
            v-model="user.username"
            required
          />
        </div>

        <div class="mb-3">
          <label for="email" class="form-label">Email</label>
          <input
            type="email"
            class="form-control"
            id="email"
            v-model="user.email"
            required
          />
        </div>

        <div class="mb-3">
          <label for="password" class="form-label">Password</label>
          <div class="input-group">
            <input
              :type="showPassword ? 'text' : 'password'"
              class="form-control"
              id="password"
              v-model="user.password"
              required
            />
            <button
              type="button"
              class="btn toggle-button"
              @click="togglePasswordVisibility"
            >
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
        <div class="button-row">
          <button type="submit" class="btn custom-button-color">Register</button>
        </div>
      </form>
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

  .registration-container {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #fff9f0; 
    margin: 0;
    padding: 0;
  }

  .registration-box {
    background-color: #f8d9b5; 
    padding: 2rem 2.5rem;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    width: 400px;
    max-width: 90%;
    text-align: center;
  }
  
  .form-title {
    margin-bottom: 1.5rem;
    font-family: "Berlin Sans FB", sans-serif;
    font-size: 2rem;
    color: #333;
  }
  
  .form-label {
    display: block;
    text-align: left;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: #38210d;
  }
  
  .form-control {
    width: 100%;
    padding: 0.6rem 0.8rem;
    border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 1rem;
    box-sizing: border-box;
    margin-bottom: 1rem;
  }
  
  .input-group {
    display: flex;
    align-items: center;
  }
  .toggle-button {
    background-color: #fff;
    border: 1px solid #ccc;
    color: #333;
    padding: 0.6rem 1rem;
    border-radius: 5px;
    margin-left: 0.5rem;
    cursor: pointer;
  }
  
  .alert {
    font-size: 0.95rem;
    border-radius: 5px;
    padding: 0.5rem;
    text-align: left; 
  }
  .alert-danger {
    color: #c00;
    background-color: #fee;
  }
  .alert-success {
    color: #0c0;
    background-color: #efe;
  }
  
  .button-row {
    margin-top: 1rem;
  }

  .btn.custom-button-color {
    background-color: #d17c33; 
    color: #fff;
    border: none;
    border-radius: 5px;
    padding: 0.6rem 1.2rem;
    font-size: 1rem;
    cursor: pointer;
  }
  
  .btn.custom-button-color:hover {
    background-color: #c66a2b;
  }
  </style>