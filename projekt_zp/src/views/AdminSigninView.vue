<template>
    <main>
      <div class="container d-flex justify-content-center align-items-center" style="height: 100vh;">
        <div class="card w-50">
          <div class="card-body">
            <h5 class="card-title text-center">Admin Sign In</h5>
            <Form @logIn="adminLogin" :errorMessage="errorMessage" />
          </div>
        </div>
      </div>
    </main>
  </template>
  
  <script>
  import Form from '../components/AdminLoginForm.vue';
  import { useLoginStore } from '../stores/loginStore';
  import { useRouter } from 'vue-router';
  
  export default {
    components: {
      Form,
    },
    data() {
      return {
        errorMessage: '',
      };
    },
    methods: {
      async adminLogin(email, password) {
        this.errorMessage = '';
  
        try {
          const response = await fetch('./codebara-backend/auth-api/AdminSigninAPI.php', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              email: email,
              password: password
            })
          });
  
          if (!response.ok) {
            if (response.status === 401) {
              this.errorMessage = 'The entered email or password is incorrect';
            } else {
              throw new Error(`HTTP error! status: ${response.status}`);
            }
            return;
          }
  
          const data = await response.json();
          const loginStore = useLoginStore();
          loginStore.setToken(data.access_token);
          loginStore.setUserInfo(data.user_id, data.user_is_admin, data.user_is_teacher);

          if (!data.user_is_admin) {
            this.errorMessage = 'Access denied. You are not an admin.';
            return;
          }

          this.$router.push('/admin-panel');
        } catch (error) {
          console.error('There was an error!', error);
          this.errorMessage = 'An unexpected error occurred. Please try again.';
        }
      },
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
  </style>
  