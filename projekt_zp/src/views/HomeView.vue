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
                Sorem ipsum dolor sit amet, consectetur adipiscing elit.
                Etiam eu turpis molestie, dictum est a, mattis tellus.
                Sed dignissim, metus nec fringilla accumsan, risus sem
                sollicitudin lacus, ut interdum tellus elit sed risus.
                Maecenas eget condimentum velit, sit amet feugiat lectus.
              </p>
            </div>

            <div class="about-image col-md-6">
              <img
                src="@/assets/python_logo.png"
                alt="Python Icon"
              />
            </div>
          </div>
        </div>
        
      </section>
  
      <section class="learn-section">
        <div class="container">
          <div class="row">
            <div class="capybara-speech col-md-6">
              <img src="@/assets/bubble.png"  alt="Capybara with speech bubble"/>
                    
            </div>
            <div class="learn-text col-md-6">
              <h2>What can you learn?</h2>
              <ul>
                <li>Sorem ipsum dolor sit amet, consectetur adipiscing elit.</li>
                <li>Sed dignissim, metus nec fringilla accumsan.</li>
                <li>Maecenas eget condimentum velit, sit amet feugiat lectus.</li>
                <li>Class aptent taciti sociosqu ad litora torquent.</li>
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
  align-items:end;
  padding: 6vh;
  width: 100%; 
  box-sizing: border-box;
}

.about-text , .learn-text{
  margin-top: 5vh;
  font-size: 1.25rem;
}
.about-text h2 ,.learn-text h2{
  margin-top: 0;
  font-size: 2rem;
  color: #d97b34;
  margin-bottom: 1rem;
}
.about-text p {
  line-height: 1.6;
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
