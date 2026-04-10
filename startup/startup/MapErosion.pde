// code based on the cellular automata course content with modifications to fit this project's use case

class MapErosion {
  int[][] grid;
  int cols, rows;
  int tileSize;
  
  MapErosion() {
    tileSize = 40;
    cols = width/tileSize;
    rows = height/tileSize;
    grid = new int[cols][rows];
    
    // Iterate over each grid block
    // Check if sampled color for each block is dark enough to be considered a wall/black tile or a bright floor/white tile
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        color c = get(x * tileSize, y * tileSize);
        float brightness = brightness(c);
        if (brightness <= 100) {
          grid[x][y] = 0;
        } else {
          grid[x][y] = 255;
        }
      }
    }
    
    drawGrid();
  }
  
  boolean hasBlackTiles() {
    // Initially, set that there are no black tiles
    boolean hasBlackTile = false;
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        color c = get(x * tileSize, y * tileSize);
        float brightness = brightness(c);
        // If the current tile's brightness is lower than 100, consider it a black tile and set hasBlackTile to true
        if (brightness <= 100) {
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
          // If value is 255, it is a white or floor textured tile
          image(floorTexture, x * tileSize, y * tileSize, tileSize, tileSize);
        } else if (grid[x][y] == 0) {
          // If the value is 0, it is a black or wall textured tile
          fill(color(grid[x][y]));
          image(wallTexture, x * tileSize, y * tileSize, tileSize, tileSize);
        }
      }
    }
  }
  
  void iterate() {
    // Performs the CA algorithm once then draws the updated grid
    grid = runCA();
    drawGrid();
  }
  
  int[][] runCA() {
    int[][] tempGrid = new int[cols][rows];
    
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
                  count++;
                }
              } 
            } else {
              count++;
            }
          }
        }

        // If at least one neighbour is a white/floor tile, there is a chance for the current block to turn into a white/floor tile
        if (count >= 1) {
          // Generate a random value to make the erosion randomised so the tiles don't dissolve uniformly
          float rand = random(0,1);
          // If the random value is below 0.6 and the current block isn't already white, make it black
          if (rand < 0.6 && grid[x][y] != 255) {
            tempGrid[x][y] = 0;
          } else {
            // Else the block will be a white/floor tile
            tempGrid[x][y] = 255;
          }
        }     
      }
    
    }
    return tempGrid;
  }
  
  // Checks if the grid block is within the grid (not out of bounds)
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
