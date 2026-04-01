import java.util.Iterator;

// Global variables
Graph graph = new Graph();
int cols, rows;
int tileSize;

// Path to follow
ArrayList<Edge> pathToFollow;

// Map image
PImage map;

void setup() {
  
  pixelDensity(1);
  size(900,600);
  
  map = loadImage("demo-map.png");
  image(map,0,0, width, height);

  tileSize = 50;
  cols = width/tileSize;
  rows = height/tileSize;
  
  //createGraph(cols, rows);
  
  // create an empty path to follow
  // this has to be a global variable 
  // so we can recall it in the draw method
  pathToFollow = new ArrayList<Edge>();
  
  graph = new Graph();
  graph.initialize(width, height, 10);
  
    for (Node n : graph.nodes) {
    PVector loc = n.getTileCenter();
    if (get(int(loc.x), int(loc.y)) == color(0,0,0)) {
      n.block();
    } else {
      n.fillcolor = color(255);
    } 
  }
}

void draw() {
  for (Node n : graph.nodes) {
    n.display();
  }
  noLoop();
}
