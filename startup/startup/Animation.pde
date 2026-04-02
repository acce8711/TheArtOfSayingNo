// Class for animating a sequence of GIFs
// Credit to James Paterson, example from Processing.org with some manual modifications

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  int startTime = 0;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 1) + ".png";
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos) {
    if (startTime == 0) {
      startTime = millis();
    }
    int timeElapsed = millis() - startTime;
    if (timeElapsed > 1000) {
      frame = (frame+1) % imageCount;
      image(images[frame], xpos, ypos);
      timeElapsed = 0;
      println(timeElapsed > 1000);
    }
    println(timeElapsed);
  }
  
  int getWidth() {
    return images[0].width;
  }
}
