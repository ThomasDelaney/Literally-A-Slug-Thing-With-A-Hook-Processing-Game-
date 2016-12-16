class Player extends GameObject
{
  PVector velocity;
  PVector accel;
  float theta;
  char left, right, hook;
  float radius;
  
  Player(float x, float y, float theta, float size, char left, char right, char hook)
  {
    pos = new PVector(x, y);
    forward = new PVector(0, -1);
    accel = new PVector(0,0);
    velocity = new PVector(0,0);
    //force = new PVector(0, 0);
    this.theta = theta;
    this.size = size;
    radius = size / 2;
    
    this.left = left;
    this.right = right;
    this.hook = hook;
  }
  
  void update()
  {
  }
  
  void render()
  {
  }
}