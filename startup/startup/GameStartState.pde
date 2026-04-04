class GameStartState extends GameState {
  void enterState() {
    println("Entered GameStartState state");
    //Display start screen
    background(255);
  }
  
  void updateState() {
     image(title_load_gif, 120,0);
     if (!title_load_gif.isPlaying()) {
       fill(0);
       textFont(dialogue_font);
       text("PRESS ENTER TO START", width - 420, height - 30);
     }
  }
 
}
