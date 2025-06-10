boolean gameStarted = false;
boolean twoPlayerMode = true;
GameManager game;

void setup() {
  size(600, 600);
  frameRate(30);
}

void draw() {
  if (!gameStarted) {
    drawStartScreen();
  } else {
    drawBackground();
    game.update();
    game.display();
  }
}

void mousePressed() {
  if (!gameStarted) {
    float bx = width/2 - 100, bw = 200, bh = 50;
    float by1 = height/2 - 40, by2 = height/2 + 20;
    if (mouseX > bx && mouseX < bx + bw) {
      if (mouseY > by1 && mouseY < by1 + bh) {
        twoPlayerMode = false;
        startGame();
        return;
      } else if (mouseY > by2 && mouseY < by2 + bh) {
        twoPlayerMode = true;
        startGame();
        return;
      }
    }
  }
  game.mousePressed();
}

void keyPressed() {
  if (gameStarted) {
    game.keyPressed();
  }
}

void startGame() {
  game = new GameManager(twoPlayerMode);
  gameStarted = true;
}

void drawStartScreen() {
  background(100, 150, 200);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(36);
  text("Archery Simulator", width/2, height/4);
  float bx = width/2 - 100, bw = 200, bh = 50;
  float by1 = height/2 - 40, by2 = height/2 + 20;
  fill(230);
  rect(bx, by1, bw, bh, 10);
  fill(0);
  textSize(20);
  text("Single Player", width/2, by1 + bh/2);
  fill(230);
  rect(bx, by2, bw, bh, 10);
  fill(0);
  text("Two Players", width/2, by2 + bh/2);
}
