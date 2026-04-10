class NPCGoToNewRoomState extends NPCState {

  ArrayList<Edge> pathToFollow;
  int starting_room_index;

  void enterState(NPC npc) {
    println("Entered NPCGoToNewRoomState state");
    
    npc.canMove = true;
    setPlayerFollowing(false);
    resetTime();
    
    //update animation to walking
    npc.setIsIdle(false);
    
    //get the room index that the npc is currently in
    starting_room_index = GetRoomAtTile(npc.getTile().getTileCenter());
    npc.room = null;

    //if the npc is ready to explode then select a target room and make them run
    if(npc.readyToExplode)
    {
       npc.room = GeRandomRoom(starting_room_index);
       npc.topspeed = NPC_FAST_SPEED;
    //if the npc is not ready to explode then keep them in the same room or to the first room if they're currently in the hallway
    } else {
      npc.topspeed = NPC_SLOW_SPEED;
      if(starting_room_index >= 0)
      {
        print("room index: ", starting_room_index);
        npc.room = rooms.get(starting_room_index);}
      else {
        npc.room = rooms.get(0);
      }
    }
    
    //create A* path
    createFollowPath(npc);
  }
  
  void updateState(NPC npc) {
    //if ready to explode then go to a new room and explode
    if(npc.readyToExplode)
      goToNewRoomAndExplode(npc);
    //if not ready to explode then go to a room and wander
    else
      goToRoomAndWander(npc);
  }
  
  void goToRoomAndWander(NPC npc){
    //if while going to a new room, npc collides with the player then they can ask them a question
    if(npc.CheckIfNearPlayer() && !waitingForPlayerNoInput){
      npc.switchState(new NPCIdleState());
    }
    //if the npc has reached the target or they are already in a room then enter wander state
    else if(npc.stopped() || starting_room_index != -1) {
       npc.switchState(new NPCWanderState());
    }
    //if the path A* to the target room is valid then keep following it
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
      npc_gone_time = millis();
    }
    
    //if a second has not passed then keep following the A* path
    else if(pathToFollow != null && pathToFollow.size() > 0)
      npc.followAStarPath(pathToFollow, tileSize);
  }
  
  //generate a A* path to the assigned NPC room
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
