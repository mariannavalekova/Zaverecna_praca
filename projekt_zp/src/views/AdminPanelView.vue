<template>
  <div class="container mt-5 mb-5 d-flex justify-content-center">
    <div class="row mt-5 mb-5">
      <!-- Existing Card 1: Chapter Creator -->
      <div class="col-sm-4">
        <div class="card mb-5">
          <div class="row g-0">
            <div class="col-md-4">
              <img src="/img/add-g273330623_1280.png" class="img-fluid rounded-start" alt="...">
            </div>
            <div class="col-md-8">
              <div class="card-body">
                <h5 class="card-title">Chapter Creator</h5>
                <router-link :to="{ name: 'chapter-creator' }" class="nav-link">
                  <span class="btn custom-button-color custom-button-margin">Otvoriť</span>
                </router-link>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Existing Card 2: Level Creator -->
      <div class="col-sm-4">
        <div class="card mb-5">
          <div class="row g-0">
            <div class="col-md-4">
              <img src="/img/add-g273330623_1280.png" class="img-fluid rounded-start" alt="...">
            </div>
            <div class="col-md-8">
              <div class="card-body">
                <h5 class="card-title">Level Creator</h5>
                <router-link :to="{ name: 'level-creator' }" class="nav-link">
                  <span class="btn custom-button-color custom-button-margin">Otvoriť</span>
                </router-link>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- New Card: Article Editor -->
      <div class="col-sm-4">
        <div class="card mb-5">
          <div class="row g-0">
            <div class="col-md-4">
              <img src="/img/add-g273330623_1280.png" class="img-fluid rounded-start" alt="...">
            </div>
            <div class="col-md-8">
              <div class="card-body">
                <h5 class="card-title">Article Editor</h5>
                <router-link :to="{ name: 'article-creator' }" class="nav-link">
                  <span class="btn custom-button-color custom-button-margin">Otvoriť</span>
                </router-link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

    <script>
    import { useLoginStore } from '../stores/loginStore';
    import { useRouter } from 'vue-router';
    
    export default {
      name: 'adminPanel',
      data() {
        return {
          user: useLoginStore(),
          router: useRouter()
        }
      },
      methods: {
          async handleLogout() {
              try {
                  const response = await fetch('./Backend/admin_api/AdminLogoutAPI.php', {
                    method: 'POST',
                    headers: {
                      'Authorization': `Bearer ${this.user.getToken()}`, 
                      'Content-Type': 'application/json'
                    }
              });
  
                if (!response.ok) {
                  throw new Error('Failed to logout');
              } 
  
              this.user.clearToken(); 
              this.router.push({ name: 'adminLogin' }); 
  
            } catch (error) {
            }
        }
      }
    }
    </script>