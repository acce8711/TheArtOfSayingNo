class NPCIdleState extends NPCState {
  
  // Path to follow
  ArrayList<Edge> pathToFollow;

  void enterState(NPC npc) {
    println("Entered NPCIdleState state");
    npc.canMove = false;
    DisplayNoPanelWithRandomQuestion();
  }
  
  void updateState(NPC npc) {
    //exit idle state once player has selected a no
    if(!waitingForPlayerNoInput)
      npc.switchState(new NPCGoToNewRoomState());
  }

  
}
