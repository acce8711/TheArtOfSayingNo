import java.util.Iterator;
// Global variables
Graph graph = new Graph();
int cols, rows;
int tileSize;
boolean npc_following_player;


// Map image
PImage map;
ArrayList<NPC> npcs;
Character mainCharacter;

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
  
  map = loadImage("demo-map.png");
  image(map,0,0, width, height);
  
  

  tileSize = 25;
  cols = width/tileSize;
  rows = height/tileSize;
  
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
    npc.updateNPC();
  }
  mainCharacter.display();
  
  time_elapsed = millis() - start_time;
}


void setPlayerFollowingAndResetTime(){
  npc_following_player = true;
  start_time = millis();
  time_elapsed = 0;
}
