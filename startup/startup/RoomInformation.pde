//class contains index and boundary information about the room
class RoomInformation {
  int room_index;
  int min_x;
  int max_x;
  int min_y;
  int max_y;
  
  RoomInformation(int room_index, int min_x, int max_x, int min_y, int max_y){
    this.room_index = room_index;
    this.min_x = min_x;
    this.max_x = max_x;
    this.min_y = min_y;
    this.max_y = max_y;
  }
}
