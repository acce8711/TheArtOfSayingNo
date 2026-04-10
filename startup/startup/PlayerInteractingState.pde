class PlayerInteractingState extends PlayerState {
  void enter(Character player) {
    player.canMove = false;
    player.velocity.mult(0);
    player.acceleration.mult(0);
    mainPathToFollow = null;
    DisplayNoPanelWithRandomQuestion();
  }

  void update(Character player) {
    if (!waitingForPlayerNoInput) {
      switchPlayerState(new PlayerMovingState());
    }
  }
}
