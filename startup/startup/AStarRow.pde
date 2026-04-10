//code taken from course content

class AStarRow {
  
  Edge best;
  Node toa;
  
  float g;
  float h;
  float f;
  
  AStarRow(Node t, Edge b, float gN, float hN, float fN) {
    toa = t;
    best = b;
    
    g = gN;
    h = hN;
    f = fN;
  }
}
