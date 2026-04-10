import java.util.Iterator;
import gifAnimation.*;

// Global variables
Graph graph = new Graph();
int cols, rows;
int tileSize;
boolean npc_following_player;
boolean waitingForPlayerNoInput;
Dialogue dialogue;

// Map image
PImage map;
ArrayList<NPC> npcs;
Character mainCharacter;

// Images
PImage npc_dialogue_img;

// "No" option images
PImage option_1_img;
PImage option_2_img;
PImage option_3_img;
PImage option_4_img;
PImage option_5_img;
PImage buttons_w_text_ref_img;
PImage buttons_img;

// Fonts
PFont dialogue_font;
PFont actions_font;

// Animations
Gif mc_idle_gif;
Gif mc_walking_gif;
Gif npc_idle_gif;
Gif npc_walking_gif;
Gif title_load_gif;
Gif title_enter_gif;

// Perlin and textures
Perlin perlin;
PGraphics floorTexture;
PGraphics wallTexture;

// Explosion particle system
ParticleSystem ps;

int start_time;
int time_elapsed;
int npcGoneTime;

int max_npcs;

int npcsLeft;

ArrayList<RoomInformation> rooms;

final int MIN_NPCS_IN_ROOM = 0;
final int MAX_NPCS_IN_ROOM = 2;

final int NPC_HALF_WIDTH = 20;
final int NPC_HALF_HEIGHT = 20;

final int NEAR_PLAYER_RADIUS = 40;

GameState currentGameState;

void setup() {

  pixelDensity(1);
  size(1280, 720);

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

  // Dialogue setup
  dialogue = new Dialogue(160);

  int textureBlockSize = 4;
  perlin = new Perlin(500);
  floorTexture = createGraphics(tileSize, tileSize);
  wallTexture = createGraphics(tileSize, tileSize);

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
  switchGameState(new GameStartState());
}

void draw() {
  currentGameState.updateState();
}


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

RoomInformation GeRandomRoom(int curr_room){
  int room_index = curr_room;
  while(room_index == curr_room){
    room_index = int(random(0, rooms.size()));
  }
  
  return rooms.get(room_index);
}

void setPlayerFollowing(boolean is_following){
  npc_following_player = is_following;
}

void keyPressed() {
  
  if (key == ENTER && (currentGameState instanceof GameStartState || currentGameState instanceof GameEndState)) {
    switchGameState(new GamePlayingState());
  }
  
  //this is a temporary space key that hides the "no" panel and continues the game
  if ((key == 'q' || key == 'Q') && currentGameState instanceof GamePlayingState && waitingForPlayerNoInput)
  {
    HideNoPanelWithRandomQuestion();
  }
  
  if (key == '0') {
    dialogue.setUnlockedNum(0);
  }
  if (key == '1') {
    dialogue.setUnlockedNum(1);
  }
  if (key == '2') {
      dialogue.setUnlockedNum(2);
  }
  if (key == '3') {
      dialogue.setUnlockedNum(3);
  }
  if (key == '4') {
      dialogue.setUnlockedNum(4);
  }
  if (key == '5') {
    dialogue.setUnlockedNum(5);
  }
}

void DisplayNoPanelWithRandomQuestion()
{
  if(!(currentGameState instanceof GamePlayingState))
    return;
  waitingForPlayerNoInput = true;
  dialogue.showDialogueBox();
  dialogue.randomiseQuestion();
}

void HideNoPanelWithRandomQuestion()
{
  waitingForPlayerNoInput = false;
  dialogue.hideDialogueBox();
}

void resetTime(){
  start_time = millis();
  time_elapsed = 0;
}

void switchGameState(GameState state) {
  currentGameState = state;
  state.enterState();
}

void decrementNPCCount(){
  npcsLeft--;
}

void destroyWalls(){
  //to do: add the room destroying effects
  switchGameState(new GameEndState());
}
