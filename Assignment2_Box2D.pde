import java.util.*;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Box2DProcessing box2d;

void setup()
{
  size(1280, 720);
  smooth();
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);

  box2d.listenForCollisions();
  
  player = new Player(500, 350, 0, 100, 'a', 'd', 'f', color(0, 255, 0));
  p1 = new Platform (width/2,height-300, 300, 10, color(255));
  p2 = new Platform (width/2+200, height-150, 500, 10, color(255, 144, 0));
  
  ground = new Platform (width/2, height-5, width, 10, color(0, 0, 255));

  gameObjects.add(p1);
  gameObjects.add(ground);
  gameObjects.add(p2);
  gameObjects.add(player);
}

void draw()
{
  background(0);
  
  box2d.step();
  
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
Platform p1;
Platform p2;
Platform ground;

Player player;

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

void beginContact(Contact cp) 
{
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Player.class && o2.getClass() == Platform.class) 
  {
    Player p1 = (Player) o1;
    p1.returned = true;
  }

}

void endContact(Contact cp) 
{
}