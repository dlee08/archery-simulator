class GameManager {
  Arrow arrow;
  Arrow stuckArrow;
  Target target;
  int player1Score = 0;
  int player2Score = 0;
  int currentPlayer = 1;
  boolean shotInProgress = false;
  boolean twoPlayerMode;
  float stuckOffsetX, stuckOffsetY;

  GameManager(boolean twoPlayerMode) {
    this.twoPlayerMode = twoPlayerMode;
    target = new Target(width/2, height/4);
    arrow  = new Arrow(width/2, height - 50);
    stuckArrow = null;
  }

  void update() {
    target.move();
    target.display();

    if (stuckArrow != null) {
      stuckArrow.x = target.x + stuckOffsetX;
      stuckArrow.y = target.y + stuckOffsetY;
      stuckArrow.computeHead();
      stuckArrow.display();
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
      float hx = arrow.getHeadX();
      float hy = arrow.getHeadY();
      int pts = target.scoreShot(hx, hy);

      if (pts > 0) {
        if (currentPlayer == 1) player1Score += pts;
        else                  player2Score += pts;

        stuckOffsetX = arrow.x - target.x;
        stuckOffsetY = arrow.y - target.y;
        stuckArrow = arrow;

        arrow = new Arrow(width/2, height - 50);
        shotInProgress = false;
        togglePlayer();
      } 
      else {
        arrow.reset(width/2, height - 50);
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
    if (stuckArrow != null) {
      stuckArrow = null;
    }
    if (!shotInProgress && !arrow.flying && !arrow.stuck) {
      arrow.fire();
      shotInProgress = true;
    }
  }

  void keyPressed() {
    if (key == 'r' || key == 'R') {
      resetGame();
      return;
    }
    if (arrow.stuck && (key == 'r' || key == 'R')) {
      arrow.reset(width/2, height - 50);
      shotInProgress = false;
      return;
    }
    target.handleKey(keyCode, key);
  }

  void togglePlayer() {
    currentPlayer = (currentPlayer == 1) ? 2 : 1;
  }

  void displayScoreboard() {
    fill(0);
    textAlign(CENTER, TOP);
    textSize(16);
    text("P1: " + player1Score + "   P2: " + player2Score,
         width/2, 10);
    textSize(14);
    text((currentPlayer == 1 ? "Player 1’s turn"
                             : "Player 2’s turn"),
         width/2, 30);
  }

  void resetGame() {
    player1Score = 0;
    player2Score = 0;
    currentPlayer = 1;
    arrow.reset(width/2, height - 50);
    stuckArrow = null;
    shotInProgress = false;
    target = new Target(width/2, height/4);
  }
}
