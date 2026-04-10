class GameEndState extends GameState {
  MapErosion mapErosion;
  int endTime;

  void enterState() {
    println("Entered GameEndState state");
    //Display start screen
    image(generatedMap, 0, 0);
    delay(10);
    mapErosion = new MapErosion();
    
    endTime = millis();
  }
  
  void updateState() {
    background(255);
    mapErosion.drawGrid();
    
    if (millis() - endTime > 600) {
      endTime = millis();
      mapErosion.iterate();
    }
    
    if (playerState != null) {
      playerState.update(mainCharacter);
    } else {
      mainCharacter.update();
    }
    mainCharacter.display();
  }
 
}
