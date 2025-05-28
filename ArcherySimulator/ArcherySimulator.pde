Arrow arrow;
TargetMovement target;
int score = 0;
boolean scoredThisShot = false;
boolean targetLocked = false;

void setup() {
  size(600, 600);
  target = new TargetMovement(width/2, height/4);
  arrow = new Arrow(width/2, height - 50);
  textAlign(CENTER, CENTER);
  textSize(24);
}

void draw() {
  background(200);

  if (!targetLocked) {
    target.move();
  }
  target.display();

  if (!arrow.flying && !arrow.stuck) {
    arrow.x = mouseX;
  }

  arrow.update();
  arrow.display();

  if (arrow.isAtTarget(target.y) && !scoredThisShot) {
    int points = target.scoreShot(arrow);
    score += points;
    println("Hit scored: " + points + ", Total score: " + score);
    scoredThisShot = true;
  }

  fill(0);
  text("Score: " + score, width/2, 30);
}

void mousePressed() {
  if (!arrow.flying && !arrow.stuck) {
    arrow.fire();
    scoredThisShot = false;
    targetLocked = true;
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    if (arrow.stuck) {
      arrow.reset(width/2, height - 50);
      scoredThisShot = false;
      targetLocked = false;
    }
  }
}
