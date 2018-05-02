/*
  Copyright (C) 2015 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library mapEvent;

import 'dart:html' hide Matrix;
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
  
  MapEvent(int type, int x, int y, String name){
    this.type = type;
    this.currentPositionPx = new Coordinate(x * TILE_SIZE, y * TILE_SIZE);
    this.currentPosition = new Coordinate(x, y);
    this.name = name;
  }
  
  void initGraphic(int imgX, int imgY, String imageSource){
    this.graphicPosition = new Coordinate(imgX, imgY);
    this.imageSource = imageSource;
  }
  
  String mapNameRender(){
    String text = "";
    if(this.type == EVENT_TYPE_STARTING_POINT){
      text = "Starting point";
    }else if(this.type == EVENT_TYPE_CHARACTER){
      text = "Character";
    }else if(this.type == EVENT_TYPE_ITEM){
      text = "Item";
    }else if(this.type == EVENT_TYPE_OBJECT){
      text = "Object";
    }
    return text;
  }
}