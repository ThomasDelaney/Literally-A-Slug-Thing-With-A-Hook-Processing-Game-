import java.util.*;

void setup()
{
  size(1280, 720);
  
  //ground = new Platform (0, height-15, width, 15, color(255, 0, 0));
  ground = new Platform (500, 175, 200, 15, color(255, 0, 0));

  gameObjects.add(p1);
  gameObjects.add(ground);
  gameObjects.add(p2);
  gameObjects.add(player);
}

void draw()
{
  background(0);
  
  player.update();
  player.render();
  
  ground.update();
  ground.render();
   
  p1.update();
  p1.render();
  
  p2.update();
  p2.render();
  
  //println("x: " + mouseX);
  //println("y: " + mouseY);
}

Platform tempPlat;
//Platform p1 = new Platform (500, 200, 200, 15, color(255));
Platform p1 = new Platform (100, 500, 1280-200, 15, color(255));
Platform p2 = new Platform (300, 310, 1280-200, 15, color(255, 144, 0));
Platform ground;

Player player = new Player(500, 50, 0, 200, 'a', 'd', 'f', color(0, 255, 0));

boolean[] keys = new boolean[1000];

ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();

float timeDelta = 1.0f / 60.0f;

void keyPressed()
{ 
  keys[keyCode] = true;
}
 
void keyReleased()
{
  keys[keyCode] = false; 
}

boolean checkKey(int k)
{
  if (keys.length >= k) 
  {
    return keys[k] || keys[Character.toUpperCase(k)];  
  }
  return false;
}