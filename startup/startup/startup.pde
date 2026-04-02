import java.util.Iterator;
import gifAnimation.*;

// Global variables
Graph graph = new Graph();
int cols, rows;
int tileSize;
float increment = 0.01;
float zoff = 0.0;
float xoff = 0.0;
float yoff = 0.0;
float zincrement = 0.02;

// Path to follow
ArrayList<Edge> pathToFollow;

// Images
PImage map;
PImage npc;
PImage qButton;
PImage wannaHangout;

//Animations
Animation mc_gif;
Gif idle_gif;
Gif npc_idle_gif;
Gif npc_walking_gif;
Gif title_load_gif;
Gif title_enter_gif;

//Font
PFont bigFont;
PFont smallFont;

boolean loading = true;
boolean titleEnter = false;

void setup() {
  
  pixelDensity(1);
  size(1280,900);
  frameRate(30);
  
  //Load images
  map = loadImage("demo-map.png");
  image(map,0,0, width, height);
  npc = loadImage("npc.png");
  qButton = loadImage("qbutton.png");
  wannaHangout = loadImage("wanna-hangout.png");
  
  // Load GIFs
  idle_gif = new Gif(this, "idle.gif");
  idle_gif.loop();
  
  npc_idle_gif = new Gif(this, "npc-idle.gif");
  npc_idle_gif.loop();
  
  npc_walking_gif = new Gif(this, "npc-walking.gif");
  npc_walking_gif.loop();
  
  title_load_gif = new Gif(this, "title-load.gif");
  title_load_gif.ignoreRepeat();
  title_load_gif.play();
  title_enter_gif = new Gif(this, "title-enter.gif");
  title_enter_gif.loop();
  
  // Font setup
  bigFont = createFont("Ithaca-LVB75.ttf", 60);
  smallFont = createFont("Ithaca-LVB75.ttf", 36);
  textFont(bigFont);
  
  // Tile map setup
  tileSize = 50;
  cols = width/tileSize;
  rows = height/tileSize;
  
  // create an empty path to follow
  // this has to be a global variable 
  // so we can recall it in the draw method
  pathToFollow = new ArrayList<Edge>();
}

void draw() {
  background(255);
  if (!title_load_gif.isPlaying()) {
    loading = false;
  } else {
  }
  if (!loading) {
    image(title_enter_gif, 0,0);
  } else {
    image(title_load_gif, 0,0);
  }
  
  for (Node n : graph.nodes) {
    n.display();
  }


  //image(idle_gif, 550, 390);
  //image(npc_idle_gif, 250, 390);
  //image(wannaHangout, 0, height-200, 1280, 200);
  //image(npc_walking_gif, 250, 390, tileSize, tileSize);
  
  //fill(255);
  //rect(0, height-200, width, 200);
  //fill(0);
  //textFont(bigFont);
  //text("HEYYYY BESTIE! CAN YOU DO MY HOMEWORK?", 170, height-120);
  //image(npc, -20, height-220, 200, 200);
  //textFont(smallFont);
  //text("no", width-195, height-60);
  //image(qButton, width-200, height-50, 40, 40);
  
}

void keyPressed() { 
  if (key == 'r') {
    for (Node node: graph.nodes) {
      if (node.block) {
        node.explode(noise(xoff, yoff) * 255);
      }
    }
  }
  if (keyCode == ENTER) {
    if (!loading) {
      initializeGraph();
      print("hey!");
    }
  }
}

void initializeGraph () {
  image(map,0,0, width, height);
  graph = new Graph();
  graph.initialize(width, height, tileSize);
  
  for (Node n : graph.nodes) {
    PVector loc = n.getTileCenter();
    if (get(int(loc.x), int(loc.y)) == color(0,0,0)) {
      n.block();
    } else {
      n.fillcolor = color(255);
    } 
  }
}
