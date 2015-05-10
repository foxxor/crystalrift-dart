/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'core/globals.dart';
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
  _doc = window.document;
  setupCanvas();
  scene = new Scene(_doc, _ctx, canvas);
  
  int sceneWidth;
  int sceneHeight;
  Element title = _doc.querySelector(".navbar");
  
  if( (MAP_WIDTH_TILES * TILE_SIZE) < window.innerWidth){
    sceneWidth = ((window.innerWidth - (MAP_WIDTH_TILES * TILE_SIZE)) / 2).floor();
  }else{
    sceneWidth = window.innerWidth;
  }
  if( (MAP_HEIGHT_TILES * TILE_SIZE) < (window.innerHeight - title.scrollHeight)){
    sceneHeight = (((window.innerHeight - title.scrollHeight) - (MAP_HEIGHT_TILES * TILE_SIZE)) / 2).floor();
  }else{
    sceneHeight = window.innerHeight - title.scrollHeight;
  }
  scene.width = sceneWidth;
  scene.height = sceneHeight;
  
  setupKeys();
  String text = "Hi, welcome to this demo of Crystal Rift! \n Please use the A/S/D/W keys to move around. \n Use enter key to interact with characters and close this window. ";
  windowInfo = new WindowSet(_doc, _ctx, canvas, 
      ((canvas.width ) / 2).floor() - ((WINDOW_WIDTH / 2).floor() + (scene.width == window.innerWidth ? 0 : scene.width ) ), 
      scene.height - WINDOW_HEIGHT - 50, 
      WINDOW_WIDTH, WINDOW_HEIGHT, text);
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
  Element title = _doc.querySelector(".navbar");
  canvas = _doc.querySelector("#canvas");
  canvas.focus();
  if( (MAP_WIDTH_TILES * TILE_SIZE) < window.innerWidth){
    int leftMargin = ((window.innerWidth - (MAP_WIDTH_TILES * TILE_SIZE)) / 2).floor();
    canvas.style.marginLeft = leftMargin.toString() + 'px';
  }
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

// Function that generate the actions based in the context of the game.
void doAction(){
  windowInfo.moveLines();
  //Character message if in front
  Actor c = scene.getCharacterInFront();
  if(c != null){
    if(c.combatable){
      c.damage(10);
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
    doAction();
  }
  
}
