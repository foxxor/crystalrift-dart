/*
  Copyright (C) 2015 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library mapEvent;

import 'dart:html';
import '../core/tile.dart';
import '../helpers/matrix.dart';
import '../helpers/coordinate.dart';
import '../core/globals.dart';

class MapEvent{
  int type;
  Coordinate currentPosition;
  Coordinate currentPositionPx;
  Coordinate graphicPosition;
  String imageSource;
  String name;
  
  MapEvent(int type, int x, int y, int imgX, int imgY, String imageSource, String name){
    this.type = type;
    this.currentPositionPx = new Coordinate(x * TILE_SIZE, y * TILE_SIZE);
    this.currentPosition = new Coordinate(x, y);
    this.graphicPosition = new Coordinate(imgX, imgY);
    this.imageSource = imageSource;
    this.name = name;
  }
}