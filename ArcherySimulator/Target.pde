class TargetMovement {
  float x, y;     
  float baseRadius;  
  int ringCount;       
  float ringWidth;    

  int[] ringPoints = {10, 8, 6, 4, 2}; 

  TargetMovement(float startX, float startY) {
    x = startX;
    y = startY;
    baseRadius = 50;
    ringCount = ringPoints.length;
    ringWidth = baseRadius / ringCount;
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
      }
      if (key == 'm') {
        baseRadius = min(200, baseRadius + 5);
        ringWidth = baseRadius / ringCount;
      }
    }

    x = constrain(x, baseRadius, width - baseRadius);
    y = constrain(y, baseRadius, height / 2);
  }

  void display() {
    for (int i = ringCount; i > 0; i--) {
      if (i % 2 == 0) fill(255); else fill(0);
      ellipse(x, y, ringWidth * i * 2, ringWidth * i * 2);
    }
    fill(255, 0, 0);
    ellipse(x, y, ringWidth, ringWidth);
  }

  int scoreShot(Arrow arrow) {
    float dx = abs(arrow.x - x);
    if (dx > baseRadius) {
      return 0;
    }

    int ringHit = (int)(dx / ringWidth);
    ringHit = constrain(ringHit, 0, ringCount - 1);

    if (ringHit == 0) {
      return 10;
    } else {
      if (ringHit % 2 == 0) {
        return 5;
      } else {
        return 3;
      }
    }
  }

}
