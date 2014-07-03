/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library tile;

import 'globals.dart';

class Tile {
  int xImg;
  int yImg;
  int type;
  int x;
  int y;
  
  Tile(int x, int y, [int type=TILE_SOIL]){
    this.xImg = x * TILE_SIZE;
    this.yImg = y * TILE_SIZE;
    this.x = x;
    this.y = y;
    this.type = type;
  }
  
  //Method to serialize a matrix in something dart understands 
  Map toJson() { 
    Map map = new Map();
    map['type'] = this.type;
    map['x'] = this.x;
    map['y'] = this.y;
    return map;
  }
}