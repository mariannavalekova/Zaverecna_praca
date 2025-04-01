<template>
  <div class="home-container">
    <div class="hero-section">
      <div class="container">
        <img src="@/assets/title.png" alt="Capybara Mascot"/>
      </div>
    </div>  
    <section class="about-section">
      <div class="container">
        <div class="row">
          <div class="about-text col-md-6">
            <h2>What is Codebara?</h2>
            <p>
              Codebara is your fun doorway to the world of coding! With easy lessons and exciting projects, you'll learn cool computer tricks step by step. 
              Whether you're just starting out or already know a few things, Codebara is here to help you become a coding superstar!
            </p>

          </div>
          <div class="about-image col-md-6">
            <img src="@/assets/python_logo.png" alt="Python Icon"/>
          </div>
        </div>
      </div>
    </section>

    <section class="learn-section">
      <div class="container">
        <div class="row">
          <div class="capybara-speech col-md-6">
            <img src="@/assets/bubble.png" alt="Capybara with speech bubble"/>
          </div>
          <div class="learn-text col-md-6">
            <h2>What can you learn?</h2>
            <ul>
              <li>Discover core programming concepts and build a strong foundation.</li>
              <li>Learn practical tips for writing efficient, maintainable code.</li>
              <li>Solve fun coding challenges and watch your cool ideas come to life!</li>
            </ul>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  name: "HomeView",
};
</script>

<style scoped>
.home-container {
  font-family: "Berlin Sans FB", Tahoma, Geneva, Verdana, sans-serif;
  color: #333;
  display: flex;
  flex-direction: column;
  margin: 0;
  padding: 0;
}

.hero-section {
  background: url("@/assets/rb_1308.png") no-repeat center / cover, #a1d86f; 
  text-align: center;
  padding: 2vh;
}
.hero-section img{
  max-height: 400px;
}

.about-section {
  background-color: #f6dfc9; 
  display: flex;
  flex-wrap: wrap; 
  justify-content: space-between;
  align-items: end;
  padding: 6vh;
  width: 100%; 
  box-sizing: border-box;
}

.about-text, .learn-text{
  margin-top: 5vh;
  font-size: 1.25rem;
}
.about-text h2, .learn-text h2{
  margin-top: 0;
  font-size: 2.5rem;
  color: #d97b34;
  margin-bottom: 1rem;
}
.about-text p, .learn-text li {
  line-height: 1.6;
  font-size: 1.5rem;
}

.about-image img {
  width: 50%;
  margin-left: 10vw;
}

.learn-section {
  background-color: #fde7d0;
  padding: 6vh;
  width: 100%;
  box-sizing: border-box;
}

.capybara-speech img {
  max-width: 100%;
  height: auto;
}

.learn-text ul {
  line-height: 1.6;
  margin: 0;
  padding-left: 1.5rem;
}
</style>
