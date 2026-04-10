//class handles the game end logic

class GameEndState extends GameState {
  MapErosion mapErosion;
  int endTime;

  void enterState() {
    println("Entered GameEndState state");
    // Display the generated map that contains floor and wall textures
    image(generatedMap, 0, 0);
    delay(10);
    // Instantiate map erosion object
    mapErosion = new MapErosion();
    
    // Change the character animations to the flexing GIF
    mainCharacter.idle_anim = mc_flex_gif;
    mainCharacter.walking_anim = mc_flex_gif;
    
    // Set the endTime to current time
    endTime = millis();
  }
  
  void updateState() {
    // Draw the map erosion grid
    background(255);
    mapErosion.drawGrid();
    
    // Every 600 milliseconds, if there are black tiles remaining in the map erosion grid then run the cellular automata iteration then reset the timer
    if (millis() - endTime > 600) {
      if (mapErosion.hasBlackTiles()) {
          endTime = millis();
          mapErosion.iterate();
      }
    }
    
    // Once the map erosion grid has no more black tiles, the timer will keep going instead of being reset every 600ms
    // Once it reaches 1000ms past the last map erosion iteration, display the play again text
    if (millis() - endTime > 1000) {
       fill(0);
       textFont(dialogue_font);
       text("PRESS ENTER TO SAY NO AGAIN", width/2 - 250, height - 30);
    }
    
    // Display the player character
    if (playerState != null) {
      playerState.update(mainCharacter);
    } else {
      mainCharacter.update();
    }
    mainCharacter.display();
  }
 
}
