//class handles the game end logic

class GameEndState extends GameState {
  MapErosion mapErosion;
  int endTime;
  int playAgainDelayTime;

  void enterState() {
    println("Entered GameEndState state");
    
    image(generatedMap, 0, 0);
    delay(10);
    mapErosion = new MapErosion();
    
    mainCharacter.idle_anim = mc_flex_gif;
    mainCharacter.walking_anim = mc_flex_gif;
    
    endTime = millis();
    playAgainDelayTime = millis();
  }
  
  void updateState() {
    background(255);
    mapErosion.drawGrid();
    
    if (millis() - endTime > 600) {
      if (mapErosion.hasBlackTiles()) {
          endTime = millis();
          mapErosion.iterate();
      }
    }
    
    if (millis() - endTime > 1000) {
       fill(0);
       textFont(dialogue_font);
       text("PRESS ENTER TO SAY NO AGAIN", width/2 - 250, height - 30);
    }
    
    if (playerState != null) {
      playerState.update(mainCharacter);
    } else {
      mainCharacter.update();
    }
    mainCharacter.display();
  }
 
}
