class Spiker extends GameObject implements Enemy
{
  Spiker (float x, float y, float w_, float h_)
  {
    this.w_ = w_;
    this.h_ = h_;
    makeBody(new Vec2(x, y), w_, h_);
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    fill(0);
  
    pushMatrix();
    translate(pos.x, pos.y+22);
    
    arc(0, 0, 50, 50, PI, 2*PI, PIE);
    
    beginShape();
    vertex(-24, -6);
    vertex(-29, -18);
    vertex(-19, -14);
    endShape();
    
    beginShape();
    vertex(-21, -13);
    vertex(-21, -29);
    vertex(-13, -20);
    endShape();
    
    beginShape();
    vertex(-13, -20);
    vertex(-11, -37);
    vertex(-4, -24);
    endShape();
    
    beginShape();
    vertex(-4, -24);
    vertex(0, -41);
    vertex(5, -23);
    endShape();
    
    beginShape();
    vertex(24, -6);
    vertex(29, -18);
    vertex(19, -14);
    endShape();
    
    beginShape();
    vertex(21, -13);
    vertex(21, -29);
    vertex(13, -20);
    endShape();
    
    beginShape();
    vertex(13, -20);
    vertex(11, -37);
    vertex(4, -24);
    endShape();
    
    popMatrix();
  }
  
  void update()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    if (pos.x+50 >= width || pos.x-50 <= 0)
    {
      Vec2 stop = body.getLinearVelocity();
      
      if (pos.x+20 >= width)
      {
        stop.x = -10;
      }
      else if (pos.x-25 <= 0)
      {
        stop.x = 10;
      }
      body.setLinearVelocity(stop);
    }
  }
  
  void attack()
  {
    
  }
  
  void die()
  {
    
  }
  
  void calDest()
  {
    
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