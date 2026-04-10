class NPCWanderState extends NPCState {
  float time_before_targeting;
  
  void enterState(NPC npc) {
    println("Entered Wander state");
    
    time_before_targeting = random(2000,3000);
    
    //animation change to walking
    npc.setIsIdle(false);
  }
  
  void updateState(NPC npc) {
    
    //if the npc is near the player and another npc is not currently interacting with the player then ask the player a question
    if(npc.CheckIfNearPlayer() && !waitingForPlayerNoInput)
    {
      setPlayerFollowing(false);
      waitingForPlayerNoInput = true;
      npc.switchState(new NPCIdleState());
    } 
    //if no npc is following the player and no npc is asking the player 
    else if(!npc_following_player && !waitingForPlayerNoInput && time_elapsed >= time_before_targeting)
    {
      setPlayerFollowing(true);
      resetTime();
      npc.switchState(new NPCTargetState());
    } 
    //wander within the assigned room and avoid walls
    else {
      PVector wanderForce = npc.wander();
      PVector avoidForce = npc.avoidWall();
      PVector seperateForce = npc.separate(50);
      npc.applyForce(wanderForce);
      npc.applyForce(seperateForce);
      npc.applyForce(avoidForce.mult(100));
    }
  }
  
}
