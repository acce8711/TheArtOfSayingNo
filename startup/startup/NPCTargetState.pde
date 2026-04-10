class NPCTargetState extends NPCState {
  
  // Path to follow
  ArrayList<Edge> pathToFollow;

  void enterState(NPC npc) {
    println("Entered Target state");
    
    npc.topspeed = NPC_MEDIUM_SPEED;
    createFollowPath(npc);
   
    //animation change to walking
    npc.setIsIdle(false);
  }
  
  void updateState(NPC npc) {
    //if nps is not supposed to be following teh player anymore then make it go to a new room and wander there
    if(!npc_following_player) {
       npc.readyToExplode = false;
       npc.switchState(new NPCGoToNewRoomState());
    }
    //if the npc has reached the player then entr idle state and ask a question
    else if(npc.CheckIfNearPlayer() ){
      npc.switchState(new NPCIdleState());
    }
    //update the path every second
    else if(time_elapsed >= 1000) {
      createFollowPath(npc);
      resetTime();
    }
    npc.followAStarPath(pathToFollow, tileSize);
  }
  
  //create a path from the npc to the character
  void createFollowPath(NPC npc){
    Node start = npc.getTile();
    
    Node end = mainCharacter.getTile();
    
    start.visit();
    end.path();
    
    ArrayList<Edge> path = graph.astar(start, end);
    
    pathToFollow = path;
    npc.segment = 0;
  }
  
}
