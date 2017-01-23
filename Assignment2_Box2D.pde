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
  //fullScreen();
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);

  box2d.listenForCollisions();
  
  overPlat = false;
  
  s1 = new Shooter (500, 500, 87, 54);
  b1 = new Bomber (650, 500, 87, 54);
  sp1 = new Spiker (1000, 500, 60, 45);
  
  player = new Player(500, 350, 0, 60, 44, 'a', 'd', 'f', color(0, 255, 0), 1);
  p1 = new Platform (width/2,height-300, 300, 10, color(0));
  p2 = new Platform (width/2+200, height-150, 500, 10, color(255, 144, 0));
  
  ground = new Platform (width/2, height-5, width, 10, color(0, 0, 255));

  platforms.add(p1);
  platforms.add(p2);
  gameObjects.add(player);
  
  font = createFont("3Dventure.ttf", 150); 
}

void draw()
{
  background(255);
  box2d.step();
  
  s1.update();
  s1.render();
  
  b1.update();
  b1.render();
  
  sp1.update();
  sp1.render();
  
  player.update();
  player.render();  
    
  ground.update();
  ground.render();
   
  p1.update();
  p1.render();
  
  p2.update();
  p2.render();
  
  platCheck(player);
  
  fill(0);
  textFont(font);
  textSize(30);
  text("Health: "+player.health, 15, 30);
  
  if (player.h.hookCooling == true)
  {
    fill(255, 0, 0);
    text("Hook Status: Cooling...", 200, 30);
  }
  else if (player.h.hooking == true)
  {
    fill(255, 128, 0);
    text("Hook Status: Hooking...", 200, 30);
  }
  else
  {
    fill(0, 204, 0);
    text("Hook Status: Ready", 200, 30);
  }
}

Platform tempPlat;
Platform p1;
Platform p2;
Platform ground;

Player player;

Shooter s1;
Bomber b1;
Spiker sp1;

boolean[] keys = new boolean[1000];

ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();

ArrayList<Platform> platforms = new ArrayList<Platform>();

float timeDelta = 1.0f / 60.0f;

float platPosX;
float platPosY;

boolean overPlat;
boolean onPlat = false;

boolean PTouchB = false;
boolean PTouchSp = false;
boolean PTouchSh = false;

PFont font;

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
  
  String s1 = o1.getClass().getName();
  s1 = s1.replace("Assignment2_Box2D$", "");
  String s2 = o2.getClass().getName();
  s2 = s2.replace("Assignment2_Box2D$", "");
  
  //println(s1+" "+s2);
  
  if (o1.getClass() == Player.class && o2.getClass() == Platform.class) 
  {
    onPlat = true;
    Player p1 = (Player) o1;
    p1.returned = true;
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Platform.class)
  {
    onPlat = true;
    Player p1 = (Player) o2;
    p1.returned = true;
  }
  
  if (o1.getClass() == Player.class && o2.getClass() == Bomber.class) 
  {
    PTouchB = true;
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Bomber.class) 
  {
    PTouchB = true;
  }
  
  if (o1.getClass() == Player.class && o2.getClass() == Shooter.class) 
  {
    PTouchSh = true;
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Shooter.class) 
  {
    PTouchSh = true;
  }
  
  if (o1.getClass() == Player.class && o2.getClass() == Spiker.class) 
  {
    PTouchSp = true;
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Spiker.class) 
  {
    PTouchSp = true;
  }
}

void endContact(Contact cp) 
{
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  
  if (o1.getClass() == Player.class && o2.getClass() == Platform.class) 
  {
    onPlat = false;
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Platform.class)
  {
    onPlat = false;
  }
  
  if (o1.getClass() == Player.class && o2.getClass() == Bomber.class) 
  {
    PTouchB = false;
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Bomber.class) 
  {
    PTouchB = false;
  }
  
  if (o1.getClass() == Player.class && o2.getClass() == Shooter.class) 
  {
    PTouchSh = false;
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Shooter.class) 
  {
    PTouchSh = false;
  }
  
  if (o1.getClass() == Player.class && o2.getClass() == Spiker.class) 
  {
    PTouchSp = false;
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Spiker.class) 
  {
    PTouchSp = false;
  }
}

void platCheck(Player curPlayer)
{
  if (!curPlayer.h.hooking)
  {
    for (Platform p: platforms) 
    {
      if (mouseX > p.pos.x && mouseX < p.pos.x+p.w_/2 && mouseY > p.pos.y-p.h_ && mouseY < p.pos.y+p.h_)
      {
        fill(255, 0, 0);
        rect(p.pos.x+p.w_/4, p.pos.y, p.w_/2, 10);
      
        platPosX = p.pos.x+p.w_/2-10;
        platPosY = p.pos.y;
        
        overPlat = true;
        break;
      }
      else if (mouseX < p.pos.x && mouseX > p.pos.x-p.w_/2 && mouseY > p.pos.y-p.h_ && mouseY < p.pos.y+p.h_) 
      { 
        fill(255, 0, 0);
        rect(p.pos.x-p.w_/4, p.pos.y, p.w_/2, 10);
      
        platPosX = p.pos.x-p.w_/2+10;
        platPosY = p.pos.y;
        
        overPlat = true;
        break;
      }
      else
      {
        overPlat = false;
      }
    }
  }
}