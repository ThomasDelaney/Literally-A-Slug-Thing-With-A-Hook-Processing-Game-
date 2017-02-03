import java.util.*;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import java.awt.*;

Box2DProcessing box2d;

void setup()
{
  //size(1280, 720);
  fullScreen();
  
  overPlat = false;

  font = createFont("3Dventure.ttf", 150); 
  textAlign(CENTER);
}

void draw()
{
  background(255);
  
  if (gameState == 1)
  {
    box2d.step();
    
    if (levelComplete == true)
    {
      score++;
      player.stimer = player.speedTime+1;
      player.itimer = player.invTime+1;

      curHealth = player.health;
      box2d = null;
            
      platforms.clear();
      powerUps.clear();
      activePowers.clear();
      enemies.clear();
      other.clear();
      generate();
      levelComplete = false;
    }
   
    player.update();
    player.render();
      
    ground.update();
    ground.render();
    
    goal.update();
    goal.render();
     
    for (int i = enemies.size()-1; i >= 0; i--)
    {
      GameObject c = enemies.get(i);
      
      if (c instanceof Bomber)
      {
        Bomber bm = (Bomber) c;
        bm.update();
        bm.render();
      }
      else if (c instanceof Shooter)
      {
        Shooter bm = (Shooter) c;
        bm.update();
        bm.render();
      }
      else if (c instanceof Spiker)
      {
        Spiker bm = (Spiker) c;
        bm.update();
        bm.render();
      }
    }
    
    for (int i = platforms.size()-1; i >= 0; i--)
    {
      Platform cPlat = platforms.get(i);
      
      cPlat.update();
      cPlat.render();
    }
    
    platCheck(player);
    
    fill(0);
    textFont(font);
    textSize(30);
    text("Health: "+player.health, 130, 30);
    
    text("Score: "+score, width-scaleFactor*15, 30);
    
    if (player.h.hookCooling == true)
    {
      fill(255, 0, 0);
      text("Hook Status: Cooling...", scaleFactor*60, 30);
    }
    else if (player.h.hooking == true)
    {
      fill(255, 128, 0);
      text("Hook Status: Hooking...", scaleFactor*60, 30);
    }
    else
    {
      fill(0, 204, 0);
      text("Hook Status: Ready", scaleFactor*60, 30);
    }
    
    if (!timeSet)
    {
      powerUpSpawn = random(1, 2);
      //powerUpSpawn = random(5, 21);
      timeSet = true;
    }
    
    if (powerUpTimer > powerUpSpawn)
    {
      int power = (int)random(1,4);
      GameObject p;
      
      if (power == 1)
      {
        p = new Health(random(50, width-50), 0, 30, 30);
      }
      else if (power == 2)
      {
        p = new Speed(random(50, width-50), 0, 30, 30);
      }
      else
      {
        p = new Invincible(random(50, width-50), 0, 30, 30);
      }
      
      powerUps.add(p);
      powerUpTimer = 0;
    }
    
    for (int i = powerUps.size()-1; i >= 0; i--)
    {
      GameObject p = (GameObject)powerUps.get(i);
      
      if (p instanceof Health)
      {
        Health h = (Health) p;
        h.update();
        h.render();   
      }
      else if (p instanceof Speed)
      {
        Speed s = (Speed) p;
        s.update();
        s.render(); 
      }
      else if (p instanceof Invincible)
      {
        Invincible inv = (Invincible) p;
        inv.update();
        inv.render(); 
      }
    }
    
    powerUpTimer += timeDelta;
  }
  else if (gameState == 2)
  {
    fill(0);
    textFont(font);
    textSize(100);
    text("Game Over! Score: "+score, width/2, height/2);
    
    if ((mouseX < width/2+350 && mouseX > width/2-350) && (mouseY > height/1.25-200 && mouseY < height/1.25-100))
    {
      textSize(80);
      text("Back to Main Menu", width/2, height/1.5);
      
      if (mousePressed)
      {
        gameState = 3;
        curHealth = 5;
        score = 0;
      }
    }
    else
    {
      textSize(70);
      text("Back to Main Menu", width/2, height/1.5);
    }
  }
  else if (gameState == 3)
  {
    if (!loadTempWorld)
    {
      box2d = new Box2DProcessing(this);
      box2d.createWorld();
      box2d.setGravity(0, -10);
    
      box2d.listenForCollisions();
      loadTempWorld = true;
    }
    
    mainMenu();
  }
  else if (gameState == 4)
  {
    if (frameCount % 5 == 0)
    {
      g = color(random(0, 255), random(0, 255), random(0, 255));
    }
  
    fill(g);
    textSize(scaleFactor*7);
    text("Written and Designed by Thomas Delaney", width/2, height/6);
    text("For Computer Science Year 2 Assignment", width/2, height/4);
    
    fill(0);
    text("All Music Used Owned\nby the Artist: HOME", width/2, height/2);
    
    if ((mouseX < width/2+350 && mouseX > width/2-350) && (mouseY > height/1.25-60 && mouseY < height/1.25+7.5))
    {
      textSize(80);
      text("Back to Main Menu", width/2, height/1.25);
      
      if (mousePressed)
      {
        gameState = 3;
      }
    }
    else
    {
      textSize(70);
      text("Back to Main Menu", width/2, height/1.25);
    }
  }
}

