import java.util.Iterator;
import gifAnimation.*;

//constants
final int MIN_NPCS_IN_ROOM = 1;
final int MAX_NPCS_IN_ROOM = 3;

final int NPC_HALF_WIDTH = 25;
final int NPC_HALF_HEIGHT = 30;

final int NEAR_PLAYER_RADIUS = 40;
 //<>//
final int NPC_WALL_AVOID_RADIUS = 10;

final float NPC_SLOW_SPEED = 0.5;
final float NPC_MEDIUM_SPEED = 1.5;
final float NPC_FAST_SPEED = 2;

// Global variables
Graph graph = new Graph();
int cols, rows;
int tileSize;
boolean npc_following_player;
boolean waitingForPlayerNoInput;
Dialogue dialogue;

// Map image //<>// //<>//
PImage map;

// Characters
ArrayList<NPC> npcs;
Character mainCharacter;
ArrayList<Edge> mainPathToFollow;
PlayerState playerState;

// Images
PImage npc_dialogue_img;

// UI Images
PImage buttons_w_text_ref_img;
PImage buttons_img;

// Fonts
PFont dialogue_font;
PFont actions_font;

// Animations
Gif mc_idle_gif;
Gif mc_walking_gif;
Gif mc_flex_gif;
Gif npc_idle_gif;
Gif npc_walking_gif;
Gif title_load_gif;
Gif title_enter_gif;

// Perlin and textures
Perlin perlin;
PGraphics floorTexture;
PGraphics wallTexture;
// Image to store generated map with rendered textures
PImage generatedMap;

// Explosion particle system
ParticleSystem ps;

// Time tracking
int start_time;
int time_elapsed;

// Variable to track time after the last NPC has exploded
int npc_gone_time;

// NPC number tracking
int max_npcs;
int npcsLeft;

ArrayList<RoomInformation> rooms;

GameState currentGameState;

void setup() {

  pixelDensity(1);
  size(1280, 720);
  windowTitle ("The Art of Saying No");  
  
  // Load images
  map = loadImage("demo-map-2.png");
  buttons_w_text_ref_img = loadImage("options-6.png");
  buttons_img = loadImage("options-buttons.png");

  // Load fonts
  dialogue_font = createFont("Jersey10-Regular.ttf", 48);
  actions_font = createFont("Jersey10-Regular.ttf", 24);

  // Load GIFs
  mc_idle_gif = new Gif(this, "mc-idle.gif");
  mc_idle_gif.loop();
  
  mc_flex_gif = new Gif(this, "mc-flex.gif");
  mc_flex_gif.loop();

  mc_walking_gif = new Gif(this, "mc-walk.gif");
  mc_walking_gif.loop();

  npc_idle_gif = new Gif(this, "npc-idle.gif");
  npc_idle_gif.loop();

  npc_walking_gif = new Gif(this, "npc-walking.gif");
  npc_walking_gif.loop();

  title_load_gif = new Gif(this, "title-load.gif");
  title_load_gif.ignoreRepeat();
  title_load_gif.play();

  title_enter_gif = new Gif(this, "title-enter.gif");
  title_enter_gif.loop();

  // Tilemap setup
  tileSize = 40;
  cols = width/tileSize;
  rows = height/tileSize;

  // Dialogue setup
  dialogue = new Dialogue(160);

  // Set up Perlin noise, texture block size, and floor and wall textures to use in tilemap
  int textureBlockSize = 4;
  perlin = new Perlin(500);
  floorTexture = createGraphics(tileSize, tileSize);
  wallTexture = createGraphics(tileSize, tileSize);

  // Map over Perlin noise values into discrete blocks and draw into a PGraphics floor texture
  for (int x = 0; x < tileSize; x+=textureBlockSize) {
    for (int y = 0; y < tileSize; y+=textureBlockSize) {
      float val = perlin.octaveNoise(x + random(1, 10), y, 0.5, 8, 0.5);
      val = map(val, 0, 1, 0, 255);
      float greyscale = 180;
      if (val < 80) {
        greyscale = 200;
      } else if (val < 100) {
        greyscale = 220;
      } else if (val < 120) {
        greyscale = 240;
      } else {
        greyscale = 255;
      }

      floorTexture.beginDraw();
      floorTexture.fill(greyscale);
      floorTexture.stroke(greyscale);
      floorTexture.rect(x, y, textureBlockSize, textureBlockSize);
      floorTexture.endDraw();
    }
  }

  // Map over Perlin noise values into discrete blocks and draw into a PGraphics wall texture
  for (int x = 0; x < tileSize; x+=textureBlockSize-1) {
    for (int y = 0; y < tileSize; y+=textureBlockSize-1) {
      float val = perlin.octaveNoise(x + random(1, 10), y, 0.4, 8, 0.45);
      val = map(val, 0, 1, 0, 255);
      float greyscale = 100;
      if (val < 80) {
        greyscale = 80;
      } else if (val < 100) {
        greyscale = 50;
      } else if (val < 120) {
        greyscale = 20;
      } else {
        greyscale = 0;
      }

      wallTexture.beginDraw();
      wallTexture.fill(greyscale);
      wallTexture.stroke(greyscale);
      wallTexture.rect(x, y, textureBlockSize, textureBlockSize);
      wallTexture.endDraw();
    }
  }
  
  // Start the game
  switchGameState(new GameStartState());
}

