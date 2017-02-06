# Literally A Slug Thing With A Hook!
Thomas Delaney C15300756 DT228/2 Winter Assignment

#YouTube Video

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/1V9bT77H-N8/0.jpg)](https://www.youtube.com/watch?v=1V9bT77H-N8)

# What is the Game About?
When I started this project I knew I was going to develop some sort of platformer, but I didn't want to create the average jump to platform to platform and kill and dodge the enemies platformer. Although this platformer does follow some of that criteria; I added a few twists...
You play as a slug creater that has this grappling hook which can be used to grapple onto sides of platforms, you can then launch yourself in that platforms general direction (There is always 1 platform that can't be hooked to; the ground). The aim of the game is to get to the other side of the screen where there is a silhouette of the slug. You must dodge 3 types of enemies, the Spiker, who has spikes on his head and when you touch him you get pushed back in your current direction and lose health. There is the Shooter, who shoots bullets which remove health when touched, and finally the Bomber who drops bombs which push you back in your general direction and lose health. There are powerups that help you out however! 3 power ups drops in the form of Health, Invincibility and Speed, what each do is self explanitory. You start off with 5 health and the game ends when it reaches 0, once you complete a level you gain 1 score, the game generates infinitely until you run out of health.

# Main Menu Features
* Main Menu
  * Nicely layed out MM with a large graphic of the Slug and the enemies down the bottom of the screen, listed is New Game, LeaderBoard, Credits and Exit.
* New Game
  * Starts a new game
* LeaderBoard
  * A local leaderboard displaying player names with the top scores, you enter your name at the game over screen and your name and score is written to the leaderboard file
* Credits
  * Info about the game including music
* Exit
  * Exits the game

#Controls

* A to move LEFT, D to Move RIGHT
* Space to JUMP
* F to Hook
* ENTER to pause
* Hover mouse over playform to 'select' platform (mouse must be over platform side to successfully hook)

#Functionality

Most classes extend the GameObject abstract class, this holds some variables and methods that are common to most classes.
All Enemies (Shooter, Spiker, Bomber) implement the Enemy interface
All Power ups implement the PowerUp interface

* The Player
  * The player (slug) has a Hook object which is used to grapple to Platform edges, when the player hooks an edge you can see the hook grow to that corner, this is done by constantly calculating the distance between the player and platform edge then drawing a line (and hook) which is constantly increased by the current Hook position/platform position. When the hook locks onto the edge the difference is caculated in terms of vectors and then depending on your position, the velocity of the player is set to that vector, this intale shoots the player into that general direction aka the direction of the platform from your position.
  
* Enemies
  * The 3 enemies all use a calculate destination algorithm which chooses a random destination for them to walk to at random times, each enemy contains 1 ability to remove 1 health from the player, The Shooters bullets remove 1 health, touching the Spiker removes 1 health and touching the Bombers bombs remove 1 health. Bullets and Bombs both have times to live aka they despawn after a set time, they also despawn if they leave the screen, bullets specifically despawn if they hit anything.
  
* Power Ups
  * There are 3 Power ups, Health, Invincibility and Speed, which spawn at random times during a level, they have a time to live which is 30 seconds from spawning. A power up spawns at the top of the screen and falls downward, they can stack onto eachother and bounce off other objects (enemies etc). When the Player comes into contact with #Health power up it disappears and the Player gains 1 additional health. When the Player comes into contact with an #Invincibility power up it disappears and they cannot lose health for 5 seconds, the Players color changes to indicate this. When the Player comes into contact with a #Speed power up it disappears and their x velocity doubles for 5 seconds, the Players color changes to indicate this. There are timers at the top of the screen indicating how many seconds are left on a given power up. If a player has both an Invicibility and Speed power up active at once then the Player changes to a different color to indicate this.

* Platforms
  * The Platforms spawn at each level are randomly generated. So are the enemies but I'm going to write specifically about that, read further down this file to find it. Every level is randomly generated as I said, when you complete a level a new one is generated, it goes on forever until you die. To generate the platforms I had the problem of generating them and making sure no platforms overlapped. This is done by generating a random x, y, width and height and creating a java Rectangle object (from the awt library). I did this because Rectangle objects contain a method called 'r1.intersecs(r2)' which returns true if they intersect, so when generating the platforms I created a platform and if it didn't intersect any of the current rectanlges in the rectanlge array list I created then add it to the array list. The number of platforms generated per level is random, so it loops to that generated number then creates the platforms based on those rectangles details in the array list.
 
* Generating Enemies
  * A random number of enemies is chosen to be spawn for a level, this happens after all the platforms are generated. At most 2 enemies will spawn on the ground platform, the rest are spawned on any of the platforms but not he same, this is done by going through the array list of enemies and spawning them at random indexes of the platforms array list but never the same one twice.

* Music and Sound
  * There is sounds played for most events in the game, e.g different sounds for obtaining respective power ups,  sound for hooking, sound for completing a level, sound for taking damage and a sound for game over;
  
  All the music played throughout every part of the game is owned by the band HOME, there is 10 song pool, there is an algorithm which picks a song to play and then when that song is finished; pick another from the pool but not the one that was just played.
  
* Game Over and Leaderboard Entering
  * When the player dies they are brought to a game over screen which displays their score, there is also a text box where they can enter their name to be put into the leaderboard, user input is taken by keyPresses and stored in a Character array list to then be entered into an array and then coverted into a string, when the user clicks Enter their name and score is written to a text file in the data folder via a FileWriter variable from the java.io.FileWriter library. The user is then brought back to the main menu, they can then select the LeaderBoard to see where they placed. When you select the leaderboard the board.txt file is read into a table and their names and scores are entered into an array list of Details objects (which just store a string and interger), it implements a java built in interface called Comparable, this allows me to implement a method called compareTo which allows me to sort an array list of type Details by a given variable, in this case; their score. The array of Details is sorted then displayed to the user.

#Key Notes
* Lots of Inheritence and Polymorphism between GameObject and Implementing interfaces (Enemy and PowerUp)

* File I/O in the form of the Leaderboard.

* Use of the Box2D library to implement physics and collisions.

* Use of the Minim library to implement sound.

* All levels are randomly generated, game could go on infinitely.

* When the Shooter moves, his wheels move in the direction of his current velocity, giving the appearance that he is indeed moving.

* Multiple Power Ups give the game many dynamics, every playthrough will be exciting and different.

* Original Idea, I have not seen many games that follow this concept.

* The sketch is mapped to all sizes

