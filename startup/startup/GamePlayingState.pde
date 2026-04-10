//class handles logic when the gameplay starts

class GamePlayingState extends GameState {  
  void enterState() {
    println("Entered GamePlayingState state");
    npc_following_player = false;
    waitingForPlayerNoInput = false;
    start_time = millis();
    
    //display map
    image(map,0,0, width, height);
   
    //init particle system
    ps = new ParticleSystem(new PVector(width/2,height/2));
    
    //create graph
    graph = new Graph();
    graph.initialize(width, height, tileSize);
    
    //set the graph nodes to be blocked (walls) or not (floor) based on the displayed map image
    for (Node n : graph.nodes) {
      PVector loc = n.getTileCenter();
      if (get(int(loc.x), int(loc.y)) == color(0,0,0)) {
        n.block();
        n.fillcolor = color(0, 0, 0);
      } else {
        n.fillcolor = color(255);
      } 
    }
    graph.handleBlockedNodes();
    
    // Save generated tilemap to image
    for (Node n : graph.nodes) {
      n.display();
    }
    generatedMap = get();
    
    //store information about room boundaries
    rooms = new ArrayList<RoomInformation>();
    //top left room
    rooms.add(new RoomInformation(0, 80, 360, 40, 200));
    //top right room
    rooms.add(new RoomInformation(1, 480, 720, 160, 320));
    //middle left room
    rooms.add(new RoomInformation(2, 840, 1080, 120, 280));
    //middle room
    rooms.add(new RoomInformation(3, 120, 280, 320, 520));
    //middle right room
    rooms.add(new RoomInformation(4, 400, 800, 400, 560));
    //bottom middle room
    rooms.add(new RoomInformation(5, 880, 1080, 360, 560));
    
    //spawn character
    mainCharacter = new Character(mc_idle_gif, mc_walking_gif, new PVector(random(rooms.get(0).min_x + NPC_HALF_WIDTH, rooms.get(0).max_x - NPC_HALF_WIDTH), 
                                                                                random(rooms.get(0).min_y + NPC_HALF_HEIGHT, rooms.get(0).max_y - NPC_HALF_HEIGHT)), true, tileSize+15);                                                                           
    mainCharacter.topspeed = 1.5;
    mainCharacter.maxforce = 0.15;
    mainPathToFollow = null;
    switchPlayerState(new PlayerMovingState());
    
    //create npcs
    npcs = new ArrayList<NPC>();
    //loop through rooms except for starter room
    for(int i = 1; i<rooms.size(); i++){
      //add npcs to each room
      int numNPCsToSpawn = int(random(MIN_NPCS_IN_ROOM, MAX_NPCS_IN_ROOM));
      for(int j = 0; j < numNPCsToSpawn; j++){
        NPC npc_to_add = new NPC(i, rooms.get(i), new PVector(random(rooms.get(i).min_x + NPC_HALF_WIDTH, rooms.get(i).max_x - NPC_HALF_WIDTH), 
                                                      random(rooms.get(i).min_y + NPC_HALF_HEIGHT, rooms.get(i).max_y - NPC_HALF_HEIGHT)));
        npcs.add(npc_to_add);
        npc_to_add.maxforce = 0.15;
        npcsLeft++;
      }
    }
    
    //hide dialogue panel by default
    HideNoPanelWithRandomQuestion();
    dialogue.setUnlockedNum(0);
  }
  
  void updateState() {
    updateCursorForWalkable();
    
    //update graph
    for (Node n : graph.nodes) {
      n.display();
    }
    //update npcs
    for (NPC npc : npcs){
      if(!npc.is_dead)
        npc.updateNPC();
    }
    //update player
    if (playerState != null) {
      playerState.update(mainCharacter);
    } else {
      mainCharacter.update();
    }
    mainCharacter.display();
    
    time_elapsed = millis() - start_time;
    
    // Update particles and add them while under the limit and while actively adding
    if (ps.particles.size() < 40 && ps.isActive == true) {
      ps.addParticle();
      
      // Set particle system's isActive to false after reaching limit to stop adding particles
      if (ps.particles.size() > 39)
        ps.isActive = false;
    }
    
    // Update particle system
    ps.run();
        
    //destroy the walls if all the npcs are gone
    if(npcsLeft == 0) {
      int endDelayTime = millis() - npc_gone_time;
      
      // After 2 seconds of all npcs being gone, call destroy walls to transition to end game state and start the map deteriotation
      if (endDelayTime > 2000) {
        destroyWalls();
      }
    }

    // Display dialogue box
    stroke(0);
    fill(0);
    dialogue.display();
  }
  
}
