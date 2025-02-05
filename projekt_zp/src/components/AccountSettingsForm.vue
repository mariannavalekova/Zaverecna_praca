<template>
    <div class="container mt-4">
      <h2>Account Settings</h2>
      <form @submit.prevent="openSaveModal">
        <!-- Username -->
        <div class="mb-3">
          <label class="form-label">Username</label>
          <input type="text" class="form-control" v-model="form.username" :disabled="!isEditing" />
        </div>
  
        <!-- Email -->
        <div class="mb-3">
          <label class="form-label">Email</label>
          <input type="email" class="form-control" v-model="form.email" :disabled="!isEditing" required />
        </div>
  
        <!-- Teacher Checkbox -->
        <div class="form-check mb-3">
          <input class="form-check-input" type="checkbox" v-model="form.is_teacher" :disabled="!isEditing" />
          <label class="form-check-label">Set as Teacher</label>
        </div>
  
        <!-- Additional Fields (Visible only if is_teacher is true) -->
        <div v-if="form.is_teacher">
          <div class="mb-3">
            <label class="form-label">School Name</label>
            <input type="text" class="form-control" v-model="form.school_name" :disabled="!isEditing" />
          </div>
          <div class="mb-3">
            <label class="form-label">Teacher Name</label>
            <input type="text" class="form-control" v-model="form.teacher_name" :disabled="!isEditing" />
          </div>
          <div class="mb-3">
            <label class="form-label">Teacher Surname</label>
            <input type="text" class="form-control" v-model="form.teacher_surname" :disabled="!isEditing" />
          </div>
        </div>
  
        <!-- Buttons -->
        <div class="mt-3">
          <button type="button" class="btn btn-primary me-2" @click="startEditing" v-if="!isEditing">Edit</button>
          <button type="button" class="btn btn-success me-2" @click="openSaveModal" v-if="isEditing">Save</button>
          <button type="button" class="btn btn-danger" @click="openCancelModal" v-if="isEditing">Cancel</button>
        </div>
      </form>
  
      <!-- Save Modal -->
      <div class="modal fade" id="saveModal" tabindex="-1">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Confirm Save</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
              Are you sure you want to save these changes?
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
              <button type="button" class="btn btn-success" @click="saveChanges">Confirm</button>
            </div>
          </div>
        </div>
      </div>
  
      <!-- Cancel Modal -->
      <div class="modal fade" id="cancelModal" tabindex="-1">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Confirm Cancel</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
              Are you sure you want to discard your changes?
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
              <button type="button" class="btn btn-danger" @click="resetForm">Yes</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  // Import Bootstrap so that bootstrap.Modal is defined
  import * as bootstrap from "bootstrap";
  import { useLoginStore } from "@/stores/loginStore"; // Import Pinia store
  
  export default {
    data() {
      return {
        form: {
          username: "",
          email: "",
          school_name: "",
          teacher_name: "",
          teacher_surname: "",
          is_teacher: false,
        },
        originalForm: {},
        isEditing: false,
      };
    },
    methods: {
      async fetchUserData() {
        const loginStore = useLoginStore();
        if (!loginStore.user_id) return;
  
        try {
          // Use the new GET endpoint
          const response = await fetch(`./codebara-backend/account-api/UserSettingsGetAPI.php?user_id=${loginStore.user_id}`);
          const data = await response.json();
          if (data.error) {
            console.error("Error fetching user data:", data.error);
            return;
          }
          this.form = data;
          this.originalForm = JSON.parse(JSON.stringify(data));
        } catch (error) {
          console.error("Fetch error:", error);
        }
      },
      async saveChanges() {
        const loginStore = useLoginStore();
        if (!loginStore.user_id) return;
  
        try {
          // Use the new POST endpoint
          const response = await fetch("./codebara-backend/account-api/UserSettingsUpdateAPI.php", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ ...this.form, user_id: loginStore.user_id }),
          });
          const result = await response.json();
  
          if (result.success) {
            this.isEditing = false;
            this.originalForm = JSON.parse(JSON.stringify(this.form));
            // Hide the modal after successful update
            const modalEl = document.getElementById("saveModal");
            const modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) modal.hide();
          } else {
            console.error("Error updating user data:", result.error);
          }
        } catch (error) {
          console.error("Fetch error:", error);
        }
      },
      resetForm() {
        this.form = JSON.parse(JSON.stringify(this.originalForm));
        this.isEditing = false;
        // Hide the cancel modal if it is open
        const modalEl = document.getElementById("cancelModal");
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();
      },
      openSaveModal() {
        new bootstrap.Modal(document.getElementById("saveModal")).show();
      },
      openCancelModal() {
        new bootstrap.Modal(document.getElementById("cancelModal")).show();
      },
      startEditing() {
        this.isEditing = true;
      },
    },
    mounted() {
      this.fetchUserData();
    },
  };
  </script>
  