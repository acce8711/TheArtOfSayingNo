//class displays start screen

class GameStartState extends GameState {
  void enterState() {
    println("Entered GameStartState state");
    background(255);
  }
  
  void updateState() {
     // Display the title screen GIF
     image(title_load_gif, 120,0);
     // After the GIF is done playing, display the enter text
     if (!title_load_gif.isPlaying()) {
       fill(0);
       textFont(dialogue_font);
       text("PRESS ENTER TO START", width - 420, height - 30);
     }
  }
 
}
