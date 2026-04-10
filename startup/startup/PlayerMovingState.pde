class PlayerMovingState extends PlayerState {
  void enter(Character player) {
    player.canMove = true;
  }

  void update(Character player) {
    //Follow A* path when clicked
    if (mainPathToFollow != null && mainPathToFollow.size() > 0) {
      player.followAStarPath(mainPathToFollow, tileSize);
    }
    player.update();
  }
}
