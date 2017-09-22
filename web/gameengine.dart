/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'core/globals.dart';
import 'core/actor.dart';
import 'core/projectile.dart';
import 'core/scene.dart';
import 'core/windowset.dart';
import 'helpers/coordinate.dart';

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

  // Calculate real viewport size omiting the title height
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
  // Trigger action for the character in front, if any.
  Actor character = scene.getCharacterInFront();
  if(character != null){
    if(character.combatable){
      character.damage(30);
      scene.createAnimation(character);
      character.chaseCharacter(scene.player);
    }else if(!character.trigger){
      character.trigger = true;
      if(character.message.isNotEmpty){
        scene.createMessage(character);
      }
    }
  }
}

void createProjectile(){
  Coordinate curPos = new Coordinate(scene.player.curPos.x, scene.player.curPos.y);
  Projectile projectile = new Projectile(curPos, scene.player.faceDir, scene, 'arrow_faces.png', 4, 2);
  scene.projectiles.add(projectile);
}

void reactKey(var evt) {
  if(evt.keyCode == 37 || evt.keyCode == 65 ) { // Left + A
      scene.move(LEFT);
  }else if(evt.keyCode == 38 || evt.keyCode == 87 ){ // Up + W
      scene.move(UP);
  }else if(evt.keyCode == 39 || evt.keyCode == 68 ){ // Right + D
      scene.move(RIGHT);
  }else if(evt.keyCode == 40 || evt.keyCode == 83 ){ // Down + S
      scene.move(DOWN);
  }else if(evt.keyCode == 13 ){ // Action
    doAction();
  }else if(evt.keyCode == 82 ){ // Projectile
    createProjectile();
  }
}
