class Shooter extends GameObject implements Enemy
{
  float theta = 0;
  
  Shooter (float x, float y, float w_, float h_)
  {
    this.w_ = w_;
    this.h_ = h_;
    makeBody(new Vec2(x, y), w_, h_);
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    pushMatrix(); 
    
    translate(pos.x+16.75, pos.y-5.75);
    scale(1);
    
    beginShape();
    stroke(255, 0, 0);
    fill(0);
    rectMode(CENTER);
    
    rect(0, 0, 50, 40);
    rect(-37.5, 0, 25, 20);
    rect(-55, 0, 10, 10);
    
    noStroke();
    ellipse(-20, 26, 10, 10);
    ellipse(-7, 26, 10, 10);
    ellipse(6.75, 26, 10, 10);
    ellipse(20.5, 26, 10, 10);
    
    stroke(255, 0 , 0);
    arc(-20, 26, 10, 10, PI, 2*PI);
    arc(-7, 26, 10, 10, PI, 2*PI);
    arc(6.75, 26, 10, 10, PI, 2*PI);
    arc(20.5, 26, 10, 10, PI, 2*PI);
    
    stroke(0, 242, 255);
    arc(-20, 26, 10, 10, 0, PI);
    arc(-7, 26, 10, 10, 0, PI);
    arc(6.75, 26, 10, 10, 0, PI);
    arc(20.5, 26, 10, 10, 0, PI);
    
    endShape();
    
    popMatrix();
  }
  
  void update()
  {
    
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