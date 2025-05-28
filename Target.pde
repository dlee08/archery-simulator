float targetX, targetY;
float targetRadius = 80;

void setup() {
  size(600, 400);
  targetX = width / 2;
  targetY = height / 2;
}

void draw() {
  background(220);
  
  int rings = 5;
  float ringWidth = targetRadius / rings;
  
  for (int i = rings; i > 0; i--) {
    if (i % 2 == 0) {
      fill(255);
    } else {
      fill(0);
    }
    ellipse(targetX, targetY, ringWidth * 2 * i, ringWidth * 2 * i);
  }
  
  fill(255, 0, 0);
  ellipse(targetX, targetY, ringWidth * 2, ringWidth * 2);
}

void keyPressed() {
  float step = 5;
  
  if (keyCode == UP) {
    targetY -= step;
  } else if (keyCode == DOWN) {
    targetY += step;
  } else if (keyCode == LEFT) {
    targetX -= step;
  } else if (keyCode == RIGHT) {
    targetX += step;
  }
  
  targetX = constrain(targetX, targetRadius, width - targetRadius);
  targetY = constrain(targetY, targetRadius, height - targetRadius);
}
