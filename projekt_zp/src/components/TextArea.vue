<template>
  <div>
    <textarea v-model="pseudocode" placeholder="#your code here"></textarea>
    <button @click="processCode">Run</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      pseudocode: "",
    };
  },
  methods: {
    processCode() {
      const commands = this.parsePseudocode(this.pseudocode);
      console.log("Parsed Commands:", commands); 
      this.$emit("executeCommands", commands);
    },
    parsePseudocode(code) {
      return code
        .split("\n")
        .map((line) => line.trim())
        .map((line) => {
          const [command, direction] = line.split("(");
          const parsedDirection = direction ? direction.replace(/['"]/g, "").replace(")", "") : null;
          return { command, direction: parsedDirection };
        });
    },
  },
};
</script>
