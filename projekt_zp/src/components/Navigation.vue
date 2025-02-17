<template>
  <div class="navbar">
    <div class="left-section">
      <router-link :to="homeRoute" class="logo">
        <img src="@/assets/logo.png" alt="Code bara logo" class="logo-image" />
      </router-link>
      <div class="menu">
        <router-link :to="homeRoute" class="menu-item">Home</router-link>
        <router-link to="/learn" class="menu-item">Learn</router-link>
        
      </div>
    </div>
    <div class="auth">
      <router-link v-if="isUserLoggedIn" to="/account" class="menu-item">Account</router-link>
      <button v-if="isUserLoggedIn" @click="logout" class="menu-item logout-button">Log Out</button>
      <router-link v-else to="/signin" class="menu-item">Sign In</router-link>
    </div>
  </div>
</template>

<script>
import { computed } from 'vue';
import { useLoginStore } from '@/stores/loginStore';
import { useRouter } from 'vue-router';

export default {
  setup() {
    const loginStore = useLoginStore();
    const router = useRouter();

    const isUserLoggedIn = computed(() => loginStore.userAuthorised);
    const isTeacher = computed(() => loginStore.user_is_teacher);
    const homeRoute = computed(() =>
      isTeacher.value ? '/teacher-dashboard' : '/student-dashboard'
    );

    const logout = () => {
      loginStore.clearToken();
      router.push('/');
    };

    return {
      isUserLoggedIn,
      homeRoute,
      logout,
    };
  },
};
</script>

<style scoped>
.navbar {
  background: #d17c33; 
  width: 100%;
  height: 60px; 
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px; 
  box-sizing: border-box;
}

.left-section {
  display: flex;
  align-items: center;
  gap: 40px; 
}

.logo-image {
  height: 60px; 
  width: auto; 
}

.menu {
  display: flex;
  gap: 30px; 
}

.auth {
  display: flex;
  gap: 20px; 
}

.menu-item {
  color: #38210d; 
  font-family: "Jaro-Regular", sans-serif;
  font-size: 24px; 
  font-weight: 400;
  text-decoration: none;
  cursor: pointer;
  background: none;
  border: none;
  padding: 0;
}

.menu-item:hover {
  text-decoration: underline; 
}
</style>