color f;
color g;
boolean loadTempWorld = false;

void mainMenu()
{
  float sGx = width/2;
  float sGy = height/3;
  
  float lGx = width/2;
  float lGy = height/2.35;
  
  float credX = width/2;
  float credY = height/1.95;
  
  float exitX = width/2;
  float exitY = height/1.65;
  
  box2d.step();
  
  if(!hL)
  {
    hPlat = new Platform (width/2, height+5, width, 10, color(0, 0, 255));
    hSh = new Shooter(100, height-32.1495, 87, 54);
    hB = new Bomber(400,  height-32.1495, 87, 54);
    hSp = new Spiker (700, height-32.1495, 60, 45);
    
    homeScreen.add(hPlat);
    homeScreen.add(hSh);
    homeScreen.add(hB);
    homeScreen.add(hSp);  
    hL = true;
  }
  else
  {
    for (int i = homeScreen.size()-1; i >= 0; i--)
    {
      GameObject p = (GameObject)homeScreen.get(i);
      
      if (p instanceof Platform)
      {
        Platform h = (Platform) p;
        h.update();
        h.render();   
      }
      else if (p instanceof Spiker)
      {
        Spiker s = (Spiker) p;
        s.update();
        s.render(); 
      }
      else if (p instanceof Shooter)
      {
        Shooter sh = (Shooter) p;
        sh.update();
        sh.render(); 
      }
      else if (p instanceof Bomber)
      {
        Bomber b = (Bomber) p;
        b.update();
        b.render(); 
      }
    }
  }
  
  if (frameCount % 5 == 0)
  {
    f = color(random(0, 255), random(0, 255), random(0, 255));
  }
  
  fill(f);
  textFont(font);
  textSize(scaleFactor*8);
  text("Literally a Slug Thing with a Hook!", width/2, height/6);
  
  fill(0);
  
  if ((mouseX < sGx+182.5 && mouseX > sGx-182.5) && (mouseY > sGy-35 && mouseY < sGy+7.5))
  {
    textSize(70);
    text("New Game", sGx, sGy);
    
    if (mousePressed)
    {
      box2d = null;
            
      platforms.clear();
      powerUps.clear();
      activePowers.clear();
      enemies.clear();
      other.clear();
      homeScreen.clear();
      hL = false;
      loadTempWorld = false;
      
      generate();
      gameState = 1;
    }
  }
  else
  {
    textSize(60);
    text("New Game", sGx, sGy);
  }
  
  if ((mouseX < lGx+175 && mouseX > lGx-175) && (mouseY > lGy-35 && mouseY < lGy+7.5))
  {
    textSize(70);
    text("Leaderboard", lGx, lGy);
  }
  else
  {
    textSize(60);
    text("Leaderboard", lGx, lGy);
  }
  
  if ((mouseX < credX+135 && mouseX > credX-135) && (mouseY > credY-35 && mouseY < credY+7.5))
  {
    textSize(70);
    text("Credits", credX, credY);
    
    if (mousePressed)
    {
      gameState = 4;
    }
  }
  else
  {
    textSize(60);
    text("Credits", credX, credY);
  }
  
  if ((mouseX < exitX+75 && mouseX > exitX-75) && (mouseY > exitY-35 && mouseY < exitY+7.5))
  {
    textSize(70);
    text("Exit", exitX, exitY);
    
    if (mousePressed)
    {
      exit();
    }
  }
  else
  {
    textSize(60);
    text("Exit", exitX, exitY);
  }
  
  pushMatrix();
      
  translate(width-(width*0.45), height);
  scale(scaleFactor);
      
  beginShape();
  noStroke();
  fill(101, 242, 139);
  vertex(0,0);
  vertex(44, -33);
  vertex(50, 0);
  endShape();
     
  beginShape();
  strokeWeight(1);
  strokeCap(ROUND);
  stroke(0);
  fill(101, 242, 139);
  bezier(0, 0, -0.45, -6.83, 5.7, -9.58, 9.03, -6.76);
  bezier(9.03, -6.76, 8.8, -12.9, 12.7, -14.86, 18.3, -13.03);
  bezier(18.3, -13.03, 18.34, -18.53, 22.5, -21.63, 28.86, -18.9); 
  bezier(28.86, -18.9, 28.84, -29.3, 36.9, -32.25, 43.32, -32.3); 
  bezier(43.32, -32.3, 55.44, -29.13, 61.4, -15.2, 50, 0);
  endShape();
  
  beginShape();
  strokeWeight(1);
  strokeCap(ROUND);
  stroke(0);
  vertex(0, 0);
  vertex(50, 0);
  endShape();
  
  beginShape();
  strokeWeight(1);
  strokeCap(ROUND);
  stroke(0);
  fill(237, 71, 109);
  vertex(29, -25);
  vertex(19, -40);
  vertex(34, -30);
  endShape();
  
  beginShape();
  strokeWeight(1);
  strokeCap(ROUND);
  stroke(0);
  fill(237, 71, 109);
  vertex(34, -30);
  vertex(33, -48);
  vertex(40, -33);
  endShape();
  
  beginShape();
  strokeWeight(1);
  strokeCap(ROUND);
  stroke(0);
  fill(237, 71, 109);
  vertex(40, -33);
  vertex(45, -50);
  vertex(49, -30);
  endShape();
  
  beginShape();
  strokeWeight(1);
  strokeCap(ROUND);
  stroke(0);
  fill(237, 71, 109);
  vertex(49, -30);
  vertex(58, -48);
  vertex(54, -26);
  endShape();
  
  beginShape();
  fill(0);
  ellipse(46, -23, 2.5, 2.5);
  
  noFill();
  bezier(40, -25, 40.99, -27.73, 42.77, -29.33, 47.49, -28.58);
  endShape();
  
  beginShape();
  strokeWeight(1);
  strokeCap(ROUND);
  stroke(0);
  fill(255);
  vertex(56, -18);
  vertex(42, -17);
  vertex(56, -12);
  endShape();
  
  beginShape();
  strokeWeight(1);
  strokeCap(ROUND);
  stroke(0);
  fill(237, 71, 109);
  vertex(47, -7);
  vertex(59, -11);
  vertex(60, -5);
  vertex(48, -3);
  endShape();
  
  popMatrix();
}

