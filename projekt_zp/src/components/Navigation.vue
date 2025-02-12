<template>
  <div class="navbar">
    <div class="left-section">
      <!-- Logo now links to homeRoute -->
      <router-link :to="homeRoute" class="logo">
        <img src="@/assets/logo.png" alt="Code bara logo" class="logo-image" />
      </router-link>
      <div class="menu">
        <!-- Home now uses homeRoute -->
        <router-link :to="homeRoute" class="menu-item">Home</router-link>
        <!-- Other menu links -->
        <router-link to="/learn" class="menu-item">Learn</router-link>
        
      </div>
    </div>
    <div class="auth">
      <!-- Show the Account link and Log Out button if user is logged in -->
      <router-link v-if="isUserLoggedIn" to="/account" class="menu-item">Account</router-link>
      <button v-if="isUserLoggedIn" @click="logout" class="menu-item logout-button">Log Out</button>
      <!-- Show the Sign In link if the user is not logged in -->
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

    // Check if the user is logged in
    const isUserLoggedIn = computed(() => loginStore.userAuthorised);
    // Determine if the logged-in user is a teacher
    const isTeacher = computed(() => loginStore.user_is_teacher);
    // Set the home route: teachers go to their dashboard, students go to theirs
    const homeRoute = computed(() =>
      isTeacher.value ? '/teacher-dashboard' : '/student-dashboard'
    );

    // Log out by clearing the store and redirecting to the home page
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
  background: #d17c33; /* Custom background color */
  width: 100%;
  height: 80px; /* Fixed height for the navbar */
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px; /* Padding for inner spacing */
  box-sizing: border-box;
}

.left-section {
  display: flex;
  align-items: center;
  gap: 40px; /* Increased spacing between logo and menu */
}

.logo-image {
  height: 60px; /* Fits within the navbar height */
  width: auto; /* Maintains aspect ratio */
}

.menu {
  display: flex;
  gap: 30px; /* Custom spacing between menu items */
}

.auth {
  display: flex;
  gap: 20px; /* Custom spacing between authentication items */
}

/* Style links and buttons similarly */
.menu-item {
  color: #38210d; /* Custom text color */
  font-family: "Jaro-Regular", sans-serif;
  font-size: 24px; /* Larger font size */
  font-weight: 400;
  text-decoration: none;
  cursor: pointer;
  background: none;
  border: none;
  padding: 0;
}

.menu-item:hover {
  text-decoration: underline; /* Adds underline effect on hover */
}
</style>
