<template>
  <div class="login-container">
    <div class="login-box">
      <h2 class="form-title">Sign in</h2>

      <form @submit.prevent="logIn">
        <div class="mb-3">
          <label for="loginInput" class="form-label">Email</label>
          <input v-model="email" type="text" class="form-control" id="loginInput" />
        </div>

        <div class="mb-3">
          <label for="passwordInput" class="form-label">Password</label>
          <div class="input-group">
            <input
              :type="showPassword ? 'text' : 'password'"
              v-model="password"
              class="form-control"
              id="passwordInput"
            />
            <button type="button" class="btn toggle-button" @click="togglePasswordVisibility">
              {{ showPassword ? 'Hide' : 'Show' }}
            </button>
          </div>
        </div>

        <div v-if="errorMessage" class="alert alert-danger">
          {{ errorMessage }}
        </div>

        <button type="submit" class="btn custom-button-color">Sign in</button>
        <router-link to="/registration" class="ms-3">
          <button type="button" class="btn custom-button-color">Register</button>
        </router-link>
      </form>
    </div>
  </div>
</template>
  
  <script>
  export default {
    props: {
      errorMessage: {
        type: String,
        default: ''
      }
    },
    data() {
      return {
        email: '',
        password: '',
        showPassword: false
      };
    },
    methods: {
      logIn() {
        this.$emit('logIn', this.email, this.password);
      },
      togglePasswordVisibility() {
        this.showPassword = !this.showPassword;
      }
    },
    watch: {
      errorMessage(newVal) {
        if (newVal) {
          console.log('Error message:', newVal);
        }
      }
    }
  };
  </script>

<style scoped>
.login-container {
  min-height: 90vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #fff9f0;
  margin: 0;
  padding: 0;
}

.login-box {
  background-color: #f8d9b5;
  padding: 2rem 2.5rem;
  border-radius: 10px;
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

.alert.alert-danger {
  margin-top: -0.5rem;
  margin-bottom: 1rem;
  font-size: 0.95rem;
  color: #c00;
  background-color: #fee;
  border-radius: 5px;
  padding: 0.5rem;
}


.btn.custom-button-color {
  background-color: #d17c33; 
  color: #fff;
  border: none;
  border-radius: 5px;
  padding: 0.6rem 1.2rem;
  font-size: 1rem;
  cursor: pointer;
  margin-top: 0.5rem;
}

.btn.custom-button-color:hover {
  background-color: #c66a2b;
}

.ms-3 {
  margin-left: 1rem !important;
}
</style>