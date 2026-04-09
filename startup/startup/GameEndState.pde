class GameEndState extends GameState {

  void enterState() {
    println("Entered GameEndState state");
    //Display start screen
    background(0);
    
    me = new MapErosion();
  }
  
  void updateState() {
    for (Node n : graph.nodes) {
      n.display();
    }
    me.drawGrid();
  }
}
