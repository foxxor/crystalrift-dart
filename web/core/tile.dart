/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library tile;

import 'dart:html';
import 'globals.dart';

class Tile {
  int xImg;
  int yImg;
  int type;
  
  Tile(int x, int y, [int type=TILE_SOIL]){
    this.xImg = x * TILE_SIZE;
    this.yImg = y * TILE_SIZE;
    this.type = type;
  }
}