class NPCIdleState extends NPCState {
  
  ArrayList<Edge> pathToFollow;

  void enterState(NPC npc) {
    println("Entered NPCIdleState state");
   
    //logic changes
    npc.canMove = false;
    switchPlayerState(new PlayerInteractingState());
    setPlayerFollowing(false);
    
    //visual changes
    DisplayNoPanelWithRandomQuestion();
    npc.setIsIdle(true);
  }
  
  void updateState(NPC npc) {
    //exit idle state once player has selected a no and run away to a new room
    if(!waitingForPlayerNoInput){
      npc.readyToExplode = true;
      npc.switchState(new NPCGoToNewRoomState());
    }
  }

}
