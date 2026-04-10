//Freeze player when game ends
class PlayerEndingState extends PlayerState {
  void enter(Character player) {
    player.canMove = false;
    mainPathToFollow = null;
  }

  void update(Character player) {}
}
