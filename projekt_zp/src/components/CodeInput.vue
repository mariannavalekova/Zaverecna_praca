<template>
  <div class="code-input">
    <textarea
      v-model="userCode"
      placeholder="Write your Python code here..."
    ></textarea>
    <button @click="runCode">Run</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      userCode: `capy.moveRight(3)\ncapy.moveDown(3)`, 
    };
  },
  methods: {
    runCode() {
      this.$emit("executeCode", this.userCode);
    },
  },
};
</script>

<style scoped>
.code-input {
  display: flex;
  flex-direction: column;
  height: 100%;
}

textarea {
  flex-grow: 1;
  resize: none;
  padding: 10px;
  font-family: monospace;
  font-size: 14px;
  border: 1px solid #ccc;
  border-radius: 4px;
  margin-bottom: 10px;
}

button {
  align-self: flex-end;
  padding: 8px 16px;
  background-color: #f5d1a3;
  color: #3e2c17;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #0056b3;
}
</style>
