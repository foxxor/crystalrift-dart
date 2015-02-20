/*
  Copyright (C) 2015 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library eventObject;

import 'dart:html';
import '../core/tile.dart';
import '../helpers/matrix.dart';
import '../helpers/coordinate.dart';
import '../core/globals.dart';
import 'mapEvent.dart';

class EventObject extends MapEvent{
  bool pushable;

  EventObject(int type, int x, int y,int imgX, int imgY, String imageSource, String name) : 
    super( type, x, y, imgX, imgY, imageSource, name);
  
}