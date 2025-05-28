float targetX, targetY;
float targetRadius = 80;

float centerX, centerY;
float angle = 0;
float angularSpeed = 0.03;

float squareStep = 3;
int squareSide = 0;
float squareX, squareY;

enum MovementMode { CIRCULAR, SQUARE }
MovementMode mode = MovementMode.CIRCULAR;

void setup() {
  size(600, 400);
  centerX = width / 2;
  centerY = height / 2;
  
  squareX = centerX + 100;
  squareY = centerY - 100;
  
  targetX = squareX;
  targetY = squareY;
}

void draw() {
  background(220);
  
  if (mode == MovementMode.CIRCULAR) {
    targetX = centerX + 100 * cos(angle);
    targetY = centerY + 100 * sin(angle);
    angle += angularSpeed;
  } else if (mode == MovementMode.SQUARE) {
    moveSquarePath();
  }
  
  drawTarget(targetX, targetY);
  
  fill(0);
  textSize(16);
  textAlign(LEFT, TOP);
  text("Mode: " + mode, 10, 10);
  text("Press 'C' for Circular, 'S' for Square", 10, 30);
}

void drawTarget(float x, float y) {
  int rings = 5;
  float ringWidth = targetRadius / rings;
  
  for (int i = rings; i > 0; i--) {
    if (i % 2 == 0) {
      fill(255);
    } else {
      fill(0);
    }
    ellipse(x, y, ringWidth * 2 * i, ringWidth * 2 * i);
  }
  
  fill(255, 0, 0);
  ellipse(x, y, ringWidth * 2, ringWidth * 2);
}

void moveSquarePath() {
  switch(squareSide) {
    case 0:
      squareX += squareStep;
      if (squareX >= centerX + 100) squareSide = 1;
      break;
    case 1:
      squareY += squareStep;
      if (squareY >= centerY + 100) squareSide = 2;
      break;
    case 2:
      squareX -= squareStep;
      if (squareX <= centerX - 100) squareSide = 3;
      break;
    case 3:
      squareY -= squareStep;
      if (squareY <= centerY - 100) squareSide = 0;
      break;
  }
  targetX = squareX;
  targetY = squareY;
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    mode = MovementMode.CIRCULAR;
  } else if (key == 's' || key == 'S') {
    mode = MovementMode.SQUARE;
  }
}
