class Player extends GameObject
{
  Vec2 force;
  Hook h;
  float theta;
  
  int speedTime = 5;
  float stimer = 0;
  int displayTimeS = 5;
  
  int invTime = 5;
  float itimer = 0;
  int displayTimeI = 5;
  
  int health = 5;
  char left, right, hook;
  float radius;
  float power = 10000;
  float mass = 1;
  
  color c;
  color prev;
  
  boolean reset = false;
  boolean returned = true;
  boolean speed = false;
  boolean inv = false;
  
  
  Player(float x, float y, float theta, float w_, float h_, char left, char right, char hook, color c, float size, int health)
  {
    
    forward = new Vec2(0, -1);
    force = new Vec2(0, 0);
     
    this.theta = theta;
    this.w_ = w_;
    this.h_ = h_;
    
    this.left = left;
    this.right = right;
    this.hook = hook;
    this.c = c;
    this.prev = c;
    this.health = health;
    
    this.size = size;
    
    makeBody(new Vec2(x, y), w_, h_);
    
    h = new Hook(x, y, size-0.3);
    h.setPlayer(this);
  }
  
  void update()
  { 
    applyForce();
    pos = box2d.getBodyPixelCoord(body);
    theta = body.getAngle();
    
    if (stimer > speedTime)
    {
      speed = false;
      stimer = 0;
      displayTimeS = speedTime;
    }
    
    if (itimer > invTime)
    {
      inv = false;
      itimer = 0;
      displayTimeI = invTime;
    }
    
    if (inv)
    {
      displayTimeI = invTime - (int)itimer%60;
      
      if (activePowers.size() != 0)
      {
        if (activePowers.get(0) instanceof Invincible)
        {
          fill(178, 110, 0);
          textFont(font);
          textSize(30);
              
          text("Invincible: "+displayTimeI, 625, 30);
        }
        else if (activePowers.get(1) instanceof Invincible)
        {
          fill(178, 110, 0);
          textFont(font);
          textSize(30);
              
          text("Invincible: "+displayTimeI, 825, 30);
        }
      }
      itimer += timeDelta;
    }
    
    if (speed)
    {
      displayTimeS = speedTime - (int)stimer%60;
      
      if (activePowers.size() != 0)
      {
        if (activePowers.get(0) instanceof Speed)
        {
          fill(0, 76, 255);
          textFont(font);
          textSize(30);
              
          text("Speed: "+displayTimeS, 625, 30);
        }
        else if (activePowers.get(1) instanceof Speed)
        {
          fill(0, 76, 255);
          textFont(font);
          textSize(30);
              
          text("Speed: "+displayTimeS, 900, 30);
        }
      }
      stimer += timeDelta;
    }
    
    if (checkKey(left) && h.notMoving)
    {
      Vec2 vel = body.getLinearVelocity();
      
      if (speed)
      {
        if (stimer < speedTime)
        {
          vel.x = -30;
        }
      }
      else
      {
        vel.x = -15;
      }
      
      body.setLinearVelocity(vel);
      dir = 2;
    }
    else if (checkKey(right) && h.notMoving)
    {
      Vec2 vel = body.getLinearVelocity();
      
      if (speed)
      {
        if (stimer < speedTime)
        {
          vel.x = 30;
        }
      }
      else
      {
        vel.x = 15;
      }
      
      body.setLinearVelocity(vel);
      dir = 1;
    }
    
    if (checkKey(hook))
    {    
      if (!h.hooking && overPlat && !h.hookCooling && !h.hookConnect)
      {
        h.hooking = true;
    
        h.pos.x = pos.x;
        h.pos.y = pos.y;
      }
    }
    
    if (checkKey(' ') && returned && !h.hookConnect)
    {
      Vec2 vel = body.getLinearVelocity();
      vel.y = 25;
      body.setLinearVelocity(vel);
      returned = false;
    }
  
    if (h.hooking)
    {
      h.update();
    }
    
    if (!h.hooking)
    {
      if (h.hookCooling)
      {
        h.hookTime += timeDelta;
      
        if (h.hookTime > 2)
        {
          h.hookCooling = false;
          h.hookTime = 0;
          h.scale = 1;
        }
      }
    }
    
    if (pos.x+25 >= width || pos.x-25 <= 0)
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
    
    if (health < 1)
    {
      gameState = 2;
    }
  }  
  
