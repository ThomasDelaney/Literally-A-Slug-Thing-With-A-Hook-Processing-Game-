class Player extends GameObject
{
  Body body;
  Vec2 force;
  float theta;
  char left, right, hook;
  float radius;
  float power = 300;
  float mass = 1;
  float hookTime = 0;
  color c;
  boolean reset = false;
  boolean returned = true;
  boolean hooking = false;
  boolean hookCooling = false;
  boolean hookConnect = false;
  boolean notMoving = true;
  float hookX;
  float hookY;
  float tempX;
  float tempY;
  float xR;
  float yR;
  float scale;
  int hookDir;
  
  Player(float x, float y, float theta, float size, char left, char right, char hook, color c)
  {
    
    forward = new Vec2(0, -1);
    force = new Vec2(0, 0);
     
    this.theta = theta;
    this.size = size;
    
    this.left = left;
    this.right = right;
    this.hook = hook;
    this.c = c;
    
    makeBody(new Vec2(x, y), size, size);
  }
  
  void update()
  { 
    pos = box2d.getBodyPixelCoord(body);
    theta = body.getAngle();
    
    if (checkKey(left) && notMoving)
    {
      Vec2 vel = body.getLinearVelocity();
      vel.x = -10;
      body.setLinearVelocity(vel);
    }
    
    if (checkKey(right) && notMoving)
    {
      Vec2 vel = body.getLinearVelocity();
      vel.x = 10;
      body.setLinearVelocity(vel);
    }
    
    if (checkKey(hook))
    {    
      if (!hooking && overPlat && !hookCooling && !hookConnect)
      {
        hooking = true;
        
        hookX = pos.x;
        hookY = pos.y;
        
        scale = 1;
      }
    }
    
    if (checkKey(' ') && returned && !hookConnect)
    {
      Vec2 vel = body.getLinearVelocity();
      vel.y = 15;
      body.setLinearVelocity(vel);
      returned = false;
    }
    
    if (hooking)
    {
      stroke(255, 0, 0);
      strokeWeight(3);
      fill(255, 0, 0);
      
      line(pos.x, pos.y, hookX, hookY);
      
      if (!hookConnect)
      {
        if (hookX < platPosX && hookY < platPosY)
        {
          tempX = platPosX - hookX;
          tempY = platPosY - hookY;
          
          xR = (tempX/platPosX)*scale;
          yR = (tempY/platPosY)*scale;
          
          hookX+=xR;
          hookY+=yR;
          
          hookDir = 1;
        }
        else if (hookX < platPosX && hookY > platPosY)
        {
          tempX = platPosX - hookX;
          tempY = hookY - platPosY;
          
          xR = (tempX/platPosX)*scale;
          yR = (tempY/platPosY)*scale;
          
          hookX+=xR;
          hookY-=yR;
          
          hookDir = 2;
        }
        else if (hookX > platPosX && hookY > platPosY)
        {
          tempX = hookX - platPosX;
          tempY = hookY -  platPosY;
          
          xR = (tempX/platPosX)*scale;
          yR = (tempY/platPosY)*scale;
          
          hookX-=xR;
          hookY-=yR;
          
          hookDir = 3;
        }
        else if (hookX > platPosX && hookY < platPosY)
        {
          tempX = hookX - platPosX;
          tempY = platPosY - hookY;
          
          xR = (tempX/platPosX)*scale;
          yR = (tempY/platPosY)*scale;
          
          hookX-=xR;
          hookY+=yR;
          
          hookDir = 4;
        }
        
        scale += 1.5;
        
        if (hookDir == 1)
        {
          if (hookX+1 >= platPosX && hookY+1 >= platPosY)
          {
            hookConnect = true;
          }
        }
        else if (hookDir == 2)
        {
          if (hookX+1 >= platPosX && hookY <= platPosY+1)
          {
            hookConnect = true;
          }
        }
        else if (hookDir == 3)
        {
          if (hookX <= platPosX+1 && hookY <= platPosY+1)
          {
            hookConnect = true;
          }
        }
        else if (hookDir == 4)
        {
          if (hookX <= platPosX+1 && hookY+1 >= platPosY)
          {
            hookConnect = true;
          }
        }
      }
       
      if (hookConnect)
      {
        Vec2 vel = body.getLinearVelocity();
        
        if (notMoving)
        {
          if (pos.y >= platPosY && pos.x >= platPosX)
          {
            vel.y = 40;
            vel.x = -40;
          }
          else if (pos.y >= platPosY && pos.x <= platPosX)
          {
            vel.y = 40;
            vel.x = 40;
          }
          else if (pos.y <= platPosY && pos.x >= platPosX)
          {
            vel.y = -40;
            vel.x = -40;
          }
          else if (pos.y <= platPosY && pos.x <= platPosX)
          {
            vel.y = -40;
            vel.x = 40;
          }
        
          body.setLinearVelocity(vel);
          
          notMoving = false;
        }
        
        if (hookTime > 1)
        {
          hookCooling = true;
          hooking = false;
          hookConnect = false;
          notMoving = true;
          hookTime = 0;
          
          Vec2 vel2 = body.getLinearVelocity();
          vel2.x = vel2.x/2;
          vel2.y = vel2.y/2;
          body.setLinearVelocity(vel2);
        }
        
        hookTime += timeDelta;
      }
    }
    
    if (!hooking)
    {
      if (hookCooling)
      {
        hookTime += timeDelta;
      
        if (hookTime > 2)
        {
          hookCooling = false;
          hookTime = 0;
        }
      }
    }
  }  
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
  
    noStroke();
    fill(c);
    pushMatrix();
    translate(pos.x, pos.y);
    rectMode(CENTER);
    rect(0, 0, size, size);
    popMatrix();
  }
  
  void makeBody(Vec2 center, float w_, float h_)
  {

    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;

    fd.density = 1;
    fd.friction = 2;
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