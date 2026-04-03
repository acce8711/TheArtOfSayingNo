class Dialogue {

  int w = width;
  int h;
  int padding = 20;
  int unlockedNum = 0;
  String question = "";
  boolean isVisible = true;
  
  Dialogue(int new_height) {
    h = new_height;
  }
  
  void setUnlockedNum(int num) {
    unlockedNum = num;
  }
  
  void setQuestionText(String str) {
    question = str;
  }
  
  void hideDialogueBox() {
    isVisible = false;
  }
  
  void showDialogueBox() {
    isVisible = true;
  }
  
  void display() {
    if (!isVisible) {
      return;
    }
    
    fill(255);
    // White box
    rect(0, height-h, width, h);
    
    // NPC GIF
    image(npc_idle_gif, 50, height - h);
    
    // Dialogue
    //image(car_img, npc_idle_gif.width + 80, height - h + padding);
    
    textFont(dialogue_font);
    fill(0);
    text(question, 170, height - h + 50);
    
    textFont(actions_font);
    
    pushMatrix();
    
    int shiftForward = 0;
    
    // "No" reply options
    switch (unlockedNum) {
      case 0: shiftForward = 560;
        break;
      case 1: shiftForward = 440;
        break;
      case 2: shiftForward = 350;
        break;
      case 3: shiftForward = 230;
        break;
      case 4: shiftForward = 100;
        break;
      case 5: shiftForward = 0;
    }
    
    translate(shiftForward, 0);
    
    image(buttons_img, width - buttons_img.width - padding * 2, height - buttons_img.height - padding);
    
    text("No, sorry", width - option_6_img.width + 10, height - option_6_img.height + 10);
    text("No thanks", width - option_6_img.width + 120, height - option_6_img.height + 10);
    text("No.", width - option_6_img.width + 263, height - option_6_img.height + 10);
    text("No!", width - option_6_img.width + 375, height - option_6_img.height + 10);
    text("hell NO", width - option_6_img.width + 475, height - option_6_img.height + 10);
    text("FUCK NO", width - option_6_img.width + 585, height - option_6_img.height + 10);

    

    popMatrix();
  }
}