  void render()
  { 
    pos = box2d.getBodyPixelCoord(body);
    
    if (inv && speed)
    {
      c = color(255, 102, 102);
    }
    else if (speed)
    {
      c = color(0, 255, 255);
    }
    else if (inv)
    {
      c = color(220, 220, 220);
    }
    else
    {
      c = prev;
    }
    
    if (dir == 1)
    {
      pushMatrix();
      
      translate(pos.x-32, pos.y+22);
      scale(size);
      
      beginShape();
      noStroke();
      fill(c);
      vertex(0,0);
      vertex(44, -32);
      vertex(50, 0);
      endShape();
         
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(c);
      bezier(0, 0, -0.45, -6.83, 5.7, -9.58, 9.03, -6.76);
      bezier(9.03, -6.76, 8.8, -12.9, 12.7, -14.86, 18.3, -13.03);
      bezier(18.3, -13.03, 18.34, -18.53, 22.5, -21.63, 28.86, -18.9); 
      bezier(28.86, -18.9, 28.84, -29.3, 36.9, -32.25, 43.32, -32.3); 
      bezier(43.32, -32.3, 55.44, -29.13, 61.4, -15.2, 50, 0);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      vertex(0, 0);
      vertex(50, 0);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(237, 71, 109);
      vertex(29, -25);
      vertex(19, -40);
      vertex(34, -30);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(237, 71, 109);
      vertex(34, -30);
      vertex(33, -48);
      vertex(40, -33);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(237, 71, 109);
      vertex(40, -33);
      vertex(45, -50);
      vertex(49, -30);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(237, 71, 109);
      vertex(49, -30);
      vertex(58, -48);
      vertex(54, -26);
      endShape();
      
      beginShape();
      fill(0);
      ellipse(46, -23, 2.5, 2.5);
      
      noFill();
      bezier(40, -25, 40.99, -27.73, 42.77, -29.33, 47.49, -28.58);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(255);
      vertex(56, -18);
      vertex(42, -17);
      vertex(56, -12);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(237, 71, 109);
      vertex(47, -7);
      vertex(59, -11);
      vertex(60, -5);
      vertex(48, -3);
      endShape();
      
      popMatrix();
    }
    else if (dir == 2)
    {
      pushMatrix();
      
      translate(pos.x+32, pos.y+22);
      scale(size);
      
      beginShape();
      noStroke();
      fill(c);
      vertex(0,0);
      vertex(-44, -32);
      vertex(-50, 0);
      endShape();
         
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(c);
      bezier(0, 0, -0.45, -6.83, -5.7, -9.58, -9.03, -6.76);
      bezier(-9.03, -6.76, -8.8, -12.9, -12.7, -14.86, -18.3, -13.03);
      bezier(-18.3, -13.03, -18.34, -18.53, -22.5, -21.63, -28.86, -18.9); 
      bezier(-28.86, -18.9, -28.84, -29.3, -36.9, -32.25, -43.32, -32.3); 
      bezier(-43.32, -32.3, -55.44, -29.13, -61.4, -15.2, -50, 0);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      vertex(0, 0);
      vertex(-50, 0);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(237, 71, 109);
      vertex(-29, -25);
      vertex(-19, -40);
      vertex(-34, -30);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(237, 71, 109);
      vertex(-34, -30);
      vertex(-33, -48);
      vertex(-40, -33);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(237, 71, 109);
      vertex(-40, -33);
      vertex(-45, -50);
      vertex(-49, -30);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(237, 71, 109);
      vertex(-49, -30);
      vertex(-58, -48);
      vertex(-54, -26);
      endShape();
      
      beginShape();
      fill(0);
      ellipse(-46, -23, -2.5, 2.5);
      
      noFill();
      bezier(-40, -25, -40.99, -27.73, -42.77, -29.33, -47.49, -28.58);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(255);
      vertex(-56, -18);
      vertex(-42, -17);
      vertex(-56, -12);
      endShape();
      
      beginShape();
      strokeWeight(1);
      strokeCap(ROUND);
      stroke(0);
      fill(237, 71, 109);
      vertex(-47, -7);
      vertex(-59, -11);
      vertex(-60, -5);
      vertex(-48, -3);
      endShape();
      
      popMatrix();
    }
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
  
  void applyForce()
  {
      Vec2 pos2 = body.getWorldCenter();
      force.x = 0;
      force.y = -400;
      body.applyForce(force, pos2);
  }
}