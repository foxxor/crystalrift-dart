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
      Character character = object;
      Message message = event;
      message.x = character.screenPosPx.x;
      message.y = character.screenPosPx.y;
      message.update();
    }else if(type == EVENT_TYPE_ANIMATION){
      Character character = this.object;
      MapAnimation animation = this.event;
      animation.curPosPx.x = character.curPosPx.x;
      animation.curPosPx.y = character.curPosPx.y;
      animation.update();
    }else if(type == EVENT_TYPE_FIGHT_ANIMATION){
      MapAnimation animation = this.event;
      animation.update();
    }
  }
  
}