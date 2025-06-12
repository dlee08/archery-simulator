// GameManager.pde
class GameManager {
  Arrow arrow;
  Arrow stuckArrow;
  Target target;
  int player1Score = 0, player2Score = 0;
  int currentPlayer = 1;
  boolean shotInProgress = false;
  boolean twoPlayerMode;
  float stuckOffX, stuckOffY;

  boolean holding = false;
  int holdStart;
  final int MAX_HOLD = 5000;
  float power = 0;

  GameManager(boolean twoPlayerMode) {
    this.twoPlayerMode = twoPlayerMode;
    target     = new Target(width/2, height/4);
    arrow      = new Arrow(width/2, height - 50);
    stuckArrow = null;
  }

  void update() {
    target.move();
    target.display();

    if (stuckArrow != null) {
      stuckArrow.x = target.x + stuckOffX;
      stuckArrow.y = target.y + stuckOffY;
      stuckArrow.computeHead();
      stuckArrow.display();
    }

    if (mousePressed && !holding && !shotInProgress && stuckArrow == null
        && !arrow.flying && !arrow.stuck) {
      holding   = true;
      holdStart = millis();
    }

    if (holding) {
      float elapsed = millis() - holdStart;
      power = min(1, elapsed / (float)MAX_HOLD);
      arrow.x = mouseX;
      arrow.display();

      float bw = 50, bh = 5;
      stroke(0); noFill();
      rect(arrow.x+10, arrow.y-20, bw, bh);
      noStroke(); fill(0,255,0);
      rect(arrow.x+10, arrow.y-20, bw*power, bh);

      if (!mousePressed || elapsed >= MAX_HOLD) {
        arrow.fire(power);
        shotInProgress = true;
        holding        = false;
      }
      displayScoreboard();
      return;
    }

    if (!shotInProgress && !arrow.flying && !arrow.stuck) {
      arrow.x = mouseX;
    }

    if (arrow.flying) {
      shotInProgress = true;
      arrow.update();
      arrow.display();
    }
    else if (arrow.stuck) {
      arrow.display();
      float hx = arrow.getHeadX(), hy = arrow.getHeadY();
      int pts = target.scoreShot(hx, hy);
      if (pts > 0) {
        if (currentPlayer==1) player1Score+=pts;
        else                  player2Score+=pts;
        stuckOffX = arrow.x - target.x;
        stuckOffY = arrow.y - target.y;
        stuckArrow = arrow;
        arrow = new Arrow(width/2, height-50);
        shotInProgress = false;
        togglePlayer();
      } else {
        arrow.reset(width/2, height-50);
        shotInProgress = false;
        togglePlayer();
      }
    }
    else {
      arrow.display();
    }

    displayScoreboard();
  }

  void display() {}

  void mousePressed() {
    if (stuckArrow != null) stuckArrow = null;
  }

  void keyPressed() {
    if (key=='r'||key=='R') { resetGame(); return; }
    if (arrow.stuck&&(key=='r'||key=='R')) {
      arrow.reset(width/2, height-50);
      shotInProgress = false;
    }
    target.handleKey(keyCode, key);
  }

  void togglePlayer() {
    currentPlayer = (currentPlayer==1)?2:1;
  }

  void displayScoreboard() {
    fill(0); textAlign(CENTER,TOP); textSize(16);
    text("P1: "+player1Score+"   P2: "+player2Score, width/2,10);
    textSize(14);
    text((currentPlayer==1?"Player 1’s turn":"Player 2’s turn"),
         width/2,30);
  }

  void resetGame() {
    player1Score=player2Score=0;
    currentPlayer=1;
    arrow.reset(width/2, height-50);
    stuckArrow=null;
    shotInProgress=holding=false;
    target=new Target(width/2, height/4);
  }
}
