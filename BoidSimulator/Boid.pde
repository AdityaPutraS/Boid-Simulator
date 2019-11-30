class Boid {
  PVector pos, vel, acc;
  float mass;
  float maxSpeed;
  PVector warna;
  PVector temp, temp2;
  ArrayList<PVector> path = new ArrayList<PVector>();
  int maxPathLength = 500;
  float growth;

  Boid(PVector pos_, PVector vel_, PVector acc_, PVector warna_, float maxSp, float m, float grow) {
    pos = pos_.copy();
    vel = vel_.copy();
    acc = acc_.copy();
    maxSpeed = maxSp;
    mass = m;
    growth = grow;
    warna = warna_.copy();
    path.add(pos.copy());
  }

  Boid() {
    pos = new PVector(0, 0);
    vel = new PVector(1, 1);
    acc = new PVector(0.5, 0.5);
    maxSpeed = 5;
    mass = 1;
    growth = 0.01;
    warna = new PVector(0, 0, 0);
    path.add(pos.copy());
  }

  void setGrow(float g)
  {
    growth = g;
  }

  float getGrowth()
  {
    return growth;
  }

  void setMass(float m)
  {
    mass = m;
  }

  float getMass()
  {
    return mass;
  }

  void setWarna(PVector warna_)
  {
    warna = warna_.copy();
  }

  void setVelocity(PVector vel_)
  {
    vel = vel_.copy();
  }

  void setAccel(PVector acc_)
  {
    acc = acc_.copy();
    if (acc.mag() > 5)
    {
      acc.setMag(5);
    }
  }

  void applyForce(PVector force)
  {
    this.setAccel(force.div(mass));
  }

  PVector getPos()
  {
    return pos;
  }

  PVector getVel()
  {
    return vel;
  }

  private void addToPath()
  {
    if (path.size() > maxPathLength) {
      path.remove(0);
    }
    path.add(pos.copy());
  }

  void update() {
    mass += growth;
    constrain(mass, 0.000001, 2);
    pos.add(vel);
    temp = pos.copy();
    pos.x = ((pos.x + 400) % 800) - 400;
    if (pos.x < -400)
    {
      pos.x = 800 - pos.x;
    }

    pos.y = ((pos.y + 400) % 800) - 400;
    if (pos.y < -400)
    {
      pos.y = 800 - pos.y;
    }
    temp2 = pos.copy();
    vel.add(acc);
    vel.setMag(min(vel.mag(), maxSpeed));
    //addToPath();
  }

  private void drawPath()
  {
    for (PVector p : path) 
    {
      point(p.x, p.y);
    }
  }

  void render() {
    stroke(warna.x, warna.y, warna.z);
    pushMatrix();
    //drawPath();
    translate(pos.x, pos.y);
    //line(0,0, vel.x * 100, vel.y * 100);
    rotate(vel.heading() - radians(90));
    fill(warna.x, warna.y, warna.z);
    scale(mass);
    triangle(-5, -5, 5, -5, 0, 10);
    popMatrix();
  }
}
