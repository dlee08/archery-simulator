class ComputerPlayer {
  String name;
  int score;
  ArrayList<Arrow> arrows;
  Range firingRange;

  ComputerPlayer(String name, Range firingRange) {
    this.name = name;
    this.score = 0;
    this.arrows = new ArrayList<Arrow>();
    this.firingRange = firingRange;
  }

  Arrow fireArrow(Target target) {
    float angle = randomAngleToTarget(target.position);
    float power = randomPowerInRange();
    Arrow arrow = new Arrow(angle, power);
    arrows.add(arrow);
    return arrow;
  }

  void upgradeArrow(String upgradeType) {
  }

  float randomAngleToTarget(Position targetPos) {
    float angleToTarget = atan2(targetPos.y - height/2, targetPos.x - width/2);
    return angleToTarget + random(-PI/12, PI/12);
  }

  float randomPowerInRange() {
    return random(firingRange.minDistance, firingRange.maxDistance);
  }
}

class Range {
  float minDistance;
  float maxDistance;

  Range(float minD, float maxD) {
    minDistance = minD;
    maxDistance = maxD;
  }
}
