<template>
  <div class="navbar">
    <div class="left-section">
      <router-link to="/" class="logo">
        <img src="@/assets/logo.png" alt="Code bara logo" class="logo-image" />
      </router-link>
      <div class="menu">
        <router-link to="/" class="menu-item">Home</router-link>
        <router-link to="/learn" class="menu-item">Learn</router-link>
        <router-link to="/play" class="menu-item">Play</router-link>
      </div>
    </div>
    <div class="auth">
      <router-link to="/account" class="menu-item">Account</router-link>
      <router-link to="/signin" class="menu-item">Sign In</router-link>
    </div>
  </div>
</template>

<script>
export default {};
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

.menu-item {
  color: #38210d; /* Custom text color */
  font-family: "Jaro-Regular", sans-serif;
  font-size: 24px; /* Larger font size */
  font-weight: 400;
  text-decoration: none;
  cursor: pointer;
}

.menu-item:hover {
  text-decoration: underline; /* Adds underline effect on hover */
}
</style>
