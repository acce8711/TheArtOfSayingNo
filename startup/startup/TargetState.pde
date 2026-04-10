class TargetState extends NPCState {
  
  // Path to follow
  ArrayList<Edge> pathToFollow;

  void enterState(NPC npc) {
    println("Entered Target state");
    createFollowPath(npc);
    npc.topspeed = 1.5;
  }
  
  void updateState(NPC npc) {
    imageMode(CENTER);
    image(npc.walking_anim, npc.location.x, npc.location.y, tileSize, tileSize);
    imageMode(CORNER);
    
    if(!npc_following_player) {
       npc.readyToExplode = false;
       npc.switchState(new NPCGoToNewRoomState());
    }
    else if(npc.CheckIfNearPlayer() ){
      npc.switchState(new NPCIdleState());
    }
    else if(time_elapsed >= 1000) {
      createFollowPath(npc);
      start_time = millis();
      time_elapsed = 0;
    }
    npc.followAStarPath(pathToFollow, tileSize);
    
   

  }
  
  void createFollowPath(NPC npc){
    Node start = npc.getTile(); //<>// //<>//
    
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
