int screen = 0;
// screen 0 is selecting mode in start page, 1 -> setting location & size, 2 is the game and all its mechs
boolean twoPlayerMode; // vs computer or vs another player
float targetX, targetY, targetSize; // target info
GameManager game; // game instantiation later

void setup() {
  size(600, 600);
  frameRate(50); // didn't use this in class --> makes fps faster or slower
  targetX=width/2;
  targetY=height/4;
  targetSize=50;
}

void draw() {
  if (screen == 0) drawModeSelect();
  else if (screen == 1) drawSettings();
  else {
    if (game.isGameOver()) drawEndScreen();
    else {
      drawBackground();
      game.update();
      game.display();
    }
  }
}

void mousePressed() {
  if (screen == 0) {
    float boxX = width/2 - 100;
    float boxWidth = 200;
    float boxHeight = 50;
    float boxY1 = height/2 - 40;
    float boxY2 = boxY1 + 60;
    // two if statements see which button is clicked (vs comp or vs another)
    if (mouseX > boxX && mouseX < boxX + boxWidth) {
      if (mouseY > boxY1 && mouseY < boxY1 + boxHeight) {
        twoPlayerMode = false;
        screen = 1;
      }
      else if ((mouseY > boxY2) && (mouseY < boxY2 + boxHeight)) {
        twoPlayerMode = true;
        screen = 1;
      }
    }
  }
  else if (screen == 1) {
    // confirm button to see the target location and size that user sets (custom)
    if ((mouseX > width/2-50) && (mouseX < width/2+50) && (mouseY > height-90)  && (mouseY < height-50)) {
      game = new GameManager(twoPlayerMode, targetX, targetY, targetSize);
      screen = 2;
    }
  }
  else {
    // pressing "play again" button makes game go back to start page
    if (game.isGameOver()) {
      screen = 0;
      return;
    }
    game.mousePressed();
  }
}

void keyPressed() {
  if (screen == 1) {
    // keys for drawSettings, change location of target or size
    if (key == 'a' || key == 'A' || keyCode == LEFT)  targetX = max(0, targetX - 5);
    if (key == 'd' || key == 'D' || keyCode == RIGHT) targetX = min(width, targetX + 5);
    if (key == 'w' || key == 'W' || keyCode == UP)    targetY = max(0, targetY - 5);
    if (key == 's' || key == 'S' || keyCode == DOWN)  targetY = min(height/2, targetY + 5);
    if (key == 'n' || key == 'N') targetSize = max(20, targetSize - 5);
    if (key == 'm' || key == 'M') targetSize = min(200, targetSize + 5);
  }
  else if (screen == 2) game.keyPressed();
}

// start page (singleplayer or multiuplayer)
void drawModeSelect() {
  background(100, 150, 200);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(36);
  text("Archery Simulator", width/2, height/4);
  float boxX = width/2-100, boxWidth=200, boxHeight=50;
  float boxY1 = height/2-40, boxY2 = height/2+20;
  fill(230);
  rect(boxX,boxY1,boxWidth,boxHeight,10);
  rect(boxX,boxY2,boxWidth,boxHeight,10);
  fill(0);
  textSize(20);
  text("Single Player", width/2, boxY1+boxHeight/2);
  text("Two Players",  width/2, boxY2+boxHeight/2);
}

// setting the location and size of target
void drawSettings() {
  background(240);
  drawBackground();
  Target preview = new Target(targetX, targetY, targetSize);
  preview.display();
  fill(0);
  textAlign(LEFT, CENTER);
  textSize(18);
  text("Move target: WASD / arrowkeys", 20, height - 140);
  text("Resize target: N & M: " + targetSize, 20, height - 110);
  fill(200);
  rect(width/2-50, height-90, 100, 40, 5);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Confirm", width/2, height-70);
}

// game over screen, hardcoded (kinda)
void drawEndScreen() {
  background(0, 255, 0);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(36);
  text(game.getWinner() + " wins the match!", width/2, height/2 - 20);
  float boxX = width/2 - 75;
  float boxWidth = 150;
  float boxHeight = 50;
  float boxY = height/2 + 20;
  fill(200);
  rect(boxX, boxY, boxWidth, boxHeight, 5);
  fill(0);
  textSize(24);
  text("Play Again", width/2, boxY + boxHeight/2);
}