void draw() {
  currentGameState.updateState();
}


void keyPressed() {
  
  //Start or restart game when Enter is pressed
  if (key == ENTER && (currentGameState instanceof GameStartState || currentGameState instanceof GameEndState)) {
    switchGameState(new GamePlayingState());
  }
  
  //Maps QWERTY to answer No - while interacting with NPCs
  if (currentGameState instanceof GamePlayingState && waitingForPlayerNoInput) {
    int optionIndex = -1;
    if (key == 'q' || key == 'Q') optionIndex = 0;
    else if (key == 'w' || key == 'W') optionIndex = 1;
    else if (key == 'e' || key == 'E') optionIndex = 2;
    else if (key == 'r' || key == 'R') optionIndex = 3;
    else if (key == 't' || key == 'T') optionIndex = 4;
    else if (key == 'y' || key == 'Y') optionIndex = 5;
    
    if (optionIndex != -1){
      HandleNoAnswer(optionIndex);
    }
  }
}

void mousePressed() {
  //Only allowing click to move during gameplay (player)
  if (!(currentGameState instanceof GamePlayingState)) {
    return;
  }

  int tileX = floor(mouseX/tileSize);
  int tileY = floor(mouseY/tileSize);

  //To ignore clicks outside the grid
  if (tileX<0 || tileX>= cols || tileY< 0 || tileY>= rows) {
    return;
  }
  
  //To get clicked tiles and ignore the walls
  int tile_index = (tileY * cols) + tileX;
  Node end = graph.nodes.get(tile_index);
  if (end.block) {
    return;
  }
  
  Node start = mainCharacter.getTile();

  // visualize start/end
  start.visit();
  end.path();
  
  //Using A* path to the clicked tile and start executing it
  mainPathToFollow = graph.astar(start, end);
  mainCharacter.segment = 0;
}

//returns a room index that corresponds with the passed in tile
int GetRoomAtTile(PVector tile_center){
  int room_index_at_tile = -1;
 
  for(int i=0; i< rooms.size(); i++){
    RoomInformation room = rooms.get(i);
    if(tile_center.x >= room.min_x && tile_center.x <= room.max_x && tile_center.y >= room.min_y && tile_center.y <= room.max_y)
    {
      room_index_at_tile = i;
      break;
    }
  }
  
  return room_index_at_tile;
}

//returns a random room that is different from the one that is passed in
RoomInformation GeRandomRoom(int curr_room){

  int room_index = curr_room;
  
  while(room_index == curr_room){
    room_index = int(random(0, rooms.size()));
  }
  
  return rooms.get(room_index);
}

//setter
void setPlayerFollowing(boolean is_following){
  npc_following_player = is_following;
}

void switchPlayerState(PlayerState state) {
  if (playerState != null && mainCharacter != null) {
    playerState.exit(mainCharacter);
  }
  playerState = state;
  if (playerState != null && mainCharacter != null) {
    playerState.enter(mainCharacter);
  }
}

//Player to able to click on white/walkable path
boolean isWalkableAt(int x, int y) {
  if (!(currentGameState instanceof GamePlayingState) || graph == null) {
    return false;
  }
  if (x<0 || x>= width || y<0 || y>height){
  return false;
  }
  int tileX = floor(x/tileSize);
  int tileY = floor(y/tileSize);
  if (tileX < 0 || tileX >= cols || tileY < 0 || tileY >= rows) {
    return false;
  }
  int tile_index = (tileY * cols) + tileX;
  Node node = graph.nodes.get(tile_index);
  return !node.block;
}

//Switching cursor for players to only able to click on the white tiles
void updateCursorForWalkable() {
  if (isWalkableAt(mouseX, mouseY)) {
    cursor(HAND);
  } else {
    cursor(ARROW);
  }
}

//displays the question panel
void DisplayNoPanelWithRandomQuestion()
{
  if(!(currentGameState instanceof GamePlayingState))
    return;
  waitingForPlayerNoInput = true;
  dialogue.showDialogueBox();
  dialogue.randomiseQuestion();
}

//hides the question panel
void HideNoPanelWithRandomQuestion()
{
  waitingForPlayerNoInput = false;
  dialogue.hideDialogueBox();
}

void HandleNoAnswer(int optionIndex) {
  if (!waitingForPlayerNoInput) {
    return;
  }
  //To ignore choices that aren't unlocked yet
  if (optionIndex > dialogue.getUnlockedNum()) {
    return;
  }
  
  //Only unlock the next No if player chose the latest unlocked option
  if (optionIndex == dialogue.getUnlockedNum()) {
    dialogue.unlockNext();
  }
  HideNoPanelWithRandomQuestion();
}

//resets the timer
void resetTime(){
  start_time = millis();
  time_elapsed = 0;
}

//switches game state
void switchGameState(GameState state) {
  currentGameState = state;
  state.enterState();
}

//removes an NPC from the npc count tracker
void decrementNPCCount(){
  npcsLeft--;
}

void destroyWalls(){
  // Switches to player end state and game end state then destroys the walls
  switchPlayerState(new PlayerEndingState());
  switchGameState(new GameEndState());
}
