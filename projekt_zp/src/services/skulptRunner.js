import Sk from "skulpt";

function executePythonSync(userCode, onSuccess, onError) {
    Sk.configure({
      output: (text) => console.log(text), 
      read: (file) => {
        if (Sk.builtinFiles === undefined || Sk.builtinFiles["files"][file] === undefined) {
          throw `File not found: '${file}'`;
        }
        return Sk.builtinFiles["files"][file];
      },
    });
  
    try {
      
      const result = Sk.importMainWithBody("<stdin>", false, userCode, false);
  
      if (onSuccess) {
        onSuccess(result);
      }
      return result; 
    } catch (err) {
      if (onError) {
        onError(err); 
      }
      throw err;
    }
  }
  
  export { executePythonSync };
  