interface Enemy
{
  void attack();
  
  void die();
  
  void calDest();
  
  void makeBody(Vec2 center, float wid, float hei);
}