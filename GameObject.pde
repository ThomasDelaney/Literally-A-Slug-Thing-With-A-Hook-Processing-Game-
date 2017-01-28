abstract class GameObject
{
  float size;
  float w_;
  float h_;
  int dir = 1;
  Vec2 pos;
  Vec2 forward;
  Body body;
  
  GameObject(float x, float y, float w_, float h_)
  {
    this.w_ = w_;
    this.h_ = h_;
    makeBody(new Vec2(x, y), w_, h_);
  }
  
  GameObject()
  {}
  
  void makeBody(Vec2 center, float w_, float h_)
  {}
  
  void update()
  {}
  
  void render()
  {}
  
  void reset()
  {}
}
  