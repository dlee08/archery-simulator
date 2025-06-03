// Arrow.pde
class Arrow {
  float x, y;
  float speedY = 15;
  boolean flying = false;
  boolean stuck = false;
  float headX, headY;

  Arrow(float startX, float startY) {
    x = startX;
    y = startY;
    computeHead();
  }

  void update() {
    if (flying && !stuck) {
      y -= speedY;
      computeHead();
      if (y <= 100) {
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
    fill(120, 60, 20);
    float shaftWidth = size * 0.15;
    float shaftHeight = size * 1.5;
    rect(-shaftWidth / 2, -shaftHeight / 2, shaftWidth, shaftHeight);
    fill(200, 0, 0);
    float headWidth = size * 0.5;
    float headHeight = size * 0.6;
    triangle(-headWidth / 2, -shaftHeight / 2,
             headWidth / 2, -shaftHeight / 2,
             0, -shaftHeight / 2 - headHeight);
    fill(255);
    float featherWidth = size * 0.2;
    float featherHeight = size * 0.4;
    float featherSpacing = featherWidth * 1.2;
    pushMatrix();
    translate(0, shaftHeight / 2 - featherHeight / 2);
    pushMatrix();
    rotate(radians(-20));
    rect(-featherSpacing, 0, featherWidth, featherHeight, featherWidth * 0.3);
    popMatrix();
    rect(-featherWidth / 2, 0, featherWidth, featherHeight, featherWidth * 0.3);
    pushMatrix();
    rotate(radians(20));
    rect(featherSpacing - featherWidth, 0, featherWidth, featherHeight, featherWidth * 0.3);
    popMatrix();
    popMatrix();
    popMatrix();
  }

  void computeHead() {
    float size = map(y, height - 50, 100, 40, 10);
    size = constrain(size, 10, 40);
    float shaftHeight = size * 1.5;
    float headHeight = size * 0.6;
    headX = x;
    headY = y - (shaftHeight / 2 + headHeight);
  }

  float getHeadX() {
    return headX;
  }

  float getHeadY() {
    return headY;
  }

  boolean isAtTarget(float targetY) {
    return y <= targetY + 5;
  }

  void fire() {
    flying = true;
    stuck = false;
    computeHead();
  }

  void reset(float startX, float startY) {
    x = startX;
    y = startY;
    flying = false;
    stuck = false;
    computeHead();
  }
}
