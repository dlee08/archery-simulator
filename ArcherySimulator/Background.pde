void drawBackground() {
  background(135, 206, 235);
  fill(34, 139, 34);
  rect(0, height - 50, width, 50);

  drawTree(100, height - 50);
  drawTree(300, height - 50);
  drawTree(500, height - 50);
  drawTree(700, height - 50);
}

void drawTree(float x, float y) {
  fill(139, 69, 19);
  rect(x - 10, y - 60, 20, 60);

  fill(0, 128, 0);
  ellipse(x, y - 70, 40, 40);
}
