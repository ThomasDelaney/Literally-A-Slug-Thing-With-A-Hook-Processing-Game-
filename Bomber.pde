class Bomber extends GameObject implements Enemy
{
  ArrayList bombs = new ArrayList<Bomb>();
  float timer = 0;
  
  Bomber (float x, float y, float w_, float h_)
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
      translate(pos.x-50, pos.y+18);
      rotate(0.07);
      scale(0.6);
      
      beginShape();
      noFill();
      stroke(0);
      bezier(0, 0, 23.7, 33, 49.4, -9, 66.8, 8.3);
      bezier(0, 0, 75, 4, 37.7, -52.5, 63.7, -67.8);
      bezier(100.5, -17.3, 126.2, -14.8, 141, -19.6, 151, -44.2);
      bezier(66.8, 8.3, 122.5, 11.3, 149, -1, 151, -44.2);
      bezier(63.7, -67.8, 81.5, -66.4, 91.7, -50.5, 89.2, -17.3);
      bezier(89.2, -17.3, 94.7, -24.8, 94.5, -25.6, 100.5, -17.3);
      endShape();
      
      beginShape();
      fill(255);
      ellipse(77, -49, 7.5, 7.5);
      
      fill(0);
      ellipse(78, -49, 3, 3);
      endShape();
      
      beginShape();
      vertex(87, -46);
      vertex(78, -40);
      vertex(89, -38);
      endShape();
      
      popMatrix();
    }
    else if (dir == 2)
    {
      pushMatrix();
      translate(pos.x+50, pos.y+18);
      rotate(-0.07);
      scale(0.6);
      
      beginShape();
      noFill();
      stroke(0);
      bezier(0, 0, -23.7, 33, -49.4, -9, -66.8, 8.3);
      bezier(0, 0, -75, 4, -37.7, -52.5, -63.7, -67.8);
      bezier(-100.5, -17.3, -126.2, -14.8, -141, -19.6, -151, -44.2);
      bezier(-66.8, 8.3, -122.5, 11.3, -149, -1, -151, -44.2);
      bezier(-63.7, -67.8, -81.5, -66.4, -91.7, -50.5, -89.2, -17.3);
      bezier(-89.2, -17.3, -94.7, -24.8, -94.5, -25.6, -100.5, -17.3);
      endShape();
      
      beginShape();
      fill(255);
      ellipse(-77, -49, 7.5, 7.5);
      
      fill(0);
      ellipse(-78, -49, 3, 3);
      endShape();
      
      beginShape();
      vertex(-87, -46);
      vertex(-78, -40);
      vertex(-89, -38);
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
      dir = 2;
    }
    else if (vel.x < 0)
    {
      dir = 1;
    }
    
    if (PTouchB == true)
    {
      body.setLinearVelocity(new Vec2(0,0));
    }
    
    attack();
  }
  
  void attack()
  {
    for (int i = bombs.size()-1; i >= 0; i--)
    {
      Bomb b = (Bomb)bombs.get(i); 
      b.update();
      b.render();    
    }
    
    timer += timeDelta;
  
    if (timer > 5)
    {
      Bomb b;
      
      if (dir == 2)
      {
        b = new Bomb(pos.x-90, pos.y-10, 25, 25, this);
      }
      else
      {
        b = new Bomb(pos.x+90, pos.y-10, 25, 25, this);
      }
      
      bombs.add(b);
      timer = 0;
    }
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
    
    fd.filter.groupIndex = -3;

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