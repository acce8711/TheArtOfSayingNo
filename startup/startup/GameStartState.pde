class GameStartState extends GameState {
  boolean loaded = false;

  void enterState() {
    println("Entered GameStartState state");
    //Display start screen
    background(255);
  }
  
  void updateState() {     
     if (!title_load_gif.isPlaying()) {
       loaded = true;
     }
     
     if (!loaded) {
       image(title_load_gif, 0,0);
     } else {
       image(title_enter_gif, 0, 0);
     }
  }
 
}
