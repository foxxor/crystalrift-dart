import 'globals.dart';

class Coordinate {
  int x;
  int y;
  
  Coordinate(int xi, int yi){
    this.x = xi;
    this.y = yi;
  }
  
  int nextToThis(Coordinate coor){
    int deltaX = coor.x - x;
    int deltaY = coor.y - y;
    if( deltaX == 0 && deltaY == 1){
      return UP; //face down
    }else if( deltaX == 0 && deltaY == -1){
      return DOWN; //face up
    }else if( deltaX == 1 && deltaY == 0){
      return LEFT; //face left
    }else if( deltaX == -1 && deltaY == 0){
      return RIGHT; //face right
    }
    
    return -1;
  }

}