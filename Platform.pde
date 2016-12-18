class Platform extends GameObject
{
  int id;
  color c;
  float w; //width
  float h; //height
  
  Platform (float x, float y, float w, float h, color c)
  {
    pos = new PVector(x, y);
    forward = new PVector(0, -1);
    this.w = w;
    this.h = h;
    this.c = c;
  }
  
  void update()
  {
  }
  
  void render()
  {
    noStroke();
    fill(c);
    
    pushMatrix();
    translate(pos.x, pos.y);
    rect(0, 0, w, h);
    popMatrix();
  }
}