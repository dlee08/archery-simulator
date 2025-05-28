void setup() {
  size(400, 400);
  background(255);
  noLoop();
}

void draw() {
  int centerX = width / 2;
  int centerY = height / 2;
  int maxRadius = 150;
  int rings = 6;
  
  for (int i = rings; i > 0; i--) {
    if (i % 2 == 0) {
      fill(255, 0, 0);  // Red
    } else {
      fill(255);        // White
    }
    ellipse(centerX, centerY, i * maxRadius / rings * 2, i * maxRadius / rings * 2);
  }
}
