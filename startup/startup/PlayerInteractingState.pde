class PlayerInteractingState extends PlayerState {
  //Stop player to show dialogue/interact with NPC
  void enter(Character player) {
    player.canMove = false;
    player.velocity.mult(0);
    player.acceleration.mult(0);
    mainPathToFollow = null;
    DisplayNoPanelWithRandomQuestion();
    player.setIsIdle(true);
  }

//Return to moving once interaction is done
  void update(Character player) {
    if (!waitingForPlayerNoInput) {
      switchPlayerState(new PlayerMovingState());
    }
  }
}
