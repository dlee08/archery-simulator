class Arrow {
  float x, y;
  float angle = 0;
  float speed = 5;
  float sizeFactor = 1.0;
  
  Arrow(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void followMouse(float mx, float my) {
    angle = atan2(my - y, mx - x);
    x = mx;
    y = my;
    sizeFactor = 1.0;  // reset size while dragging
  }
  
  void moveForward() {
    x += cos(angle) * speed;
    y += sin(angle) * speed;
    sizeFactor *= 0.98; // arrow shrinks gradually
    if (sizeFactor < 0.1) sizeFactor = 0.1;
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    scale(sizeFactor);
    
    noStroke();
    fill(139, 69, 19);
    rect(-30, -3, 60, 6);
    
    fill(255, 0, 0);
    triangle(-30, -3, -40, -7, -40, 3);
    triangle(-30, 0, -40, 6, -40, -6);
    triangle(-30, 3, -40, 7, -40, -3);
    
    fill(192,192,192);
    triangle(30, -6, 30, 6, 45, 0);
    
    popMatrix();
  }
}