Platform hPlat;
Shooter hSh;
Spiker hSp;
Bomber hB;

Platform tempPlat;
Platform p1;
Platform p2;
Platform ground;

Goal goal;

Bomb b;

Player player;

Shooter s1;
Bomber b1;
Bomber b5;
Spiker sp1;

float scaleFactor = (width/height)*8;

boolean[] keys = new boolean[1000];

ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();

ArrayList<Platform> platforms = new ArrayList<Platform>();

ArrayList<GameObject> powerUps = new ArrayList<GameObject>();

ArrayList<GameObject> activePowers = new ArrayList<GameObject>();

ArrayList<GameObject> enemies = new ArrayList<GameObject>();

ArrayList<GameObject> other = new ArrayList<GameObject>();

ArrayList<Rectangle> rects = new ArrayList<Rectangle>();

ArrayList<GameObject> homeScreen = new ArrayList<GameObject>();

float timeDelta = 1.0f / 60.0f;

float powerUpTimer = 0;
float powerUpSpawn = 0;

boolean timeSet = false;

float platPosX;
float platPosY;

boolean overPlat;
boolean onPlat = false;

boolean PTouchB = false;
boolean PTouchSp = false;
boolean PTouchSh = false;

boolean levelComplete = false;

//to check if the homescreen sprites were loaded
boolean hL = false;

