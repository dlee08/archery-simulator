class GameManager {
  Arrow arrow, stuckArrow;
  Target target;
  int player1Score = 0, player2Score = 0;
  int currentPlayer = 1;
  boolean shotInProgress = false, twoPlayerMode;
  float stuckOffX, stuckOffY;
  boolean holding = false;
  int holdStart;
  final int MAX_HOLD = 5000;
  float power = 0;
  String message = "";
  int messageTimer = 0, lastSwitchTime = 0;
  final int MESSAGE_DURATION = 120, COMP_DELAY = 3000;
  boolean ignoreRelease = true;

  // new wind field
  float windValue;

  GameManager(boolean twoPlayerMode, float tx, float ty, float tSize) {
    this.twoPlayerMode = twoPlayerMode;
    target   = new Target(tx, ty, tSize);
    arrow    = new Arrow(width/2, height - 50);
    stuckArrow = null;
    lastSwitchTime = millis();
    ignoreRelease = true;
    pickNewWind();
  }

  // call at start of turn
  void pickNewWind() {
    windValue = random(-2, 2);
  }

  boolean isGameOver() {
    return player1Score >= 25 || player2Score >= 25;
  }

  String getWinner() {
    if (player1Score >= 25) return twoPlayerMode ? "Player 1" : "Computer";
    else                     return "Player 2";
  }

  void computerShoot() {
    messageTimer = 0;
    float r = randomGaussian() * target.baseRadius * 0.2;
    r = constrain(r, -target.baseRadius*0.8, target.baseRadius*0.8);
    arrow.x = target.x + r;
    float cpuPower = constrain(randomGaussian()*0.1 + 0.7, 0.4, 1);
    arrow.fire(cpuPower, windValue);
    shotInProgress = true;
  }

  void update() {
    if (ignoreRelease && !mousePressed) ignoreRelease = false;

    target.display();

    if (!shotInProgress && !arrow.flying && !arrow.stuck) {
      fill(0);
      textAlign(CENTER, TOP);
      textSize(16);
      String dir = windValue > 0 ? "→" : windValue < 0 ? "←" : "—";
      text("Wind: " + dir + " " + nf(abs(windValue),1,2), 3*width/4, 100);
    }

    // computer turn
    if (!twoPlayerMode && currentPlayer==1
        && millis()-lastSwitchTime >= COMP_DELAY
        && !shotInProgress && !arrow.flying && !arrow.stuck) {
      computerShoot();
    }

    if (stuckArrow != null) {
      stuckArrow.x = target.x + stuckOffX;
      stuckArrow.y = target.y + stuckOffY;
      stuckArrow.computeHead();
      stuckArrow.display();
    }

    // player CLICK+HOLD
    if (mousePressed && !holding && !shotInProgress && stuckArrow==null
        && !arrow.flying && !arrow.stuck
        && (twoPlayerMode||currentPlayer==2)
        && !ignoreRelease) {
      holding = true;
      holdStart = millis();
    }

    if (holding) {
      float elapsed = millis() - holdStart;
      power = min(1, elapsed/(float)MAX_HOLD);
      arrow.x = mouseX;
      arrow.display();
      stroke(0); noFill();
      rect(arrow.x+10, arrow.y-20, 50, 5);
      noStroke(); fill(0,255,0);
      rect(arrow.x+10, arrow.y-20, 50*power, 5);
      if (!mousePressed || elapsed>=MAX_HOLD) {
        messageTimer = 0;
        arrow.fire(power, windValue);
        shotInProgress = true;
        holding = false;
      }
      displayScoreboard();
      displayMessage();
      return;
    }

    if (!shotInProgress && !arrow.flying && !arrow.stuck
        && (twoPlayerMode||currentPlayer==2)) {
      arrow.x = mouseX;
    }

    if (arrow.flying) {
      shotInProgress = true;
      arrow.update();
      arrow.display();
    } 
    else if (arrow.stuck) {
      arrow.display();
      float hx=arrow.getHeadX(), hy=arrow.getHeadY();
      int pts = target.scoreShot(hx, hy);
      String who = twoPlayerMode
                   ? "Player "+currentPlayer
                   : (currentPlayer==1?"Computer":"Player");
      if (pts>0) {
        if (currentPlayer==1) player1Score+=pts;
        else                  player2Score+=pts;
        message = who+" scored "+pts+" points!";
        messageTimer = MESSAGE_DURATION;
        stuckOffX = arrow.x - target.x;
        stuckOffY = arrow.y - target.y;
        stuckArrow = arrow;
        arrow = new Arrow(width/2, height-50);
        shotInProgress = false;
        togglePlayer();
      } else {
        message = who+" missed!";
        messageTimer = MESSAGE_DURATION;
        arrow.reset(width/2, height-50);
        shotInProgress = false;
        togglePlayer();
      }
    } 
    else {
      arrow.display();
    }

    displayScoreboard();
    displayMessage();
  }

  // stub so ArcherySimulator.pde's game.display() compiles
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
    if ((key=='r'||key=='R') && !arrow.flying) {
      resetGame();
      return;
    }
  }

  void togglePlayer() {
    currentPlayer = (currentPlayer==1)?2:1;
    lastSwitchTime = millis();
    ignoreRelease = true;
    pickNewWind();
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
    String leftLbl = twoPlayerMode ? "P1: "+player1Score
                                   : "Comp: "+player1Score;
    text(leftLbl,165,50);
    text("P2: "+player2Score,435,50);
    // highlight
    if (currentPlayer==1) fill(255,215,0); else fill(200);
    rect(75,18,180,5,2);
    if (currentPlayer==2) fill(255,215,0); else fill(200);
    rect(345,18,180,5,2);
  }

  void resetGame() {
    player1Score=0; player2Score=0;
    currentPlayer=1;
    arrow.reset(width/2, height-50);
    stuckArrow=null;
    shotInProgress=false;
    holding=false;
    messageTimer=0;
    lastSwitchTime=millis();
    ignoreRelease=true;
    pickNewWind();
  }
}
