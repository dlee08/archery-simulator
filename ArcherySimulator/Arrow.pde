class Arrow {
  float x, y;
  float speedY = 15;
  float gravity = 0.2;
  float wind = 0;
  boolean flying = false;
  boolean stuck = false;
  float headX, headY;
  float stopY;

  Arrow(float startX, float startY) {
    x = startX;
    y = startY;
    computeHead();
  }

  void fire(float power) {
    flying = true;
    stuck  = false;
    // reduced max speed from 30 → 20
    speedY = map(power, 0, 1, 5, 20);
    wind   = random(-2, 2);
    stopY  = map(power, 0, 1, height - 50, 0);
    computeHead();
  }

  void update() {
    if (flying && !stuck) {
      y       -= speedY;
      speedY   = max(5, speedY - gravity);
      speedY  *= 0.995;
      x       += wind;
      wind    *= 0.99;
      computeHead();
      if (y <= stopY) {
        flying = false;
        stuck  = true;
      }
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    float size = map(y, height - 50, 0, 40, 10);
    size = constrain(size, 10, 40);
    noStroke();
    fill(120, 60, 20);
    float sw = size * 0.15;
    float sh = size * 1.5;
    rect(-sw/2, -sh/2, sw, sh);
    fill(255, 0, 0);
    float hw = size * 0.5;
    float hh = size * 0.6;
    triangle(-hw/2, -sh/2,
             hw/2,  -sh/2,
             0,     -sh/2 - hh);
    fill(255);
    float fw = size * 0.2;
    float fh = size * 0.4;
    float fs = fw * 1.2;
    pushMatrix();
      translate(0, sh/2 - fh/2);
      pushMatrix();
        rotate(radians(-20));
        rect(-fs, 0, fw, fh, fw*0.3);
      popMatrix();
      rect(-fw/2, 0, fw, fh, fw*0.3);
      pushMatrix();
        rotate(radians(20));
        rect(fs - fw, 0, fw, fh, fw*0.3);
      popMatrix();
    popMatrix();
    popMatrix();
  }

  void computeHead() {
    float size = map(y, height - 50, 0, 40, 10);
    size = constrain(size, 10, 40);
    float sh = size * 1.5;
    float hh = size * 0.6;
    headX = x;
    headY = y - (sh/2 + hh);
  }

  float getHeadX() { return headX; }
  float getHeadY() { return headY; }

  void reset(float startX, float startY) {
    x       = startX;
    y       = startY;
    speedY  = 15;
    wind    = 0;
    flying  = false;
    stuck   = false;
    computeHead();
  }
}
