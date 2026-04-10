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
      if(starting_room_index >= 0)
      {
        print("room index: ", starting_room_index);
        npc.room = rooms.get(starting_room_index);}
      else {
        npc.room = rooms.get(0);
      }
    }
    createFollowPath(npc);
    print(time_elapsed);
    
    setPlayerFollowing(false);
    resetTime();
    npc.setIsIdle(false);
  }
  
  void updateState(NPC npc) {
    //imageMode(CENTER);
    //image(npc.walking_anim, npc.location.x, npc.location.y, tileSize, tileSize);
    //imageMode(CORNER); 
    
    if(npc.readyToExplode)
      goToNewRoomAndExplode(npc);
    else
      goToNewRoomAndWander(npc);
    
  }
  
  void goToNewRoomAndWander(NPC npc){
    if(npc.CheckIfNearPlayer() && !waitingForPlayerNoInput){
      npc.switchState(new NPCIdleState());
    }
    else if(npc.stopped() || starting_room_index != -1) {
       npc.switchState(new NPCWanderState());
    }
    else if(pathToFollow != null && pathToFollow.size() > 0)
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
    else if(pathToFollow != null && pathToFollow.size() > 0)
      npc.followAStarPath(pathToFollow, tileSize);
  }
  
  void createFollowPath(NPC npc){
    Node start = npc.getTile();
    
    Node end = null;
    while (end == null)  
      end = graph.getTileAtLocation((npc.room.min_x + npc.room.max_x)/2, (npc.room.min_y + npc.room.max_y)/2);

    ArrayList<Edge> path = graph.astar(start, end);
    
    pathToFollow = path;
    npc.segment = 0;
  }

}
