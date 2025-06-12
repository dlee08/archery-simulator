class Arrow {
  float x, y;
  float speedY = 15.0;
  float gravity = 0.2;
  float wind = 0.0;
  boolean isFlying = false;
  boolean isStuck = false;
  float headX;
  float headY;
  float stopY; // only uses y coord for detecting if it should stop, b/c 2d instead of 3d (wouldve been esaier with 3d processing)

  public Arrow(float startX, float startY) {
    x = startX;
    y = startY;
    computeHead();
  }

  void fire(float power, float windValue) {
    isFlying = true;
    isStuck = false;
    speedY = map(power, 0, 1, 5, 20);
    wind = windValue;
    stopY = map(power, 0, 1, height - 50, 0);
    computeHead();
  }

  void fire(float power) { // wrapper funct for top fire method
    fire(power, random(-2, 2));
  }

  void update() {
    if (isFlying && !isStuck) {
      y-=speedY;
      speedY=max(5, speedY - gravity);
      speedY*=0.995;
      x+=wind;
      wind*=0.99;
      computeHead();
      if (y<=stopY) {
        isFlying=false;
        isStuck=true;
      }
    }
  }

  void display() {
    pushMatrix(); // save current screen coords
    translate(x, y);
    float size = map(y, height - 50, 0, 40, 10);
    size = constrain(size, 10, 40);
    noStroke();
    fill(120, 60, 20);
    float shaftWidth = size * 0.15;
    float shaftHeight = size * 1.5;
    rect(-shaftWidth/2, -shaftHeight/2, shaftWidth, shaftHeight);
    fill(255, 0, 0);
    float headWidth = size * 0.5;
    float headHeight = size * 0.6;
    triangle(-headWidth/2, -shaftHeight/2, headWidth/2, -shaftHeight/2,0, -shaftHeight/2 -headHeight);
    fill(255);
    float featherWidth = size * 0.2;
    float featherHeight = size * 0.4;
    float featherSize = featherWidth * 1.2;
    pushMatrix();
      translate(0, shaftHeight/2 - featherHeight/2);
      pushMatrix();
        rotate(radians(-20));
        rect(-featherSize, 0, featherWidth, featherHeight, featherWidth*0.3);
      popMatrix(); // bring back old screen but with new element drawn in it
      rect(-featherWidth/2, 0, featherWidth, featherHeight, featherWidth*0.3);
      pushMatrix();
        rotate(radians(20));
        rect(featherSize - featherWidth, 0, featherWidth, featherHeight, featherWidth*0.3);
      popMatrix();
    popMatrix();
    popMatrix();
  }

  void computeHead() {
    float size=map(y,height-50,0,40,10);
    size=constrain(size,10,40);
    float sh=size*1.5;
    float headHeight=size*0.6;
    headX=x;
    headY=y-(sh/2+ headHeight);
  }

  float getHeadX() {
    return headX;
  }
  float getHeadY() {
    return headY;
  }

  void reset(float startX, float startY) {
    x=startX;
    y=startY;
    speedY=15;
    wind=0;
    isFlying=false;
    isStuck=false;
    computeHead();
  }
}
