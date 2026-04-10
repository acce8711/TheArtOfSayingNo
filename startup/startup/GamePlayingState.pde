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
    
    //init particle system
    ps = new ParticleSystem(new PVector(width/2,height/2));
    
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
    
    //cerate rooms
    rooms = new ArrayList<RoomInformation>();
    //top left room
    rooms.add(new RoomInformation(80, 380, 60, 260));
    //top right room
    rooms.add(new RoomInformation(480, 700, 180, 300));
    //middle left room
    rooms.add(new RoomInformation(840, 1100, 80, 260));
    //middle room
    rooms.add(new RoomInformation(120, 300, 300, 540));
    //middle right room
    rooms.add(new RoomInformation(380, 800, 380, 560));
    //bottom middle room
    rooms.add(new RoomInformation(900, 1100, 340, 540));
    
    //spawn character
    mainCharacter = new Character(mc_idle_gif, mc_walking_gif, new PVector(random(rooms.get(0).min_x + NPC_HALF_WIDTH, rooms.get(0).max_x - NPC_HALF_WIDTH), 
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
    image(map,0,0, width, height);
    for (Node n : graph.nodes) {
      n.display();
    }
    for (NPC npc : npcs){
      if(!npc.is_dead)
        npc.updateNPC();
    }
    mainCharacter.display();
    
    time_elapsed = millis() - start_time;
    
    if (ps.particles.size() < 40 && ps.isActive == true) {
      ps.addParticle();
      
      if (ps.particles.size() > 39)
        ps.isActive = false;
    }
    
    ps.run();
        
    if(npcsLeft == 0) {
      int endDelayTime = millis() - npcGoneTime;
      println(endDelayTime);
    }
    
    
    
    stroke(0);
    fill(0);
    dialogue.display();
  }
  
}
