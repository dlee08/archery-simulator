void drawBackground() {
  background(135, 206, 235);
  noStroke();
  fill(255, 223, 0);
  ellipse(500, 100, 80, 80);
  fill(34, 139, 34);
  rect(0, height - 50, width, 50);
  for (int i = 0; i < 7; i++) {
    float tx = i * 90 + 45;
    drawTree(tx, height - 50);
  }
}

void drawTree(float x, float y) {
  fill(139, 69, 19);
  rect(x - 10, y - 60, 20, 60);
  fill(34, 139, 34);
  ellipse(x, y - 80, 50, 50);
  ellipse(x - 20, y - 100, 40, 40);
  ellipse(x + 20, y - 100, 40, 40);
  ellipse(x - 35, y - 80, 30, 30);
  ellipse(x + 35, y - 80, 30, 30);
  ellipse(x, y - 110, 30, 30);
}
