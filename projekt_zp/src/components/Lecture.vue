<template>
    <div class="lecture-content">
      <h1>Variables</h1>
  
      <section class="section">
        <h2>What is a Variable?</h2>
        <p>
          A variable is like a box where you can store information. Imagine you have a box with a label, and you put
          something inside it. The label tells you what is inside the box, and you can use it later whenever you need it.
        </p>
        <p>
          In Python, variables store different types of information, such as numbers, words, or other data. You can give
          them any name you like (almost).
        </p>
      </section>
  
      <section class="section">
        <h2>How to Create a Variable</h2>
        <p>
          Creating a variable is super simple! You just need a name and an equal sign <code>=</code> to put something in
          it.
        </p>
        <pre>
  name = "Capy"
  age = 10
  is_happy = True
        </pre>
        <button class="practice-button">Let’s Practice!</button>
      </section>
    </div>
  </template>
  
  <script>
  export default {};
  </script>
  
  <style scoped>
  .lecture-content {
    width: 100%;
    height: 100%;
    padding: 40px;
    font-family: Arial, sans-serif;
    color: #000;
  }
  
  h1 {
    font-size: 32px;
    font-weight: bold;
    margin-bottom: 20px;
  }
  
  h2 {
    font-size: 24px;
    font-weight: bold;
    margin-top: 30px;
    margin-bottom: 10px;
  }
  
  p {
    font-size: 18px;
    line-height: 1.6;
    margin-bottom: 10px;
  }
  
  pre {
    background: #f3d3a47e;
    padding: 15px;
    border-radius: 5px;
    font-size: 18px;
    line-height: 1.6;
    font-family: "Courier New", monospace;
    overflow: auto;
  }
  
  .practice-button:hover {
  background-color: #b7692b;
  transform: scale(1.05); 
}
.practice-button {
  margin-top: 20px;
  padding: 10px 20px;
  background-color: #d17c33;
  color: white;
  font-size: 16px;
  font-weight: bold;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.2s;
}

.practice-button:active {
  transform: scale(1); 
}
  .section {
    margin-bottom: 30px;
  }
  </style>
  