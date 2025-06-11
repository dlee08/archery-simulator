int screen = 0;
boolean twoPlayerMode;
float targetX, targetY, targetSize;
GameManager game;

void setup() {
  size(600, 600);
  frameRate(50);
  targetX    = width/2;
  targetY    = height/4;
  targetSize = 50;
}

void draw() {
  if (screen == 0) {
    drawModeSelect();
  } 
  else if (screen == 1) {
    drawSettings();
  } 
  else {
    drawBackground();
    game.update();
    game.display();
  }
}

void mousePressed() {
  if (screen == 0) {
    float bx = width/2 - 100, bw = 200, bh = 50;
    float by1 = height/2 - 40, by2 = height/2 + 20;
    if (mouseX > bx && mouseX < bx + bw) {
      if (mouseY > by1 && mouseY < by1 + bh) {
        twoPlayerMode = false;
        screen = 1;
      } 
      else if (mouseY > by2 && mouseY < by2 + bh) {
        twoPlayerMode = true;
        screen = 1;
      }
    }
  } 
  else if (screen == 1) {
    if (mouseX > width/2-50 && mouseX < width/2+50
     && mouseY > height-90  && mouseY < height-50) {
      game = new GameManager(twoPlayerMode, targetX, targetY, targetSize);
      screen = 2;
    }
  } 
  else {
    game.mousePressed();
  }
}

void keyPressed() {
  if (screen == 1) {
    if (key == 'a' || keyCode == LEFT)  targetX = max(0, targetX - 5);
    if (key == 'd' || keyCode == RIGHT) targetX = min(width, targetX + 5);
    if (key == 'w' || keyCode == UP)    targetY = max(0, targetY - 5);
    if (key == 's' || keyCode == DOWN)  targetY = min(height/2, targetY + 5);
    if (key == 'n') targetSize = max(20, targetSize - 5);
    if (key == 'm') targetSize = min(200, targetSize + 5);
  }
  else if (screen == 2) {
    game.keyPressed();
  }
}

void drawModeSelect() {
  background(100, 150, 200);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(36);
  text("Archery Simulator", width/2, height/4);
  float bx = width/2-100, bw=200, bh=50;
  float by1 = height/2-40, by2 = height/2+20;
  fill(230);
  rect(bx, by1, bw, bh, 10);
  rect(bx, by2, bw, bh, 10);
  fill(0);
  textSize(20);
  text("Single Player", width/2, by1 + bh/2);
  text("Two Players",  width/2, by2 + bh/2);
}

void drawSettings() {
  background(240);

  drawBackground();
  Target preview = new Target(targetX, targetY, targetSize);
  preview.display();

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(18);
  text("Move target: WASD or arrows", 20, height - 140);
  text("Resize (N/M): " + nf(targetSize,0,0), 20, height - 110);
  // Confirm button
  fill(200);
  rect(width/2-50, height-90, 100, 40, 5);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Confirm", width/2, height-70);
}
