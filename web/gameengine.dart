/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'core/globals.dart';
import 'core/character.dart';
import 'core/actor.dart';
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
  canvas = _doc.querySelector("#canvas");
  canvas.focus();
  Element title = _doc.querySelector("#title");
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight - title.scrollHeight;
  _ctx = canvas.getContext("2d");
}

//Keyboard and keybinding

void setupKeys(){
  canvas.onKeyDown.listen((e) {
    reactKey(e);
  });
  canvas.onKeyUp.listen((e) {
    scene.player.stopMove();
  });
}

void reactKey(var evt) {
  if(evt.keyCode == 37 || evt.keyCode == 65 ) { //left
      scene.move(LEFT);
  }else if(evt.keyCode == 38 || evt.keyCode == 87 ){ //up
      scene.move(UP);
  }else if(evt.keyCode == 39 || evt.keyCode == 68 ){ //right
      scene.move(RIGHT);
  }else if(evt.keyCode == 40 || evt.keyCode == 83 ){ //down
      scene.move(DOWN);
  }else if(evt.keyCode == 13 ){ //Action
    windowInfo.moveLines();
    //Character message if in front
    Actor c = scene.getCharacterInFront();
    if(c != null){
      if(c.combatable){
        c.life = c.life - 10;
        scene.createAnimation(c);
        c.chaseCharacter(scene.player);
      }else if(!c.trigger){
        c.trigger = true;
        if(c.message.isNotEmpty){
          //scene.createMessage(c);
        }
      }
    }
  }
  
}
