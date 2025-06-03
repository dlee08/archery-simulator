// ArcherySimulator.pde
Arrow arrow;
Target target;
int score = 0;
boolean scoredThisShot = false;

void setup() {
  size(600, 600);
  target = new Target(width/2, height/4);
  arrow = new Arrow(width/2, height - 50);
  textAlign(CENTER, CENTER);
  textSize(24);
}

void draw() {
  background(200);
  target.move();
  target.display();
  if (!arrow.flying && !arrow.stuck) {
    arrow.x = mouseX;
  }
  arrow.update();
  arrow.display();
  if (arrow.stuck && !scoredThisShot) {
    float hx = arrow.getHeadX();
    float hy = arrow.getHeadY();
    int points = target.scoreShot(hx, hy);
    score += points;
    scoredThisShot = true;
  }
  fill(0);
  text("Score: " + score, width/2, 30);
  text("Move target with WASD/Arrow keys", width/2, height - 80);
  text("Resize target: N (smaller), M (bigger)", width/2, height - 60);
  text("Click to shoot arrow", width/2, height - 40);
}

void mousePressed() {
  if (!arrow.flying && !arrow.stuck) {
    arrow.fire();
    scoredThisShot = false;
  }
}

void keyPressed() {
  if (arrow.stuck && (key == 'r' || key == 'R')) {
    arrow.reset(width/2, height - 50);
    scoredThisShot = false;
  }
  target.handleKey(keyCode, key);
}
