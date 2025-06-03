// Target.pde
class Target {
  float x, y;
  float baseRadius;
  int ringCount;
  float ringWidth;
  float[] ringRadii;
  int[] ringPoints = {10, 8, 6, 4, 2};

  Target(float startX, float startY) {
    x = startX;
    y = startY;
    baseRadius = 50;
    ringCount = ringPoints.length;
    ringWidth = baseRadius / ringCount;
    ringRadii = new float[ringCount];
    for (int i = 0; i < ringCount; i++) {
      ringRadii[i] = ringWidth * (i + 1);
    }
  }

  void move() {
    if (keyPressed) {
      if (key == 'a' || keyCode == LEFT)  x -= 5;
      if (key == 'd' || keyCode == RIGHT) x += 5;
      if (key == 'w' || keyCode == UP)    y -= 5;
      if (key == 's' || keyCode == DOWN)  y += 5;
      if (key == 'n') {
        baseRadius = max(20, baseRadius - 5);
        ringWidth = baseRadius / ringCount;
        for (int i = 0; i < ringCount; i++) {
          ringRadii[i] = ringWidth * (i + 1);
        }
      }
      if (key == 'm') {
        baseRadius = min(200, baseRadius + 5);
        ringWidth = baseRadius / ringCount;
        for (int i = 0; i < ringCount; i++) {
          ringRadii[i] = ringWidth * (i + 1);
        }
      }
    }
    x = constrain(x, baseRadius, width - baseRadius);
    y = constrain(y, baseRadius, height / 2);
  }

  void display() {
    for (int i = ringCount - 1; i >= 0; i--) {
      if ((i + 1) % 2 == 0) fill(255);
      else fill(0);
      ellipse(x, y, ringRadii[i] * 2, ringRadii[i] * 2);
    }
    fill(255, 0, 0);
    ellipse(x, y, ringWidth, ringWidth);
  }

  int scoreShot(float hx, float hy) {
    float dx = abs(hx - x);
    float dy = abs(hy - y);
    float distToCenter = sqrt(dx * dx + dy * dy);
    for (int i = 0; i < ringCount; i++) {
      if (distToCenter <= ringRadii[i]) {
        return ringPoints[i];
      }
    }
    return 0;
  }

  void handleKey(int code, char kc) {
    float step = 5;
    if (code == UP)    y -= step;
    if (code == DOWN)  y += step;
    if (code == LEFT)  x -= step;
    if (code == RIGHT) x += step;
    if (kc == 'n') {
      baseRadius = max(20, baseRadius - 5);
      ringWidth = baseRadius / ringCount;
      for (int i = 0; i < ringCount; i++) {
        ringRadii[i] = ringWidth * (i + 1);
      }
    }
    if (kc == 'm') {
      baseRadius = min(200, baseRadius + 5);
      ringWidth = baseRadius / ringCount;
      for (int i = 0; i < ringCount; i++) {
        ringRadii[i] = ringWidth * (i + 1);
      }
    }
    x = constrain(x, baseRadius, width - baseRadius);
    y = constrain(y, baseRadius, height / 2);
  }
}
