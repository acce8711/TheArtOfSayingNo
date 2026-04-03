class GamePlayingState extends GameState {
  void enterState() {
    println("Entered GamePlayingState state");
    npc_following_player = false;
    waitingForPlayerNoInput = false;
    start_time = millis();
    image(map,0,0, width, height);
  
    //create graph
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
    
    //cerate rooms
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
    //create npcs
    npcs = new ArrayList<NPC>();
    //loop through rooms except for starter room
    for(int i = 1; i<rooms.size(); i++){
      //add npcs to each room
      int numNPCsToSpawn = int(random(MIN_NPCS_IN_ROOM, MAX_NPCS_IN_ROOM));
      for(int j = 0; j < numNPCsToSpawn; j++){
        npcs.add(new NPC(i, rooms.get(i), new PVector(random(rooms.get(i).min_x + NPC_HALF_WIDTH, rooms.get(i).max_x - NPC_HALF_WIDTH), 
                                                      random(rooms.get(i).min_y + NPC_HALF_HEIGHT, rooms.get(i).max_y - NPC_HALF_HEIGHT))));
        npcsLeft++;
      }
    }
    
    //hide dialogue panel by default
    HideNoPanelWithRandomQuestion();
  }
  
  
  void updateState() {
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
  
}
