import Sk from "skulpt";

export function addCapyToSkulpt(vueInstance) {
  const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

  const HERO_WIDTH = 45;
  const HERO_HEIGHT = 66;
  const BOUNDARY_WIDTH = 500;
  const BOUNDARY_HEIGHT = 500;

  function collides(heroX, heroY, obs) {
    const obsWidth = 50,
      obsHeight = 50;

    return (
      heroX < obs.position_x + obsWidth &&
      heroX + HERO_WIDTH > obs.position_x &&
      heroY < obs.position_y + obsHeight &&
      heroY + HERO_HEIGHT > obs.position_y
    );
  }

  function clampX(x) {
    const maxX = BOUNDARY_WIDTH - HERO_WIDTH;
    return Math.max(0, Math.min(x, maxX));
  }

  function clampY(y) {
    const maxY = BOUNDARY_HEIGHT - HERO_HEIGHT;
    return Math.max(0, Math.min(y, maxY));
  }

  const Capy = function ($gbl, $loc) {
    $loc.__init__ = new Sk.builtin.func(function (self) {
      self.position = { x: 53, y: 55 };
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
      const deltaX = 50 * steps;
      let newX = self.position.x + deltaX;
      newX = clampX(newX);

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
            obs.type === "finish" &&
            collides(self.position.x, self.position.y, obs)
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
      const deltaX = -50 * steps;
      let newX = self.position.x + deltaX;
      newX = clampX(newX);

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
            obs.type === "finish" &&
            collides(self.position.x, self.position.y, obs)
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
      const deltaY = -50 * steps;
      let newY = self.position.y + deltaY;
      newY = clampY(newY);

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
            obs.type === "finish" &&
            collides(self.position.x, self.position.y, obs)
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
      const deltaY = 50 * steps;
      let newY = self.position.y + deltaY;
      newY = clampY(newY);

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
            obs.type === "finish" &&
            collides(self.position.x, self.position.y, obs)
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

      if (!vueInstance.capyMessages) {
        vueInstance.capyMessages = [];
      }
      vueInstance.capyMessages.push(message);

      console.log(`Capy says: "${message}"`);

      return Sk.misceval.promiseToSuspension(
        sleep(1000).then(() => Sk.builtin.none.none$)
      );
    });
  };

  Sk.builtin.Capy = Sk.misceval.buildClass(Sk.builtins, Capy, "Capy", []);
  Sk.builtins.capy = Sk.misceval.callsimOrSuspend(Sk.builtin.Capy);
}
