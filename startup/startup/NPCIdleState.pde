class NPCIdleState extends NPCState {
  
  // Path to follow
  ArrayList<Edge> pathToFollow;

  void enterState(NPC npc) {
    println("Entered NPCIdleState state");
    npc.canMove = false;
    switchPlayerState(new PlayerInteractingState());
    DisplayNoPanelWithRandomQuestion();
  }
  
  void updateState(NPC npc) {
    imageMode(CENTER);
    image(npc.idle_anim, npc.location.x, npc.location.y, tileSize, tileSize);
    imageMode(CORNER);
    //exit idle state once player has selected a no
    if(!waitingForPlayerNoInput)
      npc.switchState(new NPCGoToNewRoomState());
  }

  
}
