class Spiker extends GameObject implements Enemy
{
  color c = color(100, 100, 100);;
  float timer = 0;
  
  Spiker (float x, float y, float w_, float h_)
  {
    super(x, y, w_, h_);
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
  
    pushMatrix();
    translate(pos.x, pos.y+23);
    
    noStroke();
    fill(c);
    arc(0, 0, 50, 50, PI, 2*PI, PIE);
    
    fill(255, 0, 0);
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
        
    if (timer > 0.07)
    {
      c = color(random(0, 255), random(0, 255), random(0, 255));
      timer = 0;
    }
    else
    {
      timer+=timeDelta;
    }
        
    if (PTouchSp == true)
    {
      body.setLinearVelocity(new Vec2(0,0));
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

    fd.density = 10;
    fd.friction = 5;
    fd.restitution = 0;
    
    fd.filter.groupIndex = 2;

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