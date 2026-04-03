class Dialogue {

  int w = width;
  int h;
  int padding = 20;
  int unlockedNum = 0;
  String question = "";
  boolean isVisible = true;
  int numQuestions;
  
  StringList questions;
  
  Dialogue(int new_height) {
    h = new_height;
    
    questions = new StringList();
    questions.append("WANNA HANGOUT?");
    questions.append("WANNA BE FRIENDS?");
    questions.append("HEY? WANNA GO OUT WITH ME?");
    questions.append("HOW ARE YOU?");
    questions.append("ARE YOU FREE RIGHT NOW?");
    questions.append("CAN YOU DO MY HOMEWORK?");
    questions.append("CAN YOU WORK OVERTIME?");
    questions.append("CAN YOU TAKE OVER? I NEED TO LEAVE.");
    questions.append("ARE YOU OKAY?");
    questions.append("WANNA JOIN ME?");
    questions.append("HEY. WE SHOULD TOTALLY HANGOUT?");
    questions.append("HEY! ARE YOU FREE THIS WEEKEND?");
    questions.append("HEY! CAN I BORROW MONEY?");
    questions.append("CAN YOU COME TO MY PARTY?");
    questions.append("CAN I BORROW YOUR CAR?");
    questions.append("CAN I PLAY GAMES ON YOUR PHONE?");
    questions.append("CAN YOU WORK MY SHIFT FOR ME?");
    questions.append("CAN YOU SAVE MY SPOT IN LINE?");
    questions.append("CAN YOU DO MY CHORES FOR ME?");
    questions.append("CAN YOU DO MY HOMEWORK? I'M BUSY.");
    questions.append("WOULD YOU LIKE TO GO ON A DATE?");
    
    numQuestions = questions.size();
    
    // Get and set initial random question
    question = questions.get(int (random(0, numQuestions)));
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
  
  void toggleVisibility() {
    isVisible = !isVisible;
  }
  
  void setQuestion (int idx) {
    if (idx >= numQuestions) {
      println("Out of bounds! We don't have that many questions...");
      return;
    }
    question = questions.get(idx);
  }
  
  void randomiseQuestion() {
    question = questions.get(int (random(0, numQuestions)));
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
    
    text("No, sorry", width - buttons_w_text_ref_img.width + 10, height - buttons_w_text_ref_img.height + 10);
    text("No thanks", width - buttons_w_text_ref_img.width + 120, height - buttons_w_text_ref_img.height + 10);
    text("No.", width - buttons_w_text_ref_img.width + 263, height - buttons_w_text_ref_img.height + 10);
    text("No!", width - buttons_w_text_ref_img.width + 375, height - buttons_w_text_ref_img.height + 10);
    text("hell NO", width - buttons_w_text_ref_img.width + 475, height - buttons_w_text_ref_img.height + 10);
    text("FUCK NO", width - buttons_w_text_ref_img.width + 585, height - buttons_w_text_ref_img.height + 10);

    popMatrix();
  }
}
