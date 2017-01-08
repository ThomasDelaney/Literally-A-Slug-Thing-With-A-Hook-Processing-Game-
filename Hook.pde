class Hook extends GameObject
{ 
  PImage[] pic;
  boolean hooking = false;
  boolean hookCooling = false;
  boolean hookConnect = false;
  boolean notMoving = true;
  float tempX;
  float tempY;
  float xR;
  float yR;
  float scale = 1;
  int hookDir;
  float hookTime = 0;
  
  Hook(float x, float y)
  {
    pic = new PImage[4];
    pos = new Vec2 (x, y);
    
    pic[0] = loadImage("hook.png");
    pic[1] = loadImage("hook2.png");
    pic[2] = loadImage("hook3.png");
    pic[3] = loadImage("hook4.png");
    
    pic[0].resize(35, 25);
    pic[1].resize(35, 25);
    pic[2].resize(35, 25);
    pic[3].resize(35, 25);
  }
  
  void render()
  {}
  
  void update(Player p)
  {
    stroke(0);
    strokeWeight(3);
    
    float cX = (p.pos.x+pos.x)/2;
    float cY = (p.pos.y+pos.y)/2;
    
    float dX = pos.x - cX;
    float dY = pos.y - cY;
    
    float theta = atan(dY/dX);
    
    line(p.pos.x, p.pos.y, pos.x, pos.y);
      
    if (!hookConnect)
    {
      if (pos.x <= platPosX && pos.y <= platPosY)
      {
        tempX = platPosX - pos.x;
        tempY = platPosY - pos.y;
          
        xR = (tempX/platPosX)*scale;
        yR = (tempY/platPosY)*scale;
          
        pos.x+=xR;
        pos.y+=yR;
          
        hookDir = 1;
      }
      else if (pos.x <= platPosX && pos.y >= platPosY)
      {
        tempX = platPosX - pos.x;
        tempY = pos.y - platPosY;
         
        xR = (tempX/platPosX)*scale;
        yR = (tempY/platPosY)*scale;
          
        pos.x+=xR;
        pos.y-=yR;
          
        hookDir = 2;
      }
      else if (pos.x >= platPosX && pos.y >= platPosY)
      {
        tempX = pos.x - platPosX;
        tempY = pos.y -  platPosY;
         
        xR = (tempX/platPosX)*scale;
        yR = (tempY/platPosY)*scale;
          
        pos.x-=xR;
        pos.y-=yR;
          
        hookDir = 3;
      }
      else if (pos.x >= platPosX && pos.y <= platPosY)
      {
        tempX = pos.x - platPosX;
        tempY = platPosY - pos.y;
                    
        xR = (tempX/platPosX)*scale;
        yR = (tempY/platPosY)*scale;
          
        pos.x-=xR;
        pos.y+=yR;
         
        hookDir = 4;
      }
        
      scale += 1.5;
        
      if (hookDir == 1)
      {
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(theta);
        image(pic[3], -15, -13.5);
        popMatrix();
        
        if (pos.x+1 >= platPosX && pos.y+1 >= platPosY)
        {
          hookConnect = true;
        }
      }
      else if (hookDir == 2)
      {
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(theta);
        image(pic[3], -15, -13.5);
        popMatrix();
        
        if (pos.x+1 >= platPosX && pos.y <= platPosY+1)
        {
          hookConnect = true;
        }
      }
      else if (hookDir == 3)
      {
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(theta);
        image(pic[1], -28.5, -13.5);
        popMatrix();
        
        if (pos.x <= platPosX+1 && pos.y <= platPosY+1)
        {
          hookConnect = true;
        }
      }
      else if (hookDir == 4)
      {
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(theta);
        image(pic[1], -28.5, -13.5);
        popMatrix();
        
        if (pos.x <= platPosX+1 && pos.y+1 >= platPosY)
        {
          hookConnect = true;
        }
      }
    }
       
    if (hookConnect)
    {
      Vec2 vel = p.body.getLinearVelocity();
        
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
        
        p.body.setLinearVelocity(vel);
          
        notMoving = false;
      }
        
      if (hookTime > 1)
      {
        hookCooling = true;
        hooking = false;
        hookConnect = false;
        notMoving = true;
        hookTime = 0;
          
        Vec2 vel2 = p.body.getLinearVelocity();
        vel2.x = vel2.x/2;
        vel2.y = vel2.y/2;
        p.body.setLinearVelocity(vel2);
      }
        
      hookTime += timeDelta;
    }
  }
}