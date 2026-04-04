class NPC extends Character{
  
  int currentRoomIndex;
  RoomInformation room;
  NPCState currentState;
  boolean is_dead;
  
  NPC(int roomIndex, RoomInformation room, PVector spawnLocation) {
    super(loadImage("npc_placeholder.png"), spawnLocation);
    currentState = new WanderState();
    currentState.enterState(this);
    currentRoomIndex = roomIndex;
    is_dead = false;
    this.room = room;
  }
  
  void switchState(NPCState state) {
    currentState = state;
    state.enterState(this);
  }
  
  PVector avoidWall(){
    float wanderDist = 10; 
    float change = 0.3;

    PVector prediction = velocity.copy();
    prediction.normalize();
    prediction.mult(wanderDist);
    prediction.add(location);
    
    if(checkRoomEdges(prediction.x, prediction.y)){
      return flee(prediction);
    }
    
    return new PVector(0,0);
  }
  
    //this is an overide method of the one in the character class
  void updateNPC()
  {
    super.update();
    
    currentState.updateState(this);
 }
  
  boolean checkRoomEdges(float location_x, float location_y) {
    
    if (location_x - NPC_HALF_WIDTH <= room.min_x) {
      return true;
    } else if (location_x + NPC_HALF_WIDTH > room.max_x) {
      return true;
    }
    
    if (location_y - NPC_HALF_HEIGHT <= room.min_y) {
      return true;
    } else if (location_y + NPC_HALF_HEIGHT > room.max_y) {
      return true;
    }
    
    return false;
  }
  
  PVector flee(PVector target) {
    PVector steer = seek(target);
    steer.mult(-1);
    return steer;
  }
  
  PVector separate(float desiredseparation) {
    PVector velocity_sum = new PVector(0,0);
    
    int counter = 0;
    
    for (NPC npc : npcs) {
      if(npc.is_dead)
        continue;
      float distance = PVector.dist(location, npc.location);
      
      if(distance < desiredseparation && distance > 0) {
        PVector desired = PVector.sub(location, npc.location);
        desired.normalize();
        velocity_sum.add(desired);
        counter++;
      }
    }
    
    if (counter > 0) {
      velocity_sum.div(counter);
      velocity_sum.normalize();
      velocity_sum.mult(topspeed);
      PVector steer = PVector.sub(velocity_sum, velocity);
      steer.limit(maxforce);
      
      return steer;
    }
    
    return new PVector(0,0);
  }
  
  boolean CheckIfNearPlayer() {
    float distance = PVector.sub(mainCharacter.location, location).mag();;
    if(distance < NEAR_PLAYER_RADIUS)
      return true;
    return false;
  }
}
