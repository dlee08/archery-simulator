class GameManager {
  Arrow arrow; 
  Arrow stuckArrow;
  Target target;
  int player1Score = 0;
  int player2Score = 0;
  int currentPlayer = 1;
  int holdStart;
  boolean shotInProgress = false;
  boolean twoPlayerMode;
  boolean isHolding = false;
  float stuckArrowX;
  float stuckArrowY;
  float power = 0;
  String message = "";
  int messageTimer = 0;
  int lastSwitchTime = 0;
  boolean ignoreRelease = true;
  float windValue;
  final int MAX_HOLD = 5000;
  final int MESSAGE_DURATION = 120;
  final int COMP_DELAY = 3000;

  public GameManager(boolean twoPlayerMode, float targetX, float targetY, float tSize) {
    this.twoPlayerMode = twoPlayerMode;
    target = new Target(targetX, targetY, tSize);
    arrow = new Arrow(width/2, height-50);
    stuckArrow = null;
    lastSwitchTime = millis();
    ignoreRelease = true;
    getNewWind();
  }

  void getNewWind() {
    windValue = random(-2, 2);
  }

  boolean isGameOver() {
    return player1Score >= 25 || player2Score >= 25;
  }

  String getWinner() {
    if (player1Score >= 25) return twoPlayerMode ? "Player 1" : "Computer";
    else { return "Player 2"; }
  }

  void computerShoot() {
    messageTimer = 0;
    float r = randomGaussian() * target.baseRadius * 0.2;
    r = constrain(r, -target.baseRadius*0.8, target.baseRadius*0.8);
    arrow.x = target.x + r;
    float computerPower = constrain(randomGaussian()*0.1 + 0.7, 0.4, 1);
    arrow.fire(computerPower, windValue);
    shotInProgress = true;
  }

  void update() {
    if (ignoreRelease && !mousePressed) ignoreRelease = false;
    target.display();
    if (!shotInProgress && !arrow.isFlying && !arrow.isStuck) {
      fill(0);
      textAlign(CENTER, TOP);
      textSize(16);
      String dir = windValue > 0 ? "→" : windValue < 0 ? "←" : "—";
      text("Wind: " + dir + " " + nf(abs(windValue),1,2), 3*width/4, 100);
    }
    if (!twoPlayerMode && currentPlayer==1
        && millis()-lastSwitchTime >= COMP_DELAY
        && !shotInProgress && !arrow.isFlying && !arrow.isStuck) {
      computerShoot();
    }
    if (stuckArrow != null) {
      stuckArrow.x = target.x + stuckArrowX;
      stuckArrow.y = target.y + stuckArrowY;
      stuckArrow.computeHead();
      stuckArrow.display();
    }
    if (mousePressed && !isHolding && !shotInProgress && stuckArrow==null
        && !arrow.isFlying && !arrow.isStuck
        && (twoPlayerMode||currentPlayer==2)
        && !ignoreRelease) {
      isHolding = true;
      holdStart = millis();
    }
    if (isHolding) {
      float elapsed = millis() - holdStart;
      power = min(1, elapsed / (float)MAX_HOLD);
      arrow.x = mouseX;
      arrow.display();
      stroke(0); 
      noFill();
      rect(arrow.x+10, arrow.y-20, 50, 5);
      noStroke(); 
      fill(0,255,0);
      rect(arrow.x+10, arrow.y-20, 50*power, 5);
      if (!mousePressed || elapsed>=MAX_HOLD) {
        messageTimer = 0;
        arrow.fire(power, windValue);
        shotInProgress = true;
        isHolding = false;
      }
      displayScoreboard();
      displayMessage();
      return;
    }
    if (!shotInProgress && !arrow.isFlying && !arrow.isStuck && (twoPlayerMode||currentPlayer==2)) {
      arrow.x = mouseX;
    }
    if (arrow.isFlying) {
      shotInProgress = true;
      arrow.update();
      arrow.display();
    }
    else if (arrow.isStuck) {
      arrow.display();
      float hx=arrow.getHeadX(), hy=arrow.getHeadY();
      int pts = target.scoreShot(hx, hy);
      String who = twoPlayerMode ? "Player "+currentPlayer : (currentPlayer==1?"Computer":"Player");
      if (pts>0) {
        if (currentPlayer==1) player1Score += pts;
        else { player2Score+=pts; }
        message = who+" scored "+pts+" points!";
        messageTimer = MESSAGE_DURATION;
        stuckArrowX = arrow.x - target.x;
        stuckArrowY = arrow.y - target.y;
        stuckArrow = arrow;
        arrow = new Arrow(width/2, height-50);
        shotInProgress = false;
        togglePlayer();
      } 
      else {
        message = who+" missed!";
        messageTimer = MESSAGE_DURATION;
        arrow.reset(width/2, height-50);
        shotInProgress = false;
        togglePlayer();
      }
    }
    else arrow.display();

    displayScoreboard();
    displayMessage();
  }

  // wrapper
  void display() { }

  void displayMessage() {
    if (messageTimer>0) {
      fill(255,0,0);
      textAlign(CENTER,CENTER);
      textSize(20);
      text(message, width/2, height/2);
      messageTimer--;
    }
  }

  void mousePressed() {
    if (stuckArrow!=null) stuckArrow=null;
    messageTimer=0;
  }

  void keyPressed() {
    if ((key=='r'||key=='R') && !arrow.isFlying) {
      resetGame();
      return;
    }
  }

  void togglePlayer() {
    currentPlayer = (currentPlayer==1) ? 2 : 1;
    lastSwitchTime = millis();
    ignoreRelease = true;
    getNewWind();
  }

  void displayScoreboard() {
    fill(139,69,19);
    rect(50,10,500,80,10);
    
    fill(255);
    rect(75,20,180,60,5);
    rect(345,20,180,60,5);
    
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(20);
    String leftLbl = twoPlayerMode ? "Player 1: " + player1Score : "Computer: " + player1Score;
    text(leftLbl,165,50);
    text("Player 2: " + player2Score,435,50);
    
    if (currentPlayer==1) fill(255,215,0);
    else { fill(200); }
    rect(75,18,180,5,2);
    if (currentPlayer==2) fill(255,215,0); 
    else { fill(200); }
    rect(345,18,180,5,2);
  }

 // reset everything when game is over and someone wins
  void resetGame() {
    player1Score=0;
    player2Score=0;
    currentPlayer=1;
    arrow.reset(width/2, height-50);
    stuckArrow=null;
    shotInProgress=false;
    isHolding=false;
    messageTimer=0;
    lastSwitchTime=millis();
    ignoreRelease=true;
    getNewWind();
  }
}
