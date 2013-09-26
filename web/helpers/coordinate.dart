/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

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
    }else if( deltaX == 0 && deltaY.floor() == -1){
      return DOWN; //face up
    }else if( deltaX.ceil() == 1 && deltaY == 0){
      return LEFT; //face left
    }else if( deltaX.floor() == -1 && deltaY == 0){
      return RIGHT; //face right
    }/*else if(deltaX.ceil() == 1 && deltaY.ceil() == 1){
      return UP;
    }else if(deltaX.floor() == -1 && deltaY.floor() == -1){
      return DOWN;
    }else if(deltaX.ceil() == 1 && deltaY.floor() == -1){
      return LEFT;
    }else if(deltaX.floor() == -1 && deltaY.ceil() == 1){
      return RIGHT;
    }*/
    
    return -1;
  }

}