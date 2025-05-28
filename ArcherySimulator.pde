Arrow arrow;
Target target;
boolean dragging = false;

void setup() {
  size(600, 400);
  arrow = new Arrow(width/2, height - 50);
  target = new Target(width/2, height/4, 80);
}

void draw() {
  background(220);
  
  target.display();
  
  if (dragging) {
    arrow.followMouse(mouseX, mouseY);
  } else {
    arrow.moveForward();
  }
  
  arrow.display();
}

void mousePressed() {
  if (dist(mouseX, mouseY, arrow.x, arrow.y) < 50) {
    dragging = true;
  }
}

void mouseReleased() {
  dragging = false;
}
