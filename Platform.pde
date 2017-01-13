class Platform extends GameObject
{
  color c;
  float w; //width
  float h; //height
  
  Platform (float x, float y, float w, float h, color c)
  {
    this.w = w;
    this.h = h;
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
  }
  
  void update()
  {
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    pushMatrix();
    translate(pos.x, pos.y);
    rectMode(CENTER);
    noStroke();
    fill(c);
    rect(0, 0, w, h);
    popMatrix();
  }
}