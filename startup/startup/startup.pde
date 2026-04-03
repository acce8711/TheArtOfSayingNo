import java.util.Iterator;
import gifAnimation.*;

// Global variables
Graph graph = new Graph();
int cols, rows;
int tileSize;
boolean npc_following_player;
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

//
PImage car_img;

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

int start_time;
int time_elapsed;

int max_npcs;

ArrayList<RoomInformation> rooms;

final int MIN_NPCS_IN_ROOM = 2;
final int MAX_NPCS_IN_ROOM = 4;

final int NPC_HALF_WIDTH = 20;
final int NPC_HALF_HEIGHT = 20;

final int NEAR_PLAYER_RADIUS = 40;

void setup() {
  
  pixelDensity(1);
  size(900,600);
  
  // Load images
  map = loadImage("demo-map.png");
  image(map,0,0, width, height);
  
  buttons_w_text_ref_img = loadImage("options-6.png");
  buttons_img = loadImage("options-buttons.png");
  car_img = loadImage("ccar.png");
  
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
  tileSize = 25;
  cols = width/tileSize;
  rows = height/tileSize;
  
  // Dialogue setup
  dialogue = new Dialogue(160);
  
  npc_following_player = false;
  start_time = millis();

  graph = new Graph();
  graph.initialize(width, height, tileSize);
  
    for (Node n : graph.nodes) {
    PVector loc = n.getTileCenter();
    if (get(int(loc.x), int(loc.y)) == color(0,0,0)) {
      n.block();
      n.fillcolor = color(0, 255 ,0);
    } else {
      n.fillcolor = color(255);
    } 
  }
  graph.handleBlockedNodes();
  
  rooms = new ArrayList<RoomInformation>();
  //top left room
  rooms.add(new RoomInformation(275, 525, 50, 175));
  //top right room
  rooms.add(new RoomInformation(600, 725, 100, 225));
  //middle left room
  rooms.add(new RoomInformation(75, 275, 225, 350));
  //middle room
  rooms.add(new RoomInformation(375, 500, 250, 350));
  //middle right room
  rooms.add(new RoomInformation(600, 750, 275, 450));
  //bottom middle room
  rooms.add(new RoomInformation(225, 575, 400, 550));
  
  //spawn character
  mainCharacter = new Character(loadImage("cat_food_sprite.png"), new PVector(random(rooms.get(0).min_x + NPC_HALF_WIDTH, rooms.get(0).max_x - NPC_HALF_WIDTH), 
                                                                              random(rooms.get(0).min_y + NPC_HALF_HEIGHT, rooms.get(0).max_y - NPC_HALF_HEIGHT)));
  
  npcs = new ArrayList<NPC>();
  //loop through rooms except for starter room
  for(int i = 1; i<rooms.size(); i++){
    //add npcs to each room
    int numNPCsToSpawn = int(random(MIN_NPCS_IN_ROOM, MAX_NPCS_IN_ROOM));
    for(int j = 0; j < numNPCsToSpawn; j++){
      npcs.add(new NPC(i, rooms.get(i), new PVector(random(rooms.get(i).min_x + NPC_HALF_WIDTH, rooms.get(i).max_x - NPC_HALF_WIDTH), 
                                                    random(rooms.get(i).min_y + NPC_HALF_HEIGHT, rooms.get(i).max_y - NPC_HALF_HEIGHT))));
    }
    
    
  }

}

void draw() {
  for (Node n : graph.nodes) {
    n.display();
  }
  for (NPC npc : npcs){
    if(!npc.is_dead)
      npc.updateNPC();
  }
  mainCharacter.display();
  
  time_elapsed = millis() - start_time;
  
  dialogue.display();
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

void keyPressed () {
  if (key == ' ') {
    dialogue.toggleVisibility();
  }
  if (key == 'v') {
    dialogue.randomiseQuestion();
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

void setPlayerFollowing(boolean is_following){
  npc_following_player = is_following;
}

void resetTime(){
  start_time = millis();
  time_elapsed = 0;
}
