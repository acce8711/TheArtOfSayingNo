class TargetState extends NPC_State {
  
  // Path to follow
  ArrayList<Edge> pathToFollow;

  void enterState(NPC npc) {
    println("Entered Target state");
    createFollowPath(npc);
  }
  
  void updateState(NPC npc) {
    if(npc.CheckIfNearPlayer()){
      //npc.switchState(new NPCIdleState());
      npc.switchState(new NPCGoToNewRoomState());
    }
    else if(time_elapsed >= 1000) {
      createFollowPath(npc);
      start_time = millis();
      time_elapsed = 0;
    }
    npc.followAStarPath(pathToFollow, tileSize);

  }
  
  void createFollowPath(NPC npc){
    Node start = npc.getTile(); //<>//
    
    Node end = mainCharacter.getTile();
    
    //// purely to visualize start and end points
    start.visit();
    end.path();
    
    ArrayList<Edge> path = graph.astar(start, end);
    
    //npc.location = start.getTileCenter();
    pathToFollow = path;
    npc.segment = 0;
  }
  
}
