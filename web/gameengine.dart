/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'core/globals.dart';
import 'core/character.dart';
import 'core/scene.dart';
import 'core/windowset.dart';

//System vars
HtmlDocument _doc;
CanvasRenderingContext2D _ctx;
CanvasElement canvas;
Scene scene;
WindowSet windowInfo;

void main() {
  setupCanvas();
  scene = new Scene(_doc, _ctx, canvas);
  String text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas fermentum dictum lacus. Mauris metus urna, consectetur ut nulla in, ullamcorper vehicula mauris. Fusce aliquam sapien eu hendrerit euismod. Mauris dignissim non arcu sit amet egestas. Proin blandit nec tellus sit amet tristique. ";;
  windowInfo = new WindowSet(_doc, _ctx, canvas, 0, SCREEN_HEIGHT - 128, SCREEN_WIDTH, 128, text);
  setupKeys();
  window.animationFrame.then(update);
}

//refresh method
void update(num delta) {
  _ctx.clearRect(0, 0, canvas.width, canvas.height);
  scene.update();
  if(!windowInfo.endOfLine){
    windowInfo.update();
  }
  
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
      scene.mainCharacter.move(LEFT);
  }else if(evt.keyCode == 38 || evt.keyCode == 87 ){ //up
      scene.mainCharacter.move(UP);
  }else if(evt.keyCode == 39 || evt.keyCode == 68 ){ //right
      scene. mainCharacter.move(RIGHT);
  }else if(evt.keyCode == 40 || evt.keyCode == 83 ){ //down
      scene.mainCharacter.move(DOWN);
  }else if(evt.keyCode == 13 ){ //Action
    windowInfo.moveLines();
    //Character message if in front
    Character c = scene.getCharacterInFront();
    if(c != null){
      if(!c.trigger){
        c.trigger = true;
        scene.createMessage(c);
        scene.createAnimation(scene.mainCharacter);
      }
    }
  }
  
}
