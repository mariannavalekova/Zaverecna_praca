import Sk from "skulpt";

function executePythonAsync(userCode, onSuccess, onError) {
  Sk.configure({
    output: (text) => console.log(text), 
    read: (file) => {
      if (Sk.builtinFiles === undefined || Sk.builtinFiles["files"][file] === undefined) {
        throw `File not found: '${file}'`;
      }
      return Sk.builtinFiles["files"][file];
    },
  });

  Sk.misceval.asyncToPromise(() =>
    Sk.importMainWithBody("<stdin>", false, userCode, true)
  ).then(
    (result) => {
      if (onSuccess) {
        onSuccess(result);
      }
    },
    (err) => {
      if (onError) {
        onError(err);
      }
      console.error(err);
    }
  );
}

export { executePythonAsync };
