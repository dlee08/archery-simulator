class Arrow {
  float x, y;
  float baseSize;
  float speed;
  boolean flying;
  boolean stuck;
  int score;

  Arrow(float startX, float startY) {
    x = startX;
    y = startY;
    baseSize = 40;
    speed = 10;
    flying = false;
    stuck = false;
    score = 0;
  }

  void update() {
    if (flying && !stuck) {
      y -= speed;
      baseSize = map(y, height - 50, 100, 40, 10);
      baseSize = constrain(baseSize, 10, 40);

      if (y <= 100) {
        y = 100;
        flying = false;
        stuck = true;
      }
    }
  }

void display() {
  pushMatrix();
  translate(x, y);

  float size = map(y, height - 50, 100, 40, 10);
  size = constrain(size, 10, 40);
  
  noStroke();

  // Shaft (thinner)
  fill(120, 60, 20);
  float shaftWidth = size * 0.15f;
  float shaftHeight = size * 1.5f;
  rect(-shaftWidth / 2, -shaftHeight / 2, shaftWidth, shaftHeight);

  fill(200, 0, 0);
  float headWidth = size * 0.5f;
  float headHeight = size * 0.6f;
  triangle(-headWidth / 2, -shaftHeight / 2,
           headWidth / 2, -shaftHeight / 2,
           0, -shaftHeight / 2 - headHeight);

  fill(255, 255, 255);
  float featherWidth = size * 0.2f;
  float featherHeight = size * 0.4f;
  float featherSpacing = featherWidth * 1.2f;

  pushMatrix();
  translate(0, shaftHeight / 2 - featherHeight / 2);
  
  pushMatrix();
  rotate(radians(-20));
  rect(-featherSpacing, 0, featherWidth, featherHeight, featherWidth * 0.3f);
  popMatrix();
  
  rect(-featherWidth / 2, 0, featherWidth, featherHeight, featherWidth * 0.3f);
  
  pushMatrix();
  rotate(radians(20));
  rect(featherSpacing - featherWidth, 0, featherWidth, featherHeight, featherWidth * 0.3f);
  popMatrix();

  popMatrix();

  popMatrix();
}


  void fire() {
    if (!flying && !stuck) {
      flying = true;
    }
  }

  void reset(float startX, float startY) {
    x = startX;
    y = startY;
    baseSize = 40;
    flying = false;
    stuck = false;
    score = 0;
  }

  boolean isAtTarget(float targetY) {
    return stuck && y == targetY;
  }
}
