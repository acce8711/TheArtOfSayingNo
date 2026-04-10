class NPCGoToNewRoomState extends NPCState {
  // Path to follow
  ArrayList<Edge> pathToFollow;

  void enterState(NPC npc) {
    println("Entered NPCGoToNewRoomState state");
    npc.canMove = true;
    
    
    int curr_room_index = GetRoomAtTile(npc.getTile().getTileCenter());
    npc.room = GeRandomRoom(curr_room_index);
    createFollowPath(npc);
    print(time_elapsed);
    npc.topspeed = 2;
    
    setPlayerFollowing(false);
    resetTime();
  }
  
  void updateState(NPC npc) {
    imageMode(CENTER);
    image(npc.walking_anim, npc.location.x, npc.location.y, tileSize, tileSize);
    imageMode(CORNER);
        
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
    
    Node end = graph.getTileAtLocation(random(npc.room.min_x, npc.room.max_x), random(npc.room.min_y, npc.room.max_y));

    ArrayList<Edge> path = graph.astar(start, end);
    
    pathToFollow = path;
    npc.segment = 0;
  }

}
