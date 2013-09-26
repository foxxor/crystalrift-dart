/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'globals.dart';

class Tile {
  int xImg;
  int yImg;
  bool soil;
  
  Tile(int x, int y, [bool soil=false]){
    this.xImg = x * TILE_SIZE;
    this.yImg = y * TILE_SIZE;
    this.soil = soil;
  }
}