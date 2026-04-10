class MapErosion {
  int[][] grid;
  int cols, rows;
  int tileSize;
  
  final color WHITE = color(255,255,255);
  final color BLACK = color(0,0,0);
  //PImage map;
  
  MapErosion() {
  
    size(1280, 720);
    pixelDensity(1);
    
    tileSize = 40;
    cols = width/tileSize;
    rows = height/tileSize;
    grid = new int[cols][rows];
    
    //image(map, 0, 0);
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        color c = get(x * tileSize, y * tileSize);
        if (c == BLACK) {
          grid[x][y] = 0;
        } else if (c == WHITE) {
          grid[x][y] = 255;
        }
      }
    }
    
    //for (int i = 0; i < 15; i++) {
    //  grid = runCA();
    //}
    drawGrid();
  }
  
  boolean hasBlackTiles() {
    boolean hasBlackTile = false;
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        color c = get(x * tileSize, y * tileSize);
        if (c == BLACK) {
          hasBlackTile = true;
        }
      }
    }
    return hasBlackTile;
  }
  
  void drawGrid() {
    rectMode(CORNER);
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        if (grid[x][y] == 255) {
          image(floorTexture, x * tileSize, y * tileSize, tileSize, tileSize);
          continue;
        } else if (grid[x][y] == 0) {
          fill(color(grid[x][y]));
          //rect(x*tileSize, y*tileSize, tileSize, tileSize);
          image(wallTexture, x * tileSize, y * tileSize, tileSize, tileSize);
        }
      }
    }
  }
  
  void iterate() {
    grid = runCA();
    drawGrid();
  }
  
  int[][] runCA() {
  
    int[][] tempGrid = new int[cols][rows];
    //for (int x = 0; x < cols; x++) {
    //  for (int y = 0; y < rows; y++) {
    //    if (grid[x][y] == 255) {
    //      tempGrid[x][y] = 0;
    //    } else {
    //      tempGrid[x][y] = 255;
    //    }
    //  }
    //}
    
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        int count = 0;
  
        for (int i = -1; i < 2; i++) {
          for (int j = -1; j < 2; j++) {
            int newX = x + i;
            int newY = y + j;
            
            if (inTheGrid(newX, newY)) {
              if (!((i == 0) && (j == 0))) {
                if (grid[newX][newY] == 255){
                //  print(" " + grid[x][y] + " ");
                  count++;
                }
              } 
            } else {
              count++;
            }
          }
        }
        //print(" " + count + " ");
        //if (x == 0 || y == 0 || x == rows -1 || y == cols - 1) {
        //  continue;
        //}
        if (count >= 1) {
          float rand = random(0,1);
          tempGrid[x][y] = 255;
          if (rand < 0.5 && grid[x][y] != 255) {
            tempGrid[x][y] = 0;
          } else {
            tempGrid[x][y] = 255;
          }
        }     
      }
    
    }
    return tempGrid;
  }
  
  boolean inTheGrid(int x, int y) {
    if ((x < 0) || (x >= cols)) {
      return false;
    }
    if ((y < 0) || (y >= rows)) {
      return false;
    }
    return true;
  }
}
