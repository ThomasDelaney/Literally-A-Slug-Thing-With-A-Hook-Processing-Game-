class Bullet extends GameObject
{
  Shooter s;
  int dir;
  
  Bullet (float x, float y, float w, float h, Shooter s, int dir)
  {
    this.dir = dir;
    this.s = s;
    this.w_ = w;
    this.h_ = h;
    makeBody(new Vec2(x, y), w_, h_);
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    fill(255, 0, 0);
    
    rect(0, 0, w_, h_);
    
    popMatrix();
  }
  
  void update()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    if (pos.x < -w_ || pos.x > width+w_)
    {
      box2d.destroyBody(body);
      s.bullets.remove(this);
    }
    
    Vec2 vel = body.getLinearVelocity();
    
    if (dir == 1)
    {
      vel.x = -15;
    }
    else
    {
      vel.x = 15;
    }
    
    vel.y = 0;
    body.setLinearVelocity(vel);
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