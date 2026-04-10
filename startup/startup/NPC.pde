class NPC extends Character{
  
  int currentRoomIndex;
  RoomInformation room;
  NPCState currentState;
  boolean is_dead;
  boolean readyToExplode;
  
  NPC(int roomIndex, RoomInformation room, PVector spawnLocation) {
    super(npc_idle_gif, npc_walking_gif, spawnLocation, false, tileSize);
    this.room = room;
    
    //init varaibles
    is_dead = false;
    readyToExplode = true;
    currentRoomIndex = roomIndex;
    
    //set current state
    currentState = new NPCWanderState();
    currentState.enterState(this);
  }
  
  //updates NPC display, movement and state loop
  void updateNPC()
  {
    super.update();
    super.display();
    currentState.updateState(this);
  }
  
  //swicth state
  void switchState(NPCState state) {
    currentState = state;
    state.enterState(this);
  }
  
  //returns force to avoid the walls
  PVector avoidWall(){
    float wanderDist = NPC_WALL_AVOID_RADIUS; 

    PVector prediction = velocity.copy();
    prediction.normalize();
    prediction.mult(wanderDist);
    prediction.add(location);
    
    if(checkRoomEdges(prediction.x, prediction.y)){
      return flee(prediction);
    }
    
    return new PVector(0,0);
  }
  
  //check if the npc is too close to the walls of their assigned room
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
  
  //used to avoid walls
  PVector flee(PVector target) {
    PVector steer = seek(target);
    steer.mult(-1);
    return steer;
  }
  
  //used to seperate NPCS from eachother
  PVector separate(float desiredseparation) {
    PVector velocity_sum = new PVector(0,0);
    
    int counter = 0;
    
    //loop through the living NPCs and seperate from them
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
  
  //check if the NPC is near the player
  boolean CheckIfNearPlayer() {
    float distance = PVector.sub(mainCharacter.location, location).mag();;
    if(distance < NEAR_PLAYER_RADIUS)
      return true;
    return false;
  }
}
