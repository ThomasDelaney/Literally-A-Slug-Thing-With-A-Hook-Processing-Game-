class Hook extends GameObject
{ 
  Player p;
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
  
  float xS;
  float yS;
  
  Hook(float x, float y, float size)
  {
    pos = new Vec2 (x, y);
    this.size = size;
  }
  
  void render(float theta)
  {
    float pw = p.w_/2;
    float ph = p.h_/2;
    
    if (hookDir == 1 || hookDir == 2)
    {
      pushMatrix();
      
      translate(pos.x, pos.y);
      rotate(theta);
      scale(size);   
      
      beginShape();
      strokeWeight(((pw+ph/2)/2)/1.25);
      strokeCap(SQUARE);
      stroke(0);
         
      vertex(-15, -1);
      vertex(-8, -1);
      endShape();
      
      beginShape();
      noFill();
      strokeWeight(((pw+ph)/2)/5);
      strokeCap(ROUND);
      stroke(0);
      
      bezier(-8, -1, 39.7, -11.2, 29.7, 24.8, 9.4, 8.8);
      endShape();
      
      popMatrix();
    }
    else
    {
      pushMatrix();
      
      translate(pos.x, pos.y);
      rotate(theta);  
      scale(size);
      
      beginShape();
      strokeWeight(((pw+ph)/2)/1.25);
      strokeCap(SQUARE);
      stroke(0);
      
      vertex(0, 0);
      vertex(7, 0);
      endShape();
  
    
      beginShape();
      noFill();
      strokeWeight(((pw+ph)/2)/5);
      strokeCap(ROUND);
      stroke(0);
      
      bezier(5.2, 1.4, -49.4, -11.7, -46.2, 20, -19.8, 12.3);
      endShape();
      
      popMatrix();
    }
  }
  
  void setPlayer(Player t)
  {
    p = t;
    xS = 27*p.size;
    yS = 15*p.size;
  }
  
  void update()
  {
    float pX;
    float pY;
    
    if (hookDir == 1 || hookDir == 2)
    {
      pX = p.pos.x+xS;
      pY = p.pos.y+yS;
    }
    else
    {
      pX = p.pos.x-xS;
      pY = p.pos.y+yS;
    }
    
    float cX = (pX+pos.x)/2;
    float cY = (pY+pos.y)/2;
    
    float dX = pos.x - cX;
    float dY = pos.y - cY;
    
    float theta = atan(dY/dX);
    
    beginShape();
    strokeWeight(((p.w_/2+p.h_/2)/2)/(50/3));
    stroke(0);
    
    line(pX, pY, pos.x, pos.y);
    endShape();
    
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
        p.dir = 1;
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
        p.dir = 1;
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
        p.dir = 2;
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
        p.dir = 2;
      }
        
      scale += 1.5;
        
      if (hookDir == 1)
      {
        render(theta);
        
        if (pos.x+1 >= platPosX && pos.y+1 >= platPosY)
        {
          hookConnect = true;
        }
      }
      else if (hookDir == 2)
      {
        render(theta);
        
        if (pos.x+1 >= platPosX && pos.y <= platPosY+1)
        {
          hookConnect = true;
        }
      }
      else if (hookDir == 3)
      {
        render(theta);
        
        if (pos.x <= platPosX+1 && pos.y <= platPosY+1)
        {
          hookConnect = true;
        }
      }
      else if (hookDir == 4)
      {
        render(theta);
        
        if (pos.x <= platPosX+1 && pos.y+1 >= platPosY)
        {
          hookConnect = true;
        }
      }
    }
       
    if (hookConnect)
    {
      Vec2 target = box2d.coordPixelsToWorld(platPosX, platPosY);
      
      Vec2 v = target.addLocal(pos); 
      
      if (notMoving)
      {
        if (pos.y >= platPosY && pos.x >= platPosX)
        {
          v.x = -v.x/15;
          v.y = v.y/20;
        }
        else if (pos.y >= platPosY && pos.x <= platPosX)
        {
          v.x = v.x/15;
          v.y = v.y/20;
        }
        else if (pos.y <= platPosY && pos.x >= platPosX)
        {
          v.x = -v.x/15;
          v.y = -v.y/20;
        }
        else if (pos.y <= platPosY && pos.x <= platPosX)
        {
          v.x = v.x/15;
          v.y = -v.y/20;
        }
        
        p.body.setLinearVelocity(v);
          
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