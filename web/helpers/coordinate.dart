/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library coordinate;

import '../core/globals.dart';
import 'dart:math' as Math;

class Coordinate {
  num x;
  num y;
  
  Coordinate(num xi, num yi){
    this.x = xi;
    this.y = yi;
  }
  
  bool nextToThis(int face, Coordinate coor){
    num deltaX = coor.x - x;
    num deltaY = coor.y - y;
    
    if( deltaX == 0 && deltaY.ceil() == 1 && face == UP){
      return true;
    }else if( deltaX == 0 && deltaY.round() == -1 && face == DOWN){
      return true;
    }else if( deltaX.ceil() == 1 && deltaY == 0 && face == LEFT){
      return true; 
    }else if( deltaX.round() == -1 && deltaY == 0 && face == RIGHT){
      return true;
    }
    return false;
  }
  
  bool nextToThis2(Coordinate newCoord){
    if( newCoord.x == x && newCoord.y == y){
      return true;
    }
    return false;
  }
  
  num distanceToThis(Coordinate c){
    return (x- c.x).abs() + (y-c.y).abs();
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
  
  bool isTheSame(Coordinate c){
    if(c.x == x && c.y == y){
      return true;
    }
    return false;
  }

}