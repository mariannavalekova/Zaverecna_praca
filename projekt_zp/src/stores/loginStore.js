import { defineStore } from 'pinia';

export const useLoginStore = defineStore({
  id: 'login',
  state: () => ({
    token: null,
    user_id: null, 
    user_is_admin: false, 
    user_is_teacher: false 
  }),
  getters: {
    userAuthorised(state) {
      return !!state.token; 
    },
  },
  actions: {
    setToken(token) {
      this.token = token;
      localStorage.setItem('token', token);
    },
    setUserInfo(user_id, user_is_admin, user_is_teacher) {
      this.user_id = user_id;
      this.user_is_admin = user_is_admin;
      this.user_is_teacher = user_is_teacher;
      localStorage.setItem('user_id', user_id);
      localStorage.setItem('user_is_admin', user_is_admin ? 'true' : 'false'); 
      localStorage.setItem('user_is_teacher', user_is_teacher ? 'true' : 'false');
    },
    loadUserInfoFromLocalStorage() {
      const user_id = localStorage.getItem('user_id');
      const user_is_admin = localStorage.getItem('user_is_admin') === 'true'; 
      const user_is_teacher = localStorage.getItem('user_is_teacher') === 'true';
      if (user_id) {
        this.user_id = user_id;
      }
      this.user_is_admin = user_is_admin;
      this.user_is_teacher = user_is_teacher;
    },
    clearToken() {
      this.token = null;
      this.user_id = null;
      this.user_is_admin = false;
      this.user_is_teacher = false;
      localStorage.removeItem('token');
      localStorage.removeItem('user_id');
      localStorage.removeItem('user_is_admin');
      localStorage.removeItem('user_is_teacher');
    },
    loadTokenFromLocalStorage() {
      const token = localStorage.getItem('token');
      if (token) {
        this.token = token;
      }
    },
    getToken() {
      return this.token;
    },
  },
});
