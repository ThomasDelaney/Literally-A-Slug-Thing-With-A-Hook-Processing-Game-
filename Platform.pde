class Platform extends GameObject
{
  color c;
  
  Platform (float x, float y, float w, float h, color c)
  {
    this.w_ = w;
    this.h_ = h;
    this.c = c;
    
    PolygonShape sd = new PolygonShape();
  
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);

    sd.setAsBox(box2dW, box2dH);

    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.angle = 0;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    body = box2d.createBody(bd);
    
    body.createFixture(sd,1);
    
    body.setUserData(this);
    pos = box2d.getBodyPixelCoord(body);
  }
  
  void setPos()
  {
    pos = box2d.getBodyPixelCoord(body);
  }
  
  void update()
  {
    pos = box2d.getBodyPixelCoord(body);
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    pushMatrix();
    translate(pos.x, pos.y);
    rectMode(CENTER);
    noStroke();
    fill(c);
    rect(0, 0, w_, h_);
    popMatrix();
  }
}