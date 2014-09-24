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
  
  //Graphic vars
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
  // Current selected char
  int selectedChar;
  // Current selected char row
  int characterRow;
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

  int offsetX;
  int offsetY;
  
  var acDelta = 0; //Deprecated 
  var lastUpdateTime = 0; //Deprecated
  
  Character(HtmlDocument this._doc, CanvasRenderingContext2D this._ctx, CanvasElement this.canvas, 
      Coordinate this.curPos, int selectedChar, int characterRow, Scene this.scene, String imageSource, [int this.speed = 1]) {
    this.randomMovement = false;
    this.phasable = false;
    this.curPosPx = new Coordinate(curPos.x *TILE_SIZE, curPos.y *TILE_SIZE);
    this.frame = INITIAL_FRAME;
    this.faceDir = INITIAL_FACE;
    this.trigger = false;
    offsetX = 0;
    offsetY = 0;
    this.selectedChar = selectedChar * 3; //This calculation is cached for performance 
    this.characterRow = (characterRow - 1 ) * (TILE_SIZE * 4); //This calculation is cached for performance 
    loadGraphic("assets/character/" + imageSource);
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
          curPos.y --;
          return true;
        }
        break;
      case 1: //down
        faceDirection(DOWN);
        if((curPos.y)  < MAP_HEIGHT_TILES - 1){
          curPos.y ++;
          return true;
        }
        break;
      case 2: //left
        faceDirection(LEFT);
        if(curPos.x > 0){
          curPos.x --;
          return true;
        }
        break;
      case 3: //right
        faceDirection(RIGHT);
        if((curPos.x) < MAP_WIDTH_TILES - 1){
          curPos.x ++;
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
      case 0: //down
        return DOWN;
      case 1: //left
        return LEFT;
      case 2: //right
        return RIGHT;
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
        sourceRect: new Rectangle(((selectedChar) + frame) * TILE_SIZE, 
            (TILE_SIZE * faceDir) + this.characterRow, 
            TILE_SIZE, TILE_SIZE)); //Size of the image
  }
}