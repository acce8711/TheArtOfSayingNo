class NPCIdleState extends NPC_State {
  
  // Path to follow
  ArrayList<Edge> pathToFollow;

  void enterState(NPC npc) {
    println("Entered NPCIdleState state");
    npc.canMove = false;
  }
  
  void updateState(NPC npc) {
  }

  
}
