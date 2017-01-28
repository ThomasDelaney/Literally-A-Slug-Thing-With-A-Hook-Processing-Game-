class Health extends GameObject implements PowerUp
{
  Health(float x, float y, float w_, float h_)
  {
    super(x, y, w_, h_);
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    pushMatrix();
    translate(pos.x, pos.y);
    
    beginShape();
    stroke(0, 255, 89);
    strokeWeight(2);
    fill(255);
    
    rect(0, 0, 30, 30);
    
    strokeWeight(3);
    fill(0, 255, 89);
    
    rect(5, 14, 20, 2.5);
    rect(14, 5, 2.5, 20);
    endShape();
    
    popMatrix(); 
  }
  
  void update()
  {
    pos = box2d.getBodyPixelCoord(body);
  }
  
  void spawn()
  {
  }
  
  void die()
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
    
    fd.filter.groupIndex = -2;

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