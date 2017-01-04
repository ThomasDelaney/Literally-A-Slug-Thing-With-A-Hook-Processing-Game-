class Player extends GameObject
{
  Body body;
  Vec2 force;
  float theta;
  char left, right, hook;
  float radius;
  float power = 300;
  float mass = 1;
  float hookTime = 0;
  color c;
  boolean reset = false;
  boolean onTemp = false;
  boolean goalSet = false;
  boolean returned = true;
  boolean hooking = false;
  boolean hookCooling = false;
  float ygoal;
  
  Player(float x, float y, float theta, float size, char left, char right, char hook, color c)
  {
    
    forward = new Vec2(0, -1);
    force = new Vec2(0, 0);
     
    this.theta = theta;
    this.size = size;
    
    this.left = left;
    this.right = right;
    this.hook = hook;
    this.c = c;
    
    makeBody(new Vec2(x, y), size, size);
  }
  
  void update()
  { 
    pos = box2d.getBodyPixelCoord(body);
    theta = body.getAngle();
    
    if (checkKey(left))
    {
      Vec2 vel = body.getLinearVelocity();
      vel.x = -10;
      body.setLinearVelocity(vel);
    }
    
    if (checkKey(right))
    {
      Vec2 vel = body.getLinearVelocity();
      vel.x = 10;
      body.setLinearVelocity(vel);
    }
    
    if (checkKey(hook))
    {    
      if (!hooking && overPlat && !hookCooling)
      {
        hooking = true;
      }
    }
    
    if (checkKey(' ') && returned)
    {
      Vec2 vel = body.getLinearVelocity();
      vel.y = 15;
      body.setLinearVelocity(vel);
      returned = false;
    }
    
    if (hooking)
    {
      stroke(255, 0, 0);
      strokeWeight(3);
      fill(255, 0, 0);
     
      line(pos.x, pos.y, platPosX, platPosY);
    
      hookTime += timeDelta;
      
      if (hookTime > 2)
      {
        hookCooling = true;
        hooking = false;
        hookTime = 0;
      }
    }
    else if (!hooking)
    {
      if (hookCooling)
      {
        hookTime += timeDelta;
      
        if (hookTime > 2)
        {
          hookCooling = false;
          hookTime = 0;
        }
      }
    }
  }  
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
  
    noStroke();
    fill(c);
    pushMatrix();
    translate(pos.x, pos.y);
    rectMode(CENTER);
    rect(0, 0, size, size);
    popMatrix();
  }
  
  void makeBody(Vec2 center, float w_, float h_)
  {

    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;

    fd.density = 1;
    fd.friction = 2;
    fd.restitution = 0;

    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.angle = 0;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
    body.setUserData(this);

    body.setLinearVelocity(new Vec2(0,0));
  }
}