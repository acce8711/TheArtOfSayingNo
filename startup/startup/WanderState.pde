class WanderState extends NPCState {
  
  float time_before_target;
  void enterState(NPC npc) {
    println("Entered Wander state");
    time_before_target = random(2000,3000);
  }
  
  void updateState(NPC npc) {
    if(!npc_following_player && time_elapsed >= time_before_target)
    {
      setPlayerFollowing(true);
      resetTime();
      npc.switchState(new TargetState());
    } else {
      //wander within the room and avoid the walls
      PVector wanderForce = npc.wander();
      PVector avoidForce = npc.avoidWall();
      PVector seperateForce = npc.separate(30);
      npc.applyForce(wanderForce);
      npc.applyForce(seperateForce);
      npc.applyForce(avoidForce.mult(100));
    }
  }
  
}
