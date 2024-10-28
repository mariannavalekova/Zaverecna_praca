<template>
  <canvas ref="gameCanvas" width="500" height="500"></canvas>
</template>

<script>
export default {
  data() {
    return {
      ctx: null,
      character: { x: 250, y: 250 },
    };
  },
  mounted() {
    this.ctx = this.$refs.gameCanvas.getContext("2d");
    this.drawCharacter();
  },
  methods: {
    drawCharacter() {
      if (this.ctx) {
        this.ctx.clearRect(0, 0, 500, 500);
        this.ctx.fillStyle = "blue";
        this.ctx.fillRect(this.character.x, this.character.y, 20, 20);
        console.log("Character Position:", this.character); // Debug log
      }
    },
    runCommands(commands) {
      commands.forEach((commandObj, index) => {
        setTimeout(() => {
          this.executeCommand(commandObj);
          this.drawCharacter();
        }, index * 500);
      });
    },
    executeCommand({ command, direction }) {
      console.log("Executing Command:", command, direction); // Debug log
      if (command === "move" && direction) {
        switch (direction.toLowerCase()) {
          case "left":
            this.character.x -= 20;
            break;
          case "right":
            this.character.x += 20;
            break;
          case "up":
            this.character.y -= 20;
            break;
          case "down":
            this.character.y += 20;
            break;
        }
      }
    },
  },
};
</script>
