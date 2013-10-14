/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library character;

import 'dart:html';
import 'dart:async';
import 'globals.dart';
import 'scene.dart';
import 'graphic.dart';
import '../helpers/coordinate.dart';
import 'dart:math' as Math;

class Character implements Graphic{
  
  //Graphical vars
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement characterImage;
  
  // Current position in tiles
  Coordinate curPos;
  // Current position in pixels
  Coordinate curPosPx;
  // Current animation frame
  int frame;
  // Facing direction
  int faceDir;
  // Current selected chart
  int selectedChar;
  // Move this guy like crazy
  bool randomMovement;
  // Is this object pasable?
  bool phasable;
  // Character movement speed
  int speed;
  // Event is executing?
  bool trigger;
  //Parent scene calling this objetc
  Scene scene;
  //Message of the character
  String message;

  int offsetX;
  int offsetY;
  
  var acDelta = 0; //Deprecated 
  var lastUpdateTime = 0; //Deprecated
  
  Character(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas, 
      Coordinate curPos, int charSprite, Scene scene, String message, [int speed = 1]) {
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    this.randomMovement = false;
    this.phasable = false;
    this.selectedChar = charSprite;
    this.speed = speed;
    this.curPos = curPos;
    this.curPosPx = new Coordinate(curPos.x *TILE_SIZE, curPos.y *TILE_SIZE);
    this.frame = INITIAL_FRAME;
    this.faceDir = INITIAL_FACE;
    this.trigger = false;
    this.scene = scene;
    this.message = message;
    offsetX = 0;
    offsetY = 0;
    loadGraphic("assets/character/characters.png");
  }
  
  void moveRandom(){
    const ms = const Duration(milliseconds: 3000);
    Timer t = new Timer( ms, doMoveRandom);
  }
  
  void doMoveRandom(){
    randomMove();
    moveRandom();
  }
  
  void randomMove(){
    var random = new Math.Random();
    var number = random.nextInt(4);
    move(number);
  }
  
  void moveTo(int x, int y){
    curPos.y = y;
    curPos.x = x;
  }
  
  bool move(int face){
    if(!scene.shallPass(face, this)){
      faceDirection(face);
      return false;
    }
    switch (face) {
      case 0: //up
        faceDirection(UP);
        if(curPos.y > 0){
          curPos.y -= 1;
          return true;
        }
        break;
      case 1: //down
        faceDirection(DOWN);
        if((curPos.y)  < MAP_HEIGHT_TILES){
          curPos.y += 1;
          return true;
        }
        break;
      case 2: //left
        faceDirection(LEFT);
        if(curPos.x > 0){
          curPos.x -= 1;
          return true;
        }
        break;
      case 3: //right
        faceDirection(RIGHT);
        if((curPos.x) < MAP_WIDTH_TILES){
          curPos.x += 1;
          return true;
        }
        break;
    }
    return false;
  }
  
  void faceDirection(int direction){
    switch (direction) {
      case UP: //up
        faceDir = 3;
        break;
      case DOWN: //down
        faceDir = 0;
        break;
      case LEFT: //left
        faceDir = 1;
        break;
      case RIGHT: //right
        faceDir = 2;
        break;
    }
  }
  
  int getCurrentDirection(){
    switch (faceDir) {
      case 3: //up
        return UP;
        break;
      case 0: //down
        return DOWN;
        break;
      case 1: //left
        return LEFT;
        break;
      case 2: //right
        return RIGHT;
        break;
    }
  }
  
  void loadGraphic(String src){
    this.characterImage = new Element.tag('img'); 
    this.characterImage = _doc.createElement('img'); 
    this.characterImage.src = src;
    this.characterImage.onLoad.listen((value) => update());
  }
  
  bool isMoving(){
    return (curPosPx.x != curPos.x * TILE_SIZE || curPosPx.y != curPos.y * TILE_SIZE);
  }
  
  void updateMove(){
    var distance = 2 * speed;
    if(curPos.y * TILE_SIZE > curPosPx.y){
      faceDirection(DOWN);
      curPosPx.y = Math.min(curPosPx.y + distance, curPos.y * TILE_SIZE);
    }
    if(curPos.x * TILE_SIZE > curPosPx.x){
      faceDirection(RIGHT);
      curPosPx.x = Math.min(curPosPx.x + distance, curPos.x * TILE_SIZE);  
    }
    if(curPos.y * TILE_SIZE < curPosPx.y){
      faceDirection(UP);
      curPosPx.y = Math.max(curPosPx.y - distance, curPos.y * TILE_SIZE);
    }
    if(curPos.x * TILE_SIZE < curPosPx.x){
      faceDirection(LEFT);
      curPosPx.x = Math.max(curPosPx.x - distance, curPos.x * TILE_SIZE);
    }
    animate();
  }
  
  void animate(){
    frame ++;
    if(frame>2){
      frame = 0;
    }
  }
  
  void stopMove(){
    if(curPos.y * TILE_SIZE > curPosPx.y){
      num dy = (curPosPx.y + (TILE_SIZE - (curPosPx.y % TILE_SIZE))) / TILE_SIZE;
      curPos.y = Math.min(dy.floor(), curPos.y);
    }
    if(curPos.x * TILE_SIZE > curPosPx.x){
      num dx = (curPosPx.x + (TILE_SIZE - (curPosPx.x % TILE_SIZE))) / TILE_SIZE;
      curPos.x = Math.min(dx.floor(), curPos.x);
    }
    if(curPos.y * TILE_SIZE < curPosPx.y){
      num dy = (curPosPx.y + (TILE_SIZE - (curPosPx.y % TILE_SIZE))) / TILE_SIZE;
      curPos.y = Math.max(dy.floor(), curPos.y) -1;
    }
    if(curPos.x * TILE_SIZE < curPosPx.x){
      num dx = (curPosPx.x + (TILE_SIZE - (curPosPx.x % TILE_SIZE))) / TILE_SIZE;
      curPos.x = Math.max(dx.floor(), curPos.x) -1;
    }
    
    frame = 1;
  }

  void update(){
    if(isMoving()){
      updateMove();
    }else{
      stopMove();
    }
    
    _ctx.drawImageToRect(this.characterImage , new Rectangle(curPosPx.x - scene.displayPxX, curPosPx.y - scene.displayPxY,
        TILE_SIZE, TILE_SIZE), //Rect to paint the image
        sourceRect: new Rectangle(((selectedChar *3) + frame) * TILE_SIZE, TILE_SIZE * faceDir, TILE_SIZE, TILE_SIZE)); //Size of the image
  }
}