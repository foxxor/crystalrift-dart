/*
  Copyright (C) 2015 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library eventCharacter;

import 'dart:html';
import '../core/tile.dart';
import '../helpers/matrix.dart';
import '../helpers/coordinate.dart';
import '../core/globals.dart';
import 'mapEvent.dart';

class EventCharacter extends MapEvent{
  bool moveRandom;
  String message;
  int behaviour;
  bool combatable;
  
  EventCharacter(int type, int x, int y, int imgX, int imgY, String imageSource, String name) : 
    super( type, x, y, name);
  
}