/*
  Copyright (C) 2015 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library eventItem;

import 'dart:html';
import '../core/tile.dart';
import '../helpers/matrix.dart';
import '../helpers/coordinate.dart';
import '../core/globals.dart';
import 'mapEvent.dart';

class EventItem extends MapEvent{
  bool pushable;

  EventItem(int type, int x, int y, int imgX, int imgY, String imageSource, String name) : 
    super( type, x, y, imgX, imgY, imageSource, name);
  
}