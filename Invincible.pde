class Invincible extends GameObject implements PowerUp
{
  boolean hit = false;
  float timer = 0;
  float timeToLive = 30;
  
  Invincible(float x, float y, float w_, float h_)
  {
    super(x, y, w_, h_);
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
   
    pushMatrix();
  
    translate(pos.x, pos.y);
    stroke(178, 110, 0);
    noFill();
    strokeWeight(2);
    rect(0, 0, w_, h_);
    
    beginShape();
    
    scale(0.13);
    strokeWeight(7);
    ellipse(0, 0, 50, 50);
    
    line(0, -100, 0, 100);
    line(-15, -70, 15, -70);
    line(-15, -60, 15, -60);
    line(-15, -50, 15, -50);
    
    line(-15, 70, 15, 70);
    line(-15, 60, 15, 60);
    line(-15, 50, 15, 50);
    bezier(15, -100, 15, -70, -15, -70, -15, -100);
    bezier(15, 100, 15, 70, -15, 70, -15, 100);
  
    line(-100, 0, 100, 0);
    line(-70, -15, -70, 15);
    line(-60, -15, -60, 15);
    line(-50, -15, -50, 15);
    
    line(70, -15, 70, 15);
    line(60, -15, 60, 15);
    line(50, -15, 50, 15);
    bezier(-100, 15, -70, 15, -70, -15, -100, -15);
    bezier(100, 15, 70, 15, 70, -15, 100, -15);
    
    rotate(QUARTER_PI);
    line(0, -100, 0, 100);
    line(-15, -70, 15, -70);
    line(-15, -60, 15, -60);
    line(-15, -50, 15, -50);
    
    line(-15, 70, 15, 70);
    line(-15, 60, 15, 60);
    line(-15, 50, 15, 50);
    bezier(15, -100, 15, -70, -15, -70, -15, -100);
    bezier(15, 100, 15, 70, -15, 70, -15, 100);
    
    
    line(-100, 0, 100, 0);
    line(-70, -15, -70, 15);
    line(-60, -15, -60, 15);
    line(-50, -15, -50, 15);
    
    line(70, -15, 70, 15);
    line(60, -15, 60, 15);
    line(50, -15, 50, 15);
    bezier(-100, 15, -70, 15, -70, -15, -100, -15);
    bezier(100, 15, 70, 15, 70, -15, 100, -15);
    
    endShape();
    
    popMatrix();
  }
  
  void update()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    if (hit || timer > timeToLive)
    {
      die();
    }
    
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
    
    timer += timeDelta;
  }
  
  void die()
  {
    body.setTransform(new Vec2(width+100, height-100), body.getAngle());
    powerUps.remove(this);
    box2d.destroyBody(body);
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