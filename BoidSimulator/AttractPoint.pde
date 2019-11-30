class AttractPoint {
  PVector pos;
  float power;
  
  AttractPoint(int x, int y, float power_)
  {
    pos = new PVector(x, y);
    power = power_;
  }
  
  PVector getForce(PVector obj)
  {
    // Return force proportional to distance
    return PVector.sub(pos, obj); 
  }
  
  void render()
  {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(0, 0, 0);
    ellipse(pos.x, pos.y, 20, 20);
    popMatrix();
  }
  
}
