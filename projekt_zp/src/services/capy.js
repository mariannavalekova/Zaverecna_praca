import Sk from "skulpt";

export function addCapyToSkulpt(vueInstance) {
  const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

  function collides(heroX, heroY, obs) {
    const heroWidth = 100,
      heroHeight = 100;
    const obsWidth = 80,
      obsHeight = 80;
    return (
      heroX < obs.position_x + obsWidth &&
      heroX + heroWidth > obs.position_x &&
      heroY < obs.position_y + obsHeight &&
      heroY + heroHeight > obs.position_y
    );
  }

  const Capy = function ($gbl, $loc) {
    $loc.__init__ = new Sk.builtin.func(function (self) {
      self.position = { x: 100, y: 100 };
      return Sk.builtin.none.none$;
    });

    $loc.moveRight = new Sk.builtin.func(function (self, steps) {
      steps = steps === undefined ? 1 : Sk.ffi.remapToJs(steps);
      if (typeof steps !== "number" || steps < 1 || steps > 10) {
        throw new Sk.builtin.ValueError(
          "Steps must be a number between 1 and 10."
        );
      }

      vueInstance.updateHeroAnimation("mover");
      const deltaX = 20 * steps;
      const newX = self.position.x + deltaX;

      const rockCollision = vueInstance.obstacles.some(
        (obs) => obs.type === "rock" && collides(newX, self.position.y, obs)
      );
      if (rockCollision) {
        throw new Sk.builtin.ValueError("Cannot move right: rock in the way.");
      }

      self.position.x = newX;
      vueInstance.smoothMove(newX, self.position.y);

      setTimeout(() => {
        const finishCollision = vueInstance.obstacles.some(
          (obs) =>
            obs.type === "finish" && collides(self.position.x, self.position.y, obs)
        );
        if (finishCollision && typeof vueInstance.levelCompleted === "function") {
          vueInstance.levelCompleted();
        }
      }, 1000);

      return Sk.misceval.promiseToSuspension(
        sleep(1000).then(() => Sk.builtin.none.none$)
      );
    });

    $loc.moveLeft = new Sk.builtin.func(function (self, steps) {
      steps = steps === undefined ? 1 : Sk.ffi.remapToJs(steps);
      if (typeof steps !== "number" || steps < 1 || steps > 10) {
        throw new Sk.builtin.ValueError(
          "Steps must be a number between 1 and 10."
        );
      }

      vueInstance.updateHeroAnimation("movel");
      const deltaX = -20 * steps;
      const newX = self.position.x + deltaX;

      const rockCollision = vueInstance.obstacles.some(
        (obs) => obs.type === "rock" && collides(newX, self.position.y, obs)
      );
      if (rockCollision) {
        throw new Sk.builtin.ValueError("Cannot move left: rock in the way.");
      }

      self.position.x = newX;
      vueInstance.smoothMove(newX, self.position.y);

      setTimeout(() => {
        const finishCollision = vueInstance.obstacles.some(
          (obs) =>
            obs.type === "finish" && collides(self.position.x, self.position.y, obs)
        );
        if (finishCollision && typeof vueInstance.levelCompleted === "function") {
          vueInstance.levelCompleted();
        }
      }, 1000);

      return Sk.misceval.promiseToSuspension(
        sleep(1000).then(() => Sk.builtin.none.none$)
      );
    });

    $loc.moveUp = new Sk.builtin.func(function (self, steps) {
      steps = steps === undefined ? 1 : Sk.ffi.remapToJs(steps);
      if (typeof steps !== "number" || steps < 1 || steps > 10) {
        throw new Sk.builtin.ValueError(
          "Steps must be a number between 1 and 10."
        );
      }

      vueInstance.updateHeroAnimation("moveu");
      const deltaY = -20 * steps;
      const newY = self.position.y + deltaY;

      const rockCollision = vueInstance.obstacles.some(
        (obs) => obs.type === "rock" && collides(self.position.x, newY, obs)
      );
      if (rockCollision) {
        throw new Sk.builtin.ValueError("Cannot move up: rock in the way.");
      }

      self.position.y = newY;
      vueInstance.smoothMove(self.position.x, newY);

      setTimeout(() => {
        const finishCollision = vueInstance.obstacles.some(
          (obs) =>
            obs.type === "finish" && collides(self.position.x, self.position.y, obs)
        );
        if (finishCollision && typeof vueInstance.levelCompleted === "function") {
          vueInstance.levelCompleted();
        }
      }, 1000);

      return Sk.misceval.promiseToSuspension(
        sleep(1000).then(() => Sk.builtin.none.none$)
      );
    });

    $loc.moveDown = new Sk.builtin.func(function (self, steps) {
      steps = steps === undefined ? 1 : Sk.ffi.remapToJs(steps);
      if (typeof steps !== "number" || steps < 1 || steps > 10) {
        throw new Sk.builtin.ValueError(
          "Steps must be a number between 1 and 10."
        );
      }

      vueInstance.updateHeroAnimation("moved");
      const deltaY = 20 * steps;
      const newY = self.position.y + deltaY;

      const rockCollision = vueInstance.obstacles.some(
        (obs) => obs.type === "rock" && collides(self.position.x, newY, obs)
      );
      if (rockCollision) {
        throw new Sk.builtin.ValueError("Cannot move down: rock in the way.");
      }

      self.position.y = newY;
      vueInstance.smoothMove(self.position.x, newY);

      setTimeout(() => {
        const finishCollision = vueInstance.obstacles.some(
          (obs) =>
            obs.type === "finish" && collides(self.position.x, self.position.y, obs)
        );
        if (finishCollision && typeof vueInstance.levelCompleted === "function") {
          vueInstance.levelCompleted();
        }
      }, 1000);

      return Sk.misceval.promiseToSuspension(
        sleep(1000).then(() => Sk.builtin.none.none$)
      );
    });

    $loc.collect = new Sk.builtin.func(function (self) {
      let collected = false;
      vueInstance.obstacles = vueInstance.obstacles.filter((obs) => {
        if (obs.type === "tangerine" && collides(self.position.x, self.position.y, obs)) {
          collected = true;
          return false; 
        }
        return true;
      });

      if (collected) {
        if (vueInstance.tangerinesCollected === undefined) {
          vueInstance.tangerinesCollected = 0;
        }
        vueInstance.tangerinesCollected += 1;
        vueInstance.updateHeroAnimation("pickup");
      }

      return Sk.misceval.promiseToSuspension(
        sleep(1000).then(() => Sk.builtin.none.none$)
      );
    });

    $loc.say = new Sk.builtin.func(function (self, message) {
      message = Sk.ffi.remapToJs(message);
      console.log(`Capy says: "${message}"`);
      return Sk.misceval.promiseToSuspension(
        sleep(1000).then(() => Sk.builtin.none.none$)
      );
    });
  };

  Sk.builtin.Capy = Sk.misceval.buildClass(Sk.builtins, Capy, "Capy", []);
  Sk.builtins.capy = Sk.misceval.callsimOrSuspend(Sk.builtin.Capy);
}
