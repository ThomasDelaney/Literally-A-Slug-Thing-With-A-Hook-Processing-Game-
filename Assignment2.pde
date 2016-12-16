void setup()
{
  size(1280, 720);
  ground = new Platform (width/2, height-7.5, width, 15, color(255, 0, 0));
}

void draw()
{
  background(0);
  
  ground.update();
  ground.render();
   
  p1.update();
  p1.render();
}

Platform p1 = new Platform (700, 500, 200, 15, color(255));
Platform ground;