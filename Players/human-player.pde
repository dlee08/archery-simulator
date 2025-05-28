class HumanPlayer {
  String name;
  int score;
  ArrayList<Arrow> arrows;
  Mouse mouse;

  HumanPlayer(String name, Mouse mouse) {
    this.name = name;
    this.score = 0;
    this.arrows = new ArrayList<Arrow>();
    this.mouse = mouse;
  }

  Arrow fireArrow(Target target) {
    float angle = calculateAngle(mouse.mouseX, mouse.mouseY, target.position.x, target.position.y);
    float power = calculatePower(mouse.mouseX, mouse.mouseY);
    Arrow arrow = new Arrow(angle, power);
    arrows.add(arrow);
    return arrow;
  }

  void upgradeArrow(String upgradeType) {
  }

  float calculateAngle(float fromX, float fromY, float toX, float toY) {
    return atan2(toY - fromY, toX - fromX);
  }

  float calculatePower(float mouseX, float mouseY) {
    return dist(mouseX, mouseY, width/2, height) * 0.1;
  }
}

class Mouse {
  int mouseX;
  int mouseY;

  Mouse() {
    update();
  }

  void update() {
    this.mouseX = mouseX;
    this.mouseY = mouseY;
  }
}
