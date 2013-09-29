/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library coordinate;

import '../core/globals.dart';

class Coordinate {
  int x;
  int y;
  
  Coordinate(int xi, int yi){
    this.x = xi;
    this.y = yi;
  }
  
  int nextToThis(Coordinate coor){
    num deltaX = ((coor.x - x)/TILE_SIZE);
    num deltaY = ((coor.y - y)/TILE_SIZE);
    
    if( deltaX == 0 && deltaY.ceil() == 1){
      return UP; //face down
    }else if( deltaX == 0 && deltaY.round() == -1){
      return DOWN; //face up
    }else if( deltaX.ceil() == 1 && deltaY == 0){
      return LEFT; //face left
    }else if( deltaX.round() == -1 && deltaY == 0){
      return RIGHT; //face right
    }
    
    return -1;
  }
  
  bool facingThis(int face, Coordinate coor){
    num deltaX = ((coor.x - x)/TILE_SIZE);
    num deltaY = ((coor.y - y)/TILE_SIZE);
    
    if( deltaX == 0 && deltaY.ceil() == 1 && face == UP){
      return true; //face down
    }else if( deltaX == 0 && deltaY.round() == -1 && face == DOWN){
      return true; //face up
    }else if( deltaX.ceil() == 1 && deltaY == 0 && face == LEFT){
      return true; //face left
    }else if( deltaX.round() == -1 && deltaY == 0 && face == RIGHT){
      return true; //face right
    }
    
    return false;
  }

}