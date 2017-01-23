class Shooter extends GameObject implements Enemy
{
  float theta1 = PI;
  float lastAngle1 = 0;
  float theta2 = 2*PI;
  
  float sX;
  float sY;
  
  ArrayList bullets = new ArrayList<Bullet>();
  
  Shooter (float x, float y, float w_, float h_)
  {
    this.w_ = w_;
    this.h_ = h_;
    makeBody(new Vec2(x, y), w_, h_);
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    if (dir == 1)
    {
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
      
      strokeWeight(2);
      stroke(255, 0 , 0);
      arc(-20, 26, 10, 10, lastAngle1+theta1, lastAngle1+theta2);
      arc(-7, 26, 10, 10, lastAngle1+theta1, lastAngle1+theta2);
      arc(6.75, 26, 10, 10, lastAngle1+theta1, lastAngle1+theta2);
      arc(20.5, 26, 10, 10, lastAngle1+theta1, lastAngle1+theta2);
      
      strokeWeight(2);
      stroke(0, 242, 255);
      arc(-20, 26, 10, 10, lastAngle1, lastAngle1+theta1);
      arc(-7, 26, 10, 10, lastAngle1, lastAngle1+theta1);
      arc(6.75, 26, 10, 10, lastAngle1, lastAngle1+theta1);
      arc(20.5, 26, 10, 10, lastAngle1, lastAngle1+theta1);
      
      endShape();
      
      popMatrix();
    }
    else if (dir == 2)
    {
      pushMatrix(); 
      
      translate(pos.x-16.75, pos.y-5.75);
      scale(1);
      
      beginShape();
      stroke(255, 0, 0);
      fill(0);
      rectMode(CENTER);
      
      rect(0, 0, 50, 40);
      rect(37.5, 0, 25, 20);
      rect(55, 0, 10, 10);
      
      noStroke();
      ellipse(20, 26, 10, 10);
      ellipse(7, 26, 10, 10);
      ellipse(-6.75, 26, 10, 10);
      ellipse(-20.5, 26, 10, 10);
      
      strokeWeight(2);
      stroke(255, 0 , 0);
      arc(20, 26, 10, 10, lastAngle1+theta1, lastAngle1+theta2);
      arc(7, 26, 10, 10, lastAngle1+theta1, lastAngle1+theta2);
      arc(-6.75, 26, 10, 10, lastAngle1+theta1, lastAngle1+theta2);
      arc(-20.5, 26, 10, 10, lastAngle1+theta1, lastAngle1+theta2);
      
      strokeWeight(2);
      stroke(0, 242, 255);
      arc(20, 26, 10, 10, lastAngle1, lastAngle1+theta1);
      arc(7, 26, 10, 10, lastAngle1, lastAngle1+theta1);
      arc(-6.75, 26, 10, 10, lastAngle1, lastAngle1+theta1);
      arc(-20.5, 26, 10, 10, lastAngle1, lastAngle1+theta1);
      
      endShape();
      
      popMatrix();
    }
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
    
    Vec2 vel =  body.getLinearVelocity();
    
    if (vel.x > 0)
    {
      lastAngle1+=theta1/50;
      dir = 2;
    }
    else if (vel.x < 0)
    {
      lastAngle1-=theta1/50;
      dir = 1;
    }
    
    if (PTouchSh == true)
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