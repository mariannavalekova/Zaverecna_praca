<template>
  <main>
    <div >
          <Form @logIn="userLogin" :errorMessage="errorMessage"></Form>
    </div>
  </main>
</template>

<script>
import Form from '../components/LoginForm.vue';
import { useLoginStore } from '../stores/loginStore';
import { useRouter } from 'vue-router';

export default {
  components: {
    Form,
  },
  data() {
    return {
      errorMessage: ''
    };
  },
  methods: {
    async userLogin(email, password) {
      this.errorMessage = '';

      try {
        const response = await fetch('/codebara-backend/auth-api/SigninAPI.php', {
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
        console.log('Token:', loginStore.token);
        console.log('User ID:', loginStore.user_id);
        console.log('User is Admin:', loginStore.user_is_admin);
        console.log('User is Teacher:', loginStore.user_is_teacher);

        const router = this.$router;
        router.push('/');
      } catch (error) {
        console.error('There was an error!', error);
        this.errorMessage = 'An unexpected error occurred. Please try again.';
      }
    }
  }
};
</script>
