abstract class GameObject
{
  float size;
  float w_;
  float h_;
  int dir = 1;
  Vec2 pos;
  Vec2 forward;
  Body body;
  
  GameObject()
  {}
  
  void makeBody()
  {}
  
  void update()
  {}
  
  void render()
  {}
  
  void reset()
  {}
}
  