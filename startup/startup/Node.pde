//class taken from course code
class Node {
  
  int id;
  
  String name;
  ArrayList<Edge> edges;
  PVector position;
  float size;
  
  boolean block;
  int fillcolor = 255;
  
  Node(String n, ArrayList<Edge> e, float x, float y, float mSize) {
    name = n;
    edges = e;
    
    position = new PVector(x, y);
    size = mSize;
  }
  
  void display() {
    rectMode(CORNER);
    fill(fillcolor);
    if (!block) {
      image(floorTexture, position.x, position.y, size, size);
    } else {
      image(wallTexture, position.x, position.y, size, size);
    }
  }
  
  void showEdges() {
    fill(0,0,255);
    rect(position.x, position.y, size, size);
    println("Node: " + this.id);
    int count = 0;
    for (Edge e : edges) {
     
      fill(150,150,255);
      rect(e.endNode.position.x, e.endNode.position.y, size, size);  
      println("Edge end node: " + count + ", Node ID: " + e.endNode.id);
      count++;
    }
    fill(fillcolor);
  }
  
  boolean inBounds(float x, float y) {
    if (((x > position.x) && (x < position.x + size)) && ((y > position.y) && (y < position.y + size))) {
      return true;
    }
    return false;
  }
  
  void block() {
    block = true;
    fillcolor = 0;
  }
  
  void unblock() {
    block = false;
    fillcolor = 255;
  }
  
  void highlight() {
    fillcolor = color(255,150,150);
  }
  
  void visit() {
    fillcolor = color(255,0,0);
  }
  
  void path() {
    fillcolor = color(0,255,0);
  }
  
  void reset() {
    if (!block)
      fillcolor = 255;
  }
  
  PVector getTileCenter() {
    return new PVector(position.x + size/2, position.y + size/2);
  }
  
}
