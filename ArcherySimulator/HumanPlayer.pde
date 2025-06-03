class HumanPlayer extends Player {
  boolean isAiming = false;
  PVector aimStart, aimCurrent;
  float maxHoldTime = 5000;
  long aimStartMillis;

  HumanPlayer(String n, PVector pos, Environment e) {
    super(n, pos, e);
    aimStart = new PVector();
    aimCurrent = new PVector();
  }
  
  void startAiming(int mx, int my) {
    isAiming = true;
    aimStart.set(mx, my);
    aimCurrent.set(mx, my);
    aimStartMillis = millis();
  }

  void updateAiming(int mx, int my) {
    if (isAiming) {
      aimCurrent.set(mx, my);
      if (millis() - aimStartMillis >= maxHoldTime) {
        releaseArrow();
      }
    }
  }

  Arrow releaseArrow() {
    if (!isAiming) return null;
    isAiming = false;
    PVector drag = PVector.sub(aimCurrent, aimStart);
    PVector initVel = PVector.sub(aimStart, bowPosition).mult(0.1);
    if (initVel.mag() > 20) {
      initVel.setMag(20);
    }
    Arrow a = new Arrow(bowPosition.copy(), initVel, env);
    return a;
  }
  
  void displayAim() {
    if (isAiming) {
      stroke(255, 0, 0);
      strokeWeight(2);
      line(bowPosition.x, bowPosition.y, aimCurrent.x, aimCurrent.y);
      fill(0);
      ellipse(bowPosition.x, bowPosition.y, 8, 8);
    }
  }
  
  Arrow takeTurn() {
    return null;
  }
}

