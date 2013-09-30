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
  
  bool nextToThis(int face, Coordinate coor){
    num deltaX = ((coor.x - x)/TILE_SIZE);
    num deltaY = ((coor.y - y)/TILE_SIZE);
    
    if( deltaX == 0 && deltaY.ceil() == 1 && face == UP){
      return true;
    }else if( deltaX == 0 && deltaY.round() == -1 && face == DOWN){
      return true;
    }else if( deltaX.ceil() == 1 && deltaY == 0 && face == LEFT){
      return true; 
    }else if( deltaX.round() == -1 && deltaY == 0 &&face == RIGHT){
      return true;
    }
    
    return false;
  }
  
  int facingThis(int face, Coordinate coor){
    num deltaX = ((coor.x - x)/TILE_SIZE);
    num deltaY = ((coor.y - y)/TILE_SIZE);
    
    if( deltaX == 0 && deltaY.ceil() == 1 && face == UP){
      return DOWN; //face down
    }else if( deltaX == 0 && deltaY.round() == -1 && face == DOWN){
      return UP; //face up
    }else if( deltaX.ceil() == 1 && deltaY == 0 && face == LEFT){
      return RIGHT; //face left
    }else if( deltaX.round() == -1 && deltaY == 0 && face == RIGHT){
      return LEFT; //face right
    }
    
    return -1;
  }

}