import Sk from "skulpt";

export function addCapyToSkulpt(vueInstance) {
  const Capy = function ($gbl, $loc) {
    $loc.__init__ = new Sk.builtin.func(function (self) {
      self.position = { x: 100, y: 100 };
      return Sk.builtin.none.none$;
    });

    /**
     * moveRight(steps)
     */
    $loc.moveRight = new Sk.builtin.func(function (self, steps) {
      steps = steps === undefined ? 1 : Sk.ffi.remapToJs(steps);

      if (typeof steps !== "number" || steps < 1 || steps > 10) {
        throw new Sk.builtin.ValueError("Steps must be a number between 1 and 10.");
      }

      vueInstance.updateHeroAnimation("mover");   // e.g. "move right" animation

      const deltaX = 20 * steps;
      const deltaY = 0;
      const newX = self.position.x + deltaX;
      const newY = self.position.y + deltaY;

      self.position.x = newX;
      self.position.y = newY;

      vueInstance.smoothMove(newX, newY);

      return Sk.builtin.none.none$;
    });

    /**
     * moveLeft(steps)
     */
    $loc.moveLeft = new Sk.builtin.func(function (self, steps) {
      steps = steps === undefined ? 1 : Sk.ffi.remapToJs(steps);

      if (typeof steps !== "number" || steps < 1 || steps > 10) {
        throw new Sk.builtin.ValueError("Steps must be a number between 1 and 10.");
      }

      vueInstance.updateHeroAnimation("movel");

      const deltaX = -20 * steps;
      const deltaY = 0;
      const newX = self.position.x + deltaX;
      const newY = self.position.y + deltaY;

      self.position.x = newX;
      self.position.y = newY;

      vueInstance.smoothMove(newX, newY);

      return Sk.builtin.none.none$;
    });

    /**
     * moveUp(steps)
     */
    $loc.moveUp = new Sk.builtin.func(function (self, steps) {
      steps = steps === undefined ? 1 : Sk.ffi.remapToJs(steps);

      if (typeof steps !== "number" || steps < 1 || steps > 10) {
        throw new Sk.builtin.ValueError("Steps must be a number between 1 and 10.");
      }

      vueInstance.updateHeroAnimation("moveu");

      const deltaX = 0;
      const deltaY = -20 * steps;
      const newX = self.position.x + deltaX;
      const newY = self.position.y + deltaY;

      self.position.x = newX;
      self.position.y = newY;

      vueInstance.smoothMove(newX, newY);

      return Sk.builtin.none.none$;
    });

    /**
     * moveDown(steps)
     */
    $loc.moveDown = new Sk.builtin.func(function (self, steps) {
      steps = steps === undefined ? 1 : Sk.ffi.remapToJs(steps);

      if (typeof steps !== "number" || steps < 1 || steps > 10) {
        throw new Sk.builtin.ValueError("Steps must be a number between 1 and 10.");
      }

      vueInstance.updateHeroAnimation("moved");

      const deltaX = 0;
      const deltaY = 20 * steps;
      const newX = self.position.x + deltaX;
      const newY = self.position.y + deltaY;

      self.position.x = newX;
      self.position.y = newY;

      vueInstance.smoothMove(newX, newY);


      return Sk.builtin.none.none$;
    });

    /**
     * collect()
     * Example: increment a "tangerinesCollected" variable in vueInstance
     */
    $loc.collect = new Sk.builtin.func(function (self) {
      if (vueInstance.tangerinesCollected === undefined) {
        vueInstance.tangerinesCollected = 0;
      }
      vueInstance.tangerinesCollected += 1;

      // Optionally show an animation or message
      // e.g. vueInstance.updateHeroAnimation("pickup");
      // Or vueInstance.addToConsole(`Collected a tangerine! Total: ${vueInstance.tangerinesCollected}`);

      return Sk.builtin.none.none$;
    });

    

    /**
     * say(message)
     * For example, pass to vueInstance.addToConsole(...) or console.log
     */
    $loc.say = new Sk.builtin.func(function (self, message) {
      message = Sk.ffi.remapToJs(message);
      // If you have a custom console, call: vueInstance.addToConsole(message);
      console.log(`Capy says: "${message}"`);
      return Sk.builtin.none.none$;
    });
  };

  // Build the class
  Sk.builtin.Capy = Sk.misceval.buildClass(Sk.builtins, Capy, "Capy", []);
  Sk.builtins.capy = Sk.misceval.callsimOrSuspend(Sk.builtin.Capy);
}