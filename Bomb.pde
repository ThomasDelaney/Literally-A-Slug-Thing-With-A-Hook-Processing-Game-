class Bomb extends GameObject
{
  Bomb (float x, float y, float w_, float h_)
  {
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