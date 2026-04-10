class NPCGoToNewRoomState extends NPCState {
  // Path to follow
  ArrayList<Edge> pathToFollow;
  int starting_room_index;

  void enterState(NPC npc) {
    println("Entered NPCGoToNewRoomState state");
    npc.canMove = true;
    
    
    starting_room_index = GetRoomAtTile(npc.getTile().getTileCenter());
    npc.room = null;

    if(npc.readyToExplode)
    {
       npc.room = GeRandomRoom(starting_room_index);
       npc.topspeed = 2;
    } else {
      npc.topspeed = 0.5;
      if(starting_room_index == -1)
      {
        npc.room = GeRandomRoom(starting_room_index);
      } else 
        npc.room = rooms.get(starting_room_index);
    }
    createFollowPath(npc);
    print(time_elapsed);
    
    setPlayerFollowing(false);
    resetTime();
  }
  
  void updateState(NPC npc) {
    imageMode(CENTER);
    image(npc.walking_anim, npc.location.x, npc.location.y, tileSize, tileSize);
    imageMode(CORNER); 
    
    if(npc.readyToExplode)
      goToNewRoomAndExplode(npc);
    else
      goToNewRoomAndWander(npc);
    
  }
  
  void goToNewRoomAndWander(NPC npc){
    if(npc.CheckIfNearPlayer() && !waitingForPlayerNoInput){
      npc.switchState(new NPCIdleState());
    }
    else if(npc.stopped()) {
       npc.switchState(new WanderState());
    }
    else
      npc.followAStarPath(pathToFollow, tileSize);
  }
  
  void goToNewRoomAndExplode(NPC npc){
    //explode npc after 1 second
    if(time_elapsed > 1000){
      npc.is_dead = true;
      decrementNPCCount();
      ps.setPosition(npc.location);
      ps.isActive = true;  
      npcGoneTime = millis();
    }
    else
      npc.followAStarPath(pathToFollow, tileSize);
  }
  
  void createFollowPath(NPC npc){
    Node start = npc.getTile();
    
    Node end = graph.getTileAtLocation(random(npc.room.min_x+NPC_HALF_WIDTH, npc.room.max_x-NPC_HALF_WIDTH), random(npc.room.min_y+NPC_HALF_HEIGHT, npc.room.max_y-NPC_HALF_HEIGHT));

    ArrayList<Edge> path = graph.astar(start, end);
    
    pathToFollow = path;
    npc.segment = 0;
  }

}
