class Environment {
  float gravity;
  float windSpeed;
  
  Environment() {
    gravity = random(0.1, 0.5);
    windSpeed = random(-0.2, 0.2);
  }
}
