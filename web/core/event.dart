/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library event;

import '../core/globals.dart';
import '../core/character.dart';
import '../lib/message.dart';

class Event {
  var object;
  var event;
  int type;
  
  Event(var object, var event, int type){
    this.object = object;
    this.event = event;
    this.type = type;
  }
  
  void update(){
    if(type == EVENT_TYPE_MESSAGE){
      Character c = object;
      Message m = event;
      m.x = c.curPosPx.x;
      m.y = c.curPosPx.y;
      m.update();
    }
  }
  
}