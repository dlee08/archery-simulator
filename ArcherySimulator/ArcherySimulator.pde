GameManager game;

void setup() {
  size(600, 600);
  game = new GameManager(true);
}

void draw() {
  drawBackground();
  game.update();
  game.display();
}

void mousePressed() {
  game.mousePressed();
}

void keyPressed() {
  game.keyPressed();
}
