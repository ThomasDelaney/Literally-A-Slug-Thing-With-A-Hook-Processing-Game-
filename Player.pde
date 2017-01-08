class Player extends GameObject
{
  Vec2 force;
  Hook h;
  float theta;
  char left, right, hook;
  float radius;
  float power = 300;
  float mass = 1;
  color c;
  boolean reset = false;
  boolean returned = true;

  
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
    
    h = new Hook(x, y);
  }
  
  void update()
  { 
    pos = box2d.getBodyPixelCoord(body);
    theta = body.getAngle();
    
    if (checkKey(left) && h.notMoving)
    {
      Vec2 vel = body.getLinearVelocity();
      vel.x = -10;
      body.setLinearVelocity(vel);
    }
    
    if (checkKey(right) && h.notMoving)
    {
      Vec2 vel = body.getLinearVelocity();
      vel.x = 10;
      body.setLinearVelocity(vel);
    }
    
    if (checkKey(hook))
    {    
      if (!h.hooking && overPlat && !h.hookCooling && !h.hookConnect)
      {
        h.hooking = true;
    
        h.pos.x = pos.x;
        h.pos.y = pos.y;
      }
    }
    
    if (checkKey(' ') && returned && !h.hookConnect)
    {
      Vec2 vel = body.getLinearVelocity();
      vel.y = 15;
      body.setLinearVelocity(vel);
      returned = false;
    }
    
    if (h.hooking)
    {
      h.update(this);
    }
    
    if (!h.hooking)
    {
      if (h.hookCooling)
      {
        h.hookTime += timeDelta;
      
        if (h.hookTime > 2)
        {
          h.hookCooling = false;
          h.hookTime = 0;
          h.scale = 1;
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