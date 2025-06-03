import java.util.*;

class Scoreboard {
  HashMap<String, Integer> totalScores;
  ArrayList<HashMap<String, Integer>> perRoundScores; 
  int x, y;

  Scoreboard(int px, int py) {
    x = px;
    y = py;
    totalScores = new HashMap<String, Integer>();
    perRoundScores = new ArrayList<HashMap<String, Integer>>();
  }

  void reset() {
    totalScores.clear();
    perRoundScores.clear();
  }

  void updateScore(String playerName, int roundPoints) {
    if (!totalScores.containsKey(playerName)) {
      totalScores.put(playerName, 0);
    }
    totalScores.put(playerName, totalScores.get(playerName) + roundPoints);
    if (perRoundScores.size() == 0) {
      perRoundScores.add(new HashMap<String, Integer>());
    }
    HashMap<String, Integer> currentRoundMap = perRoundScores.get(perRoundScores.size() - 1);
    currentRoundMap.put(playerName, roundPoints);
    if (currentRoundMap.size() >= 2) {
      perRoundScores.add(new HashMap<String, Integer>());
    }
  }

  int getLastRoundScore(String playerName) {
    if (perRoundScores.size() == 0) return 0;
    HashMap<String, Integer> lastMap = perRoundScores.get(perRoundScores.size() - 1);
    if (lastMap.containsKey(playerName)) {
      return lastMap.get(playerName);
    }
    return 0;
  }
  
  void display() {
    fill(0);
    textSize(14);
    int ty = y;
    for (String pname : totalScores.keySet()) {
      text(pname + ": " + totalScores.get(pname), x + 60, ty + 10);
      ty += 20;
    }
  }
}
