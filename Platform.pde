class Platform extends GameObject
{
  color c;
  float l; //length
  float h; //height
  
  Platform (float x, float y, float l, float h, color c)
  {
    pos = new PVector(x, y);
    forward = new PVector(0, -1);
    this.l = l;
    this.h = h;
    this.c = c;
  }
  
  void update()
  {
  }
  
  void render()
  {
    rectMode(CENTER);
    noStroke();
    fill(c);
    rect(pos.x, pos.y, l, h);
  }
}