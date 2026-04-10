class NPCWanderState extends NPCState {
  
  float time_before_target;
  void enterState(NPC npc) {
    println("Entered Wander state");
    time_before_target = random(2000,3000);
    npc.setIsIdle(false);
  }
  
  void updateState(NPC npc) {
    //imageMode(CENTER);
    //image(npc.walking_anim, npc.location.x, npc.location.y, tileSize, tileSize);
    //imageMode(CORNER);
    
    if(npc.CheckIfNearPlayer() && !waitingForPlayerNoInput)
    {
      setPlayerFollowing(false);
      //targeting_npc_index = npc.index;
      waitingForPlayerNoInput = true;
      npc.switchState(new NPCIdleState());
    } 
    else if(!npc_following_player && !waitingForPlayerNoInput && time_elapsed >= time_before_target)
    {
      setPlayerFollowing(true);
      resetTime();
      //targeting_npc_index = npc.index;
      npc.switchState(new TargetState());
      print(npc.index);
    } 
    else {
      //wander within the room and avoid the walls
      PVector wanderForce = npc.wander();
      PVector avoidForce = npc.avoidWall();
      PVector seperateForce = npc.separate(50);
      npc.applyForce(wanderForce);
      npc.applyForce(seperateForce);
      npc.applyForce(avoidForce.mult(100));
    }
  }
  
}
