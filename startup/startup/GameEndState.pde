class GameEndState extends GameState {
  

  void enterState() {
    println("Entered GameEndState state");
    //Display start screen
    background(0);
  }
  
  void updateState() {
    background(0);
    image(generatedMap, 0,0);
  }
 
}
