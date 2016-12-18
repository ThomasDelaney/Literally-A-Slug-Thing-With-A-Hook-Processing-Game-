class Player extends GameObject
{
  PVector velocity;
  PVector accel;
  PVector gravity;
  float theta;
  char left, right, hook;
  float radius;
  PVector force;
  float power = 300;
  float mass = 1;
  color c;
  boolean reset = false;
  boolean onTemp = false;
  boolean goalSet = false;
  boolean jumping = false;
  boolean returned = true;
  float ygoal;
  
  Player(float x, float y, float theta, float size, char left, char right, char hook, color c)
  {
    pos = new PVector(x, y);
    forward = new PVector(0, -1);
    accel = new PVector(0,0);
    velocity = new PVector(0,0);
    force = new PVector(0, 0);
    gravity = new PVector(0,2);
    this.theta = theta;
    this.size = size;
    radius = size / 2;
    
    this.left = left;
    this.right = right;
    this.hook = hook;
    this.c = c;
  }
  
  void update()
  { 
    forward.x = -cos(theta);
    forward.y = 0;
    
    if (checkKey(left))
    {
      force.add(PVector.mult(forward, power));      
    }
    if (checkKey(right))
    {
      force.add(PVector.mult(forward, -power));      
    }
    
    if (checkKey(' ') && !goalSet && returned)
    {
      ygoal = pos.y-250;
      goalSet = true;
    }
     
    if(checkKey(' ') && goalSet && !jumping && returned)
    {
      jumping = true;
      returned = false;
    }
    
    if (jumping && !returned)
    {
      if (ygoal < pos.y)
      {
        pos.y -= 10;
      }
      else
      {
        jumping = false;
        goalSet = false;
      }
    }
    
    accel = PVector.div(force, mass);
    velocity.add(PVector.mult(accel, timeDelta));
    pos.add(PVector.mult(velocity, timeDelta));
    force.x = force.y = 0;
    velocity.mult(0.99f);
    
    for (int i = 0; i < gameObjects.size(); i++)
    {
      GameObject e = gameObjects.get(i);
      
      if (e instanceof Platform)
      {
        Platform p = (Platform) e; 
        
        if (onTemp == false && pos.x <= p.pos.x + p.w && pos.x + radius >= p.pos.x && pos.y <= p.pos.y + p.h && pos.y + radius >= p.pos.y)
        {
          tempPlat = p;
          onTemp = true;
        }
        else if (onTemp == true && pos.x <= tempPlat.pos.x + tempPlat.w && pos.x + radius >= tempPlat.pos.x && pos.y <= tempPlat.pos.y + tempPlat.h && pos.y + radius >= tempPlat.pos.y)
        {
          if (!reset)
          {
            velocity.y = 0; 
            reset = true;
            returned = true;
          }
        }
        else
        {
          velocity.add(gravity);
          reset = false;
          onTemp = false;
        }
      }
    }
  }  
  
  void render()
  {
    fill(c);
    
    pushMatrix();
    translate(pos.x, pos.y);
    rect(0, 0, radius, radius);
    popMatrix();
  }
}