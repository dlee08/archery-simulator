class ComputerPlayer extends Player {
  Target tgt;
  
  ComputerPlayer(String n, PVector pos, Environment e, Target t) {
    super(n, pos, e);
    tgt = t;
  }
  
  Arrow takeTurn() {
    PVector direction = PVector.sub(tgt.getCenter(), bowPosition);
    float baseSpeed = 12;
    direction.setMag(baseSpeed);
    float windEffect = abs(env.windSpeed) * 0.5;
    PVector perturb = PVector.random2D().mult(windEffect);
    direction.add(perturb);
    Arrow a = new Arrow(bowPosition.copy(), direction, env);
    return a;
  }
}
