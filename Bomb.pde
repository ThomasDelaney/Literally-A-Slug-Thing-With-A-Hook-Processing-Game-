class Bomb extends GameObject
{
  Bomber b;
  float timeToLive = 10;
  float timer = 0;
  boolean touchingPlat = false;
  
  Bomb (float x, float y, float w_, float h_, Bomber b)
  {
    this.b = b;
    this.w_ = w_;
    this.h_ = h_/2;
    makeBody(new Vec2(x, y), this.w_, this.h_); 
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    pushMatrix();
    translate(pos.x, pos.y+6.25);
    noStroke();
    fill(255, 0, 0);
    arc(0, 0, w_, h_*2, PI, 2*PI, PIE);
    popMatrix();
  }
  
  void update()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    if (this == hitB)
    {
      box2d.destroyBody(body);
      b.bombs.remove(this);
    }
    
    if (pos.x < -w_ || pos.x > width+w_)
    {
      box2d.destroyBody(body);
      b.bombs.remove(this);
    }
    
    if (timer > timeToLive)
    {
      box2d.destroyBody(body);
      b.bombs.remove(this);
    }
    
    if (touchingPlat)
    {
      body.setLinearVelocity(new Vec2(0,0));
    }
    else if (!touchingPlat)
    {
      body.setLinearVelocity(new Vec2(10,-5));
    }
    
    timer += timeDelta;
  }
  
  void makeBody(Vec2 center, float wid, float hei)
  {
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(wid/2);
    float box2dH = box2d.scalarPixelsToWorld(hei/2);
    sd.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;

    fd.density = 1;
    fd.friction = 5;
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