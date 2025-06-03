final int TOTAL_ROUNDS = 5;
Player player1, player2;
int currentPlayerIndex;
int currentRound;
boolean inSuddenDeath = false;
boolean shotInProgress = false;

Target target;
Arrow currentArrow;
Environment environment;
Scoreboard scoreboard;

int canvasWidth, canvasHeight;

GameManager(int w, int h) {
  canvasWidth = w;
  canvasHeight = h;
  environment = new Environment();
  target = new Target(new PVector(w - 150, h/2), 80, 6, environment);
  scoreboard = new Scoreboard(20, 20);
}

void startSinglePlayer() {
  player1 = new HumanPlayer("You", new PVector(100, canvasHeight - 100), environment);
  player2 = new ComputerPlayer("CPU", new PVector(100, canvasHeight - 100), environment, target);
  resetMatch();
}

void startTwoPlayer() {
  player1 = new HumanPlayer("Player 1", new PVector(100, canvasHeight - 150), environment);
  player2 = new HumanPlayer("Player 2", new PVector(100, 100), environment);
  resetMatch();
}

void resetMatch() {
  currentPlayerIndex = 0;
  currentRound = 1;
  inSuddenDeath = false;
  shotInProgress = false;
  scoreboard.reset();
}

void update() {
  target.update();
  if (shotInProgress && currentArrow != null) {
    currentArrow.update();
    if (currentArrow.hasLanded()) {
      int points = target.checkHit(currentArrow);
      getCurrentPlayer().addScore(points);
      scoreboard.updateScore(getCurrentPlayer().getName(), points);
      shotInProgress = false;
      currentArrow = null;
      advanceTurn();
    }
  } else {
    Player p = getCurrentPlayer();
    if (p instanceof ComputerPlayer && !shotInProgress) {
      currentArrow = p.takeTurn();
      shotInProgress = true;
    }
  }
}

void display() {
  target.display();
  if (currentArrow != null) {
    currentArrow.display();
  }
  player1.display();
  player2.display();
  scoreboard.display();
  if (!shotInProgress && getCurrentPlayer() instanceof HumanPlayer) {
    ((HumanPlayer)getCurrentPlayer()).displayAim();
  }
  fill(0);
  textSize(16);
  if (!inSuddenDeath) {
    text("Round " + currentRound + " / " + TOTAL_ROUNDS, canvasWidth/2, 20);
  } else {
    text("Sudden Death!", canvasWidth/2, 20);
  }
}

void mousePressed() {
  if (!shotInProgress && getCurrentPlayer() instanceof HumanPlayer) {
    ((HumanPlayer)getCurrentPlayer()).startAiming(mouseX, mouseY);
  }
}

void mouseDragged() {
  if (!shotInProgress && getCurrentPlayer() instanceof HumanPlayer) {
    ((HumanPlayer)getCurrentPlayer()).updateAiming(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (!shotInProgress && getCurrentPlayer() instanceof HumanPlayer) {
    currentArrow = ((HumanPlayer)getCurrentPlayer()).releaseArrow();
    if (currentArrow != null) {
      shotInProgress = true;
    }
  }
}

Player getCurrentPlayer() {
  return (currentPlayerIndex == 0) ? player1 : player2;
}

void advanceTurn() {
  if (!inSuddenDeath) {
    if (currentPlayerIndex == 1) {
      if (currentRound >= TOTAL_ROUNDS) {
        if (player1.getScore() == player2.getScore()) {
          inSuddenDeath = true;
        } else {
          endMatch();
          return;
        }
      } else {
        currentRound++;
      }
    }
    currentPlayerIndex = (currentPlayerIndex + 1) % 2;
  } else {
    if (currentPlayerIndex == 1) {
      int p1RoundScore = scoreboard.getLastRoundScore(player1.getName());
      int p2RoundScore = scoreboard.getLastRoundScore(player2.getName());
      if (p1RoundScore != p2RoundScore) {
        endMatch();
        return;
      }
    }
    currentPlayerIndex = (currentPlayerIndex + 1) % 2;
  }
}

void endMatch() {
  String winner;
  if (player1.getScore() > player2.getScore()) {
    winner = player1.getName();
  } else if (player2.getScore() > player1.getScore()) {
    winner = player2.getName();
  } else {
    winner = "No one—tie!";
  }
  showWinnerDialog(winner);
  noLoop();
}

void showWinnerDialog(String w) {
  while (true) {
    background(150);
    fill(0);
    textSize(32);
    text("Winner: " + w, width/2, height/2);
    textSize(18);
    text("Press any key to exit", width/2, height/2 + 50);
    if (keyPressed || mousePressed) {
      break;
    }
    delay(20);
  }
  exit();
}
