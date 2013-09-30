/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'dart:async';
import 'lib/message.dart';
import 'helpers/coordinate.dart';
import 'core/globals.dart';
import 'core/character.dart';
import 'core/item.dart';
import 'core/scene.dart';
import 'core/mapset.dart';
import 'core/tile.dart';
import 'core/action.dart';

//System vars
HtmlDocument _doc;
CanvasRenderingContext2D _ctx;
CanvasElement canvas;
//Character char;
Scene scene;

void main() {
  setupCanvas();
  scene = new Scene(_doc, _ctx, canvas);
  
  setupKeys();
  window.animationFrame.then(update);
}

//refresh method
void update(num delta) {
  _ctx.clearRect(0, 0, canvas.width, canvas.height);
  scene.update();
  window.animationFrame.then(update);
}

void setupCanvas(){
  _doc = window.document;
  canvas = _doc.query("#canvas");
  canvas.width = SCREEN_WIDTH;
  canvas.height = SCREEN_HEIGHT;
  _ctx = canvas.getContext("2d");
}

//Keyboard and keybinding

void setupKeys(){
  canvas.onKeyDown.listen((e) {
    reactKey(e);
  });
  canvas.onKeyUp.listen((e) {
    scene.mainCharacter.stopMove();
  });
}

void reactKey(var evt) {
  if(evt.keyCode == 37 || evt.keyCode == 65 ) { //left
    if(scene.shallPass(LEFT,scene.mainCharacter)){
      scene.mainCharacter.move(LEFT);
    }else{
      scene.mainCharacter.faceDirection(LEFT);
    }
  }else if(evt.keyCode == 38 || evt.keyCode == 87 ){ //up
    if(scene.shallPass(UP,scene.mainCharacter)){
      scene.mainCharacter.move(UP);
    }else{
      scene.mainCharacter.faceDirection(UP);
    }
  }else if(evt.keyCode == 39 || evt.keyCode == 68 ){ //right
    if(scene.shallPass(RIGHT, scene.mainCharacter)){
      scene. mainCharacter.move(RIGHT);
    }else{
      scene.mainCharacter.faceDirection(RIGHT);
    }
  }else if(evt.keyCode == 40 || evt.keyCode == 83 ){ //down
    if(scene.shallPass(DOWN,scene.mainCharacter)){
      scene.mainCharacter.move(DOWN);
    }else{
      scene.mainCharacter.faceDirection(DOWN);
    }
  }else if(evt.keyCode == 13 ){ //Action
    Character c = scene.getCharacterInFront();
    if(c != null){
      if(!c.trigger){
        c.trigger = true;
        scene.createMessage(c);
      }
    }
  }
  
}