int curHealth = 5;

Bullet hit;
Bomb hitB;

int gameState = 3;

int score = 0;

PFont font;

void generate()
{
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);

  box2d.listenForCollisions();
  
  player = new Player(50, height-32.1495, 0, 60, 44, 'a', 'd', 'f', color(101, 242, 139), 1, curHealth);
  goal = new Goal(width-65, random(54, height-54), 60, 44);
  ground = new Platform (width/2, height-5, width, 10, color(0, 0, 255));
  
  player.body.setLinearVelocity(new Vec2(0,0));
  player.dir = 1;
  player.body.setTransform(new Vec2(box2d.coordPixelsToWorld(50, height-32.1495)), player.body.getAngle());
  
  int numOfPlats = (int)random(9,12);
  float rX = random(150, width-200);
  float rY = random(50, height-100);
  float rW = random(100, 300);
 
  rects.clear();
  genPlats(numOfPlats, rX, rY, rW);
  
  for (int i = 0; i < rects.size(); i++)
  {
    Rectangle r = rects.get(i);
    
    Platform p = new Platform ((float)r.getX(), (float)r.getY(), (float)r.getWidth(), (float)r.getHeight(), color(0));
    platforms.add(p);
  }
  
  delete.clear();

  int onGround = (int)random(1,3);
  
  for (int x = 0; x < onGround; x++)
  {
    int rand = (int)random(1, 4);
    GameObject s;
    
    if (rand == 1)
    {
      s = new Shooter(random(200, width-200), height-32.1495, 87, 54);
    }
    else if (rand == 2)
    {
      s = new Bomber(random(200, width-200), height-32.1495, 87, 54);
    }
    else
    {
      s = new Spiker (random(200, width-200), height-32.1495, 60, 45);
    }
    enemies.add(s);
  }
  
  int plats = platforms.size()-1;
  int numOfEnemies = 5-onGround;
  int lastInd[] = new int[plats];
  
  for (int x = 0; x < numOfEnemies-1; x++)
  {
    int ind = (int)random(plats);
    int rand = (int)random(1, 4);
    GameObject s;
    
    for (int y = 0; y < lastInd.length; y++)
    {
      if (lastInd[y] == ind)
      {
        x++;
        
        if (x > numOfEnemies-1)
        {
          x--;
        }
      }
    }
    
    Platform p = platforms.get(x);
    
    if (rand == 1)
    {
      s = new Shooter(random(p.pos.x+60, (p.pos.x+p.w_)-60), (p.pos.y+p.h_)-32.1495, 87, 54);
    }
    else if (rand == 2)
    {
      s = new Bomber(random(p.pos.x+60, (p.pos.x+p.w_)-60), (p.pos.y+p.h_)-32.1495, 87, 54);
    }
    else
    {
      s = new Spiker (random(p.pos.x+60, (p.pos.x+p.w_)-60), (p.pos.y+p.h_)-32.1495, 60, 45);
    }
    enemies.add(s);
  }
}

