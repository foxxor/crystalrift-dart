/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library event;

import '../core/globals.dart';
import '../core/character.dart';
import 'effects/mapAnimation.dart';
import '../lib/message.dart';

class Action {
  var object;
  var event;
  int type;
  
  Action(var object, var event, int type){
    this.object = object;
    this.event = event;
    this.type = type;
  }
  
  void update(){
    if(type == EVENT_TYPE_MESSAGE){
      Character c = object;
      Message m = event;
      m.x = c.screenPosPx.x;
      m.y = c.screenPosPx.y;
      m.update();
    }else if(type == EVENT_TYPE_ANIMATION){
      Character c = object;
      MapAnimation a = event;
      a.curPosPx.x = c.screenPosPx.x;
      a.curPosPx.y = c.screenPosPx.y;
      a.update();
    }else if(type == EVENT_TYPE_FIGHT_ANIMATION){
      MapAnimation a = event;
      a.update();
    }
  }
  
}