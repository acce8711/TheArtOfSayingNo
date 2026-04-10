import gifAnimation.*;

//code taken from course content

class Character {
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  
  float mass = 1;
  float maxforce = 0.05;
  
  float wanderAngle = 0;
  
  color fillcolor;
  
  int segment;
  
  float characterSize;
  
  Gif idle_anim;
  Gif walking_anim;
  
  boolean canMove;
  boolean idle;

  Character(Gif new_idle_anim, Gif new_walking_anim, PVector startPos, boolean is_idle, float mCharacterSize) {
    
    location = startPos;
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    topspeed = 0.5;
    idle_anim = new_idle_anim;
    walking_anim = new_walking_anim;
    canMove = true;
    idle = is_idle;
    characterSize = mCharacterSize;
  }
  
  
  void followAStarPath(ArrayList<Edge> pathToFollow, float tileSize) {
  
  if (segment < pathToFollow.size()) {
    Edge currentEdge = pathToFollow.get(segment);
    
    if (segment == pathToFollow.size() - 1) {
      PVector steering = arrive(currentEdge.endNode.getTileCenter(), 25f);
      this.applyForce(steering);
    } else {
      Node endNode = currentEdge.endNode;
      int endNodePosTileCell = floor(endNode.getTileCenter().x/tileSize) + floor(endNode.getTileCenter().y/tileSize);
      int charPosTileCell = floor(this.location.x/tileSize) + floor(this.location.y/tileSize);
      
      if (endNodePosTileCell == charPosTileCell) {
        segment++;
      } else {
        PVector steering = seek(currentEdge.endNode.getTileCenter());
        this.applyForce(steering);
      }
    }
  }
  }
  
  /**
  Display character
  **/
  void display() {
    
    imageMode(CENTER);
    if(idle)
      image(idle_anim, location.x, location.y - 10, characterSize, characterSize);
    else
      image(walking_anim, location.x, location.y - 10, characterSize, characterSize);
    imageMode(CORNER);

  }
  
  void setIsIdle(boolean isIdle){
    idle = isIdle;
  }
  
  /*
  Wrap edges
  */
  void checkEdges() {
    
    if (location.x >= width) {
      location.x = 0;
    } else if (location.x < 0) {
      location.x = width-1;
    }
    
    if (location.y >= height) {
      location.y = 0;
    } else if (location.y < 0) {
      location.y = height-1;
    }
    
  }

  /*
  Apply steering force
  */
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  /*
  Update character's physics
  */
  void update() {
    
    if(!canMove){
      return;
    }
    velocity.add(acceleration);
    velocity.limit(topspeed);
    
    location.add(velocity);
    acceleration.mult(0);
    
  }


  /* 
  Seek steering behaviour
  */
  PVector seek(PVector target) {
    
    PVector desired = PVector.sub(target,location);
    desired.normalize();
    desired.mult(topspeed);
    
    PVector steer = PVector.sub(desired,velocity);
    
    steer.limit(maxforce);
    return steer;
    
  }
  
  /*
  Wander steering behaviour
  */
  PVector wander() {
  
    float wanderRadius = 25;         // Radius for our "wander circle"
    float wanderDist = 80;         // Distance for our "wander circle"
    float change = 0.3;

    PVector prediction = velocity.copy();
    prediction.normalize();
    prediction.mult(wanderDist);
    prediction.add(location);
    
    
    wanderAngle += random(-change, change);
    
    float currentDirection = atan2(velocity.y, velocity.x);
    float newDirection = currentDirection + wanderAngle;
    
    float x = wanderRadius * cos(newDirection);
    float y = wanderRadius * sin(newDirection);
    
    PVector targetOffset = new PVector(x, y);
    PVector target = PVector.add(prediction, targetOffset);
    
    return seek(target);
  }
  
  /*
  Arrive steering behaviour
  */
  PVector arrive(PVector target, float r) {
    PVector desired = PVector.sub(target,location);
    float distance = desired.mag();
    desired.normalize();
    
    if (distance < r) {
      // map the speed by the distance from the target
      float speed = (distance/r) * topspeed;
      desired.mult(speed);
    } else {
      desired.mult(topspeed);
    }
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
    
  }
  
  /**
  Get the tile the character is on
  */
  Node getTile() {
    int tileX = floor(location.x/tileSize);
    int tileY = floor(location.y/tileSize);
    
    int tile_index = (tileY * cols) + (tileX);
    
    graph.nodes.get(tile_index).highlight();
    return graph.nodes.get(tile_index);
    
  }
  
  /*
  Test if the character has stopped moving
  */
  boolean stopped() {
    return (velocity.mag() < 0.01);
  }
}