void genPlats(int numOfPlats, float rX, float rY, float rW)
{
  for (int k = 0; k < numOfPlats; k++)
  {
    rX = random(150, width-200);
    rY = random(50, height-100);
    rW = random(100, 300);
    boolean inter = false;
    
    Rectangle p = new Rectangle ((int)rX, (int)rY, (int)rW, 10);
    
    for (int i = 0; i < rects.size(); i++)
    {
      Rectangle g = rects.get(i);
      
      if (p.intersects(g))
      {
        inter = true;
        break;
      }
    }
    
    if (!inter)
    {
      rects.add(p);
    }
  }
}

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
    
    Filter filter = f2.getFilterData();
    filter.groupIndex = -2;
    
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Bomber.class) 
  {
    PTouchB = true;
    
    Filter filter = f1.getFilterData();
    filter.groupIndex = -2;
  }
  
  if (o1.getClass() == Bomb.class && o2.getClass() == Bomber.class) 
  {
    Filter filter = f2.getFilterData();
    filter.groupIndex = -3;
  }
  else if (o2.getClass() == Bomb.class && o1.getClass() == Bomber.class )
  {
    Filter filter = f1.getFilterData();
    filter.groupIndex = -3;
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
    Player p1 = (Player) o1;
    if (!p1.inv)
    {
      p1.health--;
      Vec2 vel = player.body.getLinearVelocity();
      vel.x = -vel.x*2;
      vel.y = -vel.y*1.25;
      player.body.setLinearVelocity(vel);
    }
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Spiker.class) 
  {
    Player p1 = (Player) o2;
   
    PTouchSp = true;
    
    if (!p1.inv)
    {
      p1.health--;
      Vec2 vel = player.body.getLinearVelocity();
      vel.x = -vel.x*2;
      vel.y = -vel.y*1.25;
      player.body.setLinearVelocity(vel);
    }
  }
 
  if (o1.getClass() == Player.class && o2.getClass() == Bullet.class) 
  {
    Player p1 = (Player) o1;
    if (!p1.inv)
    {
      p1.health--;
    }
    
    hit = (Bullet) o2;
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Bullet.class) 
  {
    Player p1 = (Player) o2;
    if (!p1.inv)
    {
      p1.health--;
    }
    
    hit = (Bullet) o1;
  }
  
  if (o1.getClass() == Bomb.class && o2.getClass() == Platform.class) 
  {
    Bomb b = (Bomb) o1;
    b.touchingPlat = true;
  }
  else if (o2.getClass() == Bomb.class && o1.getClass() == Platform.class )
  {
    Bomb b = (Bomb) o2;
    b.touchingPlat = true;
  }
  
  if (o1.getClass() == Player.class && o2.getClass() == Bomb.class) 
  {
    Player p1 = (Player) o1;
    
    hitB = (Bomb) o2;
    
    if (!p1.inv)
    {
      p1.health--;
      Vec2 vel = player.body.getLinearVelocity();
      vel.x = -vel.x*2;
      vel.y = -vel.y*1.25;
      player.body.setLinearVelocity(vel);
    }
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Bomb.class) 
  {
    Player p1 = (Player) o2;
    
    hitB = (Bomb) o1;
    
    if (!p1.inv)
    {
      p1.health--;
      Vec2 vel = player.body.getLinearVelocity();
      vel.x = -vel.x*2;
      vel.y = -vel.y*1.25;
      player.body.setLinearVelocity(vel);
    }
  }
  
  if (o1.getClass() == Player.class && o2.getClass() == Health.class) 
  {
    Player p1 = (Player) o1;
    p1.health++;
    
    Health h = (Health) o2;
    h.hit = true;
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Health.class) 
  {
    Player p1 = (Player) o2;
    p1.health++;
    
    Health h = (Health) o1;
    h.hit = true;
  }
  
  if (o1.getClass() == Player.class && o2.getClass() == Speed.class) 
  {
    Player p1 = (Player) o1;
    p1.speed = true;
    p1.stimer = 0;
    
    Speed s = (Speed) o2;
    s.hit = true;
    
    for (int j = 0; j < activePowers.size(); j++)
    {
      GameObject p = activePowers.get(j);
      
      if (p instanceof Speed)
      {
        Speed s3 = (Speed) p;
        activePowers.remove(s3);
      }
    }
    activePowers.add(s);
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Speed.class) 
  {
    Player p1 = (Player) o2;
    p1.speed = true;
    p1.stimer = 0;
    
    Speed s = (Speed) o1;
    s.hit = true;
   
   
    for (int j = 0; j < activePowers.size(); j++)
    {
      GameObject p = activePowers.get(j);
      
      if (p instanceof Speed)
      {
        Speed s3 = (Speed) p;
        activePowers.remove(s3);
      }
    }
    activePowers.add(s);
  }
  
  if (o1.getClass() == Player.class && o2.getClass() == Invincible.class) 
  {
    Player p1 = (Player) o1;
    p1.inv = true;
    p1.itimer = 0;
    
    Invincible z = (Invincible) o2;
    z.hit = true;
    
    for (int j = 0; j < activePowers.size(); j++)
    {
      GameObject p = activePowers.get(j);
      
      if (p instanceof Invincible)
      {
        Invincible in = (Invincible) p;
        activePowers.remove(in);
      }
    }
    activePowers.add(z);
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Invincible.class) 
  {
    Player p1 = (Player) o2;
    p1.inv = true;
    p1.itimer = 0;
    
    Invincible z = (Invincible) o1;
    z.hit = true;
   
   
    for (int j = 0; j < activePowers.size(); j++)
    {
      GameObject p = activePowers.get(j);
      
      if (p instanceof Invincible)
      {
        Invincible inv = (Invincible) p;
        activePowers.remove(inv);
      }
    }
    activePowers.add(z);
  }
  
  if (o1.getClass() == Player.class && o2.getClass() == Goal.class) 
  {
    levelComplete = true;
  }
  else if (o2.getClass() == Player.class && o1.getClass() == Goal.class )
  {
    levelComplete = true;
  }
  
  
  //Bullets collide with any other object beside Player - Destroy bullet
  if (o1.getClass() == Bullet.class && o2.getClass() == Bomb.class) 
  {
    hit = (Bullet) o1;
  }
  else if (o2.getClass() == Bullet.class && o1.getClass() == Bomb.class )
  {
    hit = (Bullet) o2;
  }
  
  if (o1.getClass() == Bullet.class && o2.getClass() == Bomber.class) 
  {
    hit = (Bullet) o1;
  }
  else if (o2.getClass() == Bullet.class && o1.getClass() == Bomber.class )
  {
    hit = (Bullet) o2;
  }
  
  if (o1.getClass() == Bullet.class && o2.getClass() == Bullet.class) 
  {
    hit = (Bullet) o1;
  }
  else if (o2.getClass() == Bullet.class && o1.getClass() == Bullet.class )
  {
    hit = (Bullet) o2;
  }
  
  if (o1.getClass() == Bullet.class && o2.getClass() == Platform.class) 
  {
    hit = (Bullet) o1;
  }
  else if (o2.getClass() == Bullet.class && o1.getClass() == Platform.class )
  {
    hit = (Bullet) o2;
  }
  
  if (o1.getClass() == Bullet.class && o2.getClass() == Shooter.class) 
  {
    hit = (Bullet) o1;
  }
  else if (o2.getClass() == Bullet.class && o1.getClass() == Shooter.class )
  {
    hit = (Bullet) o2;
  }
  
  if (o1.getClass() == Bullet.class && o2.getClass() == Spiker.class) 
  {
    hit = (Bullet) o1;
  }
  else if (o2.getClass() == Bullet.class && o1.getClass() == Spiker.class )
  {
    hit = (Bullet) o2;
  }
  
  if (o1.getClass() == Bullet.class && o2.getClass() == Health.class) 
  {
    hit = (Bullet) o1;
  }
  else if (o2.getClass() == Bullet.class && o1.getClass() == Health.class )
  {
    hit = (Bullet) o2;
  }
  
  if (o1.getClass() == Bullet.class && o2.getClass() == Speed.class) 
  {
    hit = (Bullet) o1;
  }
  else if (o2.getClass() == Bullet.class && o1.getClass() == Speed.class )
  {
    hit = (Bullet) o2;
  }
  
  if (o1.getClass() == Bullet.class && o2.getClass() == Invincible.class) 
  {
    hit = (Bullet) o1;
  }
  else if (o2.getClass() == Bullet.class && o1.getClass() == Invincible.class )
  {
    hit = (Bullet) o2;
  }
  
  if (o1.getClass() == Bullet.class && o2.getClass() == Goal.class) 
  {
    hit = (Bullet) o1;
  }
  else if (o2.getClass() == Bullet.class && o1.getClass() == Goal.class )
  {
    hit = (Bullet) o2;
  }
  //Okay we're done with Bullets
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