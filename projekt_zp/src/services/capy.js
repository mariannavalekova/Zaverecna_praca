import Sk from "skulpt";

export function addCapyToSkulpt(vueInstance) {
    const Capy = function ($gbl, $loc) {
      $loc.__init__ = new Sk.builtin.func(function (self) {
        self.position = { x: 100, y: 100 };
        return Sk.builtin.none.none$;
      });
  

$loc.move = new Sk.builtin.func(function (self, direction, steps) {
  direction = Sk.ffi.remapToJs(direction);
  steps = steps === undefined ? 1 : Sk.ffi.remapToJs(steps);

  if (!["up", "down", "left", "right"].includes(direction)) {
    throw new Sk.builtin.ValueError("Invalid direction. Use 'up', 'down', 'left', or 'right'.");
  }

  if (typeof steps !== "number" || steps < 1 || steps > 10) {
    throw new Sk.builtin.ValueError("Steps must be a number between 1 and 10.");
  }

  vueInstance.updateHeroAnimation("move" + direction[0]);

  const deltaX = direction === "right" ? 20 * steps : direction === "left" ? -20 * steps : 0;
  const deltaY = direction === "down" ? 20 * steps : direction === "up" ? -20 * steps : 0;

  const newX = self.position.x + deltaX;
  const newY = self.position.y + deltaY;

  self.position.x = newX;
  self.position.y = newY;

  vueInstance.smoothMove(newX, newY); 

  return Sk.builtin.none.none$;
});

  
      
      $loc.jump = new Sk.builtin.func(function (self) {
        vueInstance.updateHeroAnimation("jump");
        self.position.y -= 20; 
        vueInstance.heroPosition = { ...self.position };
  
        return Sk.builtin.none.none$;
      });
  
      
      $loc.pickUp = new Sk.builtin.func(function (self) {
        vueInstance.updateHeroAnimation("pickup");
        return Sk.builtin.none.none$;
      });
  
      
      $loc.hide = new Sk.builtin.func(function (self) {
        vueInstance.updateHeroAnimation("hide");
        return Sk.builtin.none.none$;
      });
  
      
      $loc.eat = new Sk.builtin.func(function (self, item) {
        item = Sk.ffi.remapToJs(item);
        vueInstance.updateHeroAnimation("eat");
        console.log(`Capy eats: ${item}`);
        return Sk.builtin.none.none$;
      });
  
      
      $loc.say = new Sk.builtin.func(function (self, message) {
        message = Sk.ffi.remapToJs(message);
        console.log(`Capy says: "${message}"`);
        return Sk.builtin.none.none$;
      });
    };
  
    
    Sk.builtin.Capy = Sk.misceval.buildClass(Sk.builtins, Capy, "Capy", []);
    Sk.builtins.capy = Sk.misceval.callsimOrSuspend(Sk.builtin.Capy);
  }
  

  