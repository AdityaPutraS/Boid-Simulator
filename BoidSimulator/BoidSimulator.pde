int jumlahBoid = 200;

Boid b[] = new Boid[jumlahBoid];
int cellWidth = 20, cellHeight = 20;
PVector windMap[][];

void setup()
{
  frameRate(30);
  size(800, 800, P2D);
  for (int i = 0; i < jumlahBoid; i++) {
    PVector pos = new PVector(random(-width/2, width/2), random(-height/2, height/2));
    PVector vel = new PVector(1, 1);
    PVector acc = new PVector(0.5, 0.5);
    PVector warna = new PVector(random(255), random(255), random(255));
    b[i] = new Boid(pos, vel, acc, warna, 5, 0.1, random(0.0005, 0.005));
  }
  initWindMap();
}

void initWindMap()
{
  windMap = new PVector[width / cellWidth][];
  for (int x = 0; x < width; x += cellWidth)
  {
    windMap[x / cellWidth] = new PVector[height/cellHeight];
    for (int y = 0; y < height; y += cellHeight)
    {
      windMap[x / cellWidth][y / cellHeight] = new PVector(0, 0);
    }
  }
}

void populWindMap(PVector scale, PVector offset)
{
  for (int x = 0; x < width; x += cellWidth)
  {
    for (int y = 0; y < height; y += cellHeight)
    {
      float xNoise = x / cellWidth * scale.x + offset.x;
      float yNoise = y / cellHeight * scale.y + offset.y;
      windMap[x / cellWidth][y / cellHeight] = PVector.fromAngle(noise(xNoise, yNoise) * TWO_PI * 2 - TWO_PI).setMag(noise(xNoise, yNoise) * 20);
    }
  }
}

void drawWindMap()
{
  for (int x = 0; x < width/cellWidth; x++)
  {
    int xPos = x * cellWidth + cellWidth/2;
    for (int y = 0; y < height/cellHeight; y++)
    {
      int yPos = y * cellHeight + cellHeight/2;
      line(xPos, yPos, xPos + windMap[x][y].x, yPos + windMap[x][y].y);
      ellipse(xPos + windMap[x][y].x, yPos + windMap[x][y].y, 2, 2);
    }
  }
}

PVector applyWind(Boid bo)
{
  int x = int((bo.getPos().x + width/2) / cellWidth) % (width / cellWidth);
  int y = int((bo.getPos().y + height/2) / cellHeight) % (height / cellHeight);
  return windMap[x][y].mult(bo.getMass());
}


void drawBoid()
{
  pushMatrix();
  translate(width/2, height/2);
  for (Boid bo : b)
  {
    bo.update();
    bo.render();
  }
  popMatrix();
}

PVector applyFlocking(Boid bo)
{
  PVector center = new PVector(0, 0);
  int jum = 1;
  for (Boid boi : b)
  {
    if (bo != boi)
    {
      if (bo.getPos().dist(boi.getPos()) < 100) {
        center.add(boi.getPos());
        jum++;
      }
    }
  }

  center.div(jum).sub(bo.getPos()).div(50);

  return center;
}

PVector applyMatchVel(Boid bo)
{
  PVector force = new PVector(0, 0);
  int jum = 1;
  for (Boid boi : b)
  {
    if (bo != boi)
    {
      if (bo.getPos().dist(boi.getPos()) < 50) {
        force.add(boi.getVel()); 
        jum++;
      }
    }
  }
  force.div(jum);
  return force;
}

PVector applyPull(Boid bo)
{
  PVector force = new PVector(0, 0);
  float k = 3.5;
  for (Boid boi : b)
  {
    if (bo != boi)
    {
      force.add(PVector.sub(boi.getPos(), bo.getPos()).div(100).mult(k));
    }
  }
  return force;
}

PVector applyPush(Boid bo)
{
  PVector force = new PVector(0, 0);
  //float G = 1.5;
  for (Boid boi : b)
  {
    if (bo != boi)
    {
      PVector jarak = PVector.sub(bo.getPos(), boi.getPos()).div(100);
      float mass = bo.getMass() * boi.getMass() / max(jarak.magSq(), 0.01);
      jarak.setMag(mass);
      force.add(jarak);
    }
  }
  return force;
}

PVector avoidWall(Boid bo)
{
  PVector curPos = bo.getPos();
  PVector force = new PVector(0, 0);
  float k = 20f;
  if (abs(curPos.x) > 350)
  {
    force.x = -curPos.x / k;
  }

  if (abs(curPos.y) > 350)
  {
    force.y = -curPos.y / k;
  }

  return force;
}

void checkBoidDie()
{
  for (int i = 0; i < jumlahBoid; i++)
  {
    if (b[i].getMass() > 1.5)
    {
      PVector pos = new PVector(random(-width/2, width/2), random(-height/2, height/2));
      PVector vel = new PVector(1, 1);
      PVector acc = new PVector(0.5, 0.5);
      PVector warna = new PVector(random(255), random(255), random(255));
      b[i] = new Boid(pos, vel, acc, warna, 5, 0.1, random(0.0005, 0.005));
    }
  }
}

float t = 0;
float tInc = 0.005;

void draw()
{
  checkBoidDie();
  populWindMap(new PVector(0.03, 0.05), new PVector(t, t));
  t += tInc;
  background(255, 255, 255);

  float f = 1.3, m = 1, kPush = 1;
  for (Boid bo : b) 
  {
    PVector sumForce = new PVector(0, 0);

    PVector flock = applyFlocking(bo).mult(f);
    PVector matchVel = applyMatchVel(bo).setMag(5).mult(m);
    PVector push = applyPush(bo).mult(kPush);
    PVector wall = avoidWall(bo);
    PVector wind = applyWind(bo);

    sumForce.add(flock);
    sumForce.add(matchVel);
    sumForce.add(push);
    sumForce.add(wall);
    sumForce.add(wind);

    bo.applyForce(sumForce);
  }
  stroke(0, 0, 0);
  //drawWindMap();
  drawBoid();
}
