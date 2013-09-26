/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'globals.dart';
import 'graphic.dart';
import '../helpers/coordinate.dart';
import 'dart:math' as Math;

class Character implements Graphic{
  
  //Graphical vars
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement characterImage;
  
  //Current position in tiles
  Coordinate curPos;
  //Current position in pixels
  Coordinate curPosPx;
  //Current animation frame
  int frame;
  //Character is moving?
  bool moving;
  //Facing direction
  int faceDir;
  //Current selected chart
  int selectedChar;
  //Move this guy like crazy
  bool randomMovement;
  //Is this object pasable?
  bool phasable;
  
  var acDelta = 0;
  var lastUpdateTime = 0;
  
  Character(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas, Coordinate curPos, int charSprite) {
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    this.randomMovement = false;
    this.phasable = false;
    this.selectedChar = charSprite;
    this.curPos = curPos;
    this.curPosPx = new Coordinate(curPos.x *TILE_SIZE, curPos.y *TILE_SIZE);
    this.moving = false;
    this.frame = INITIAL_FRAME;
    this.faceDir = INITIAL_FACE;
    loadGraphic("assets/characters.png");
  }
  
  void moveRandom(){
    var random = new Math.Random();
    var number = random.nextInt(4);
    move(number);
  }
  
  void move(int face){
    switch (face) {
      case 0: //up
        faceDirection(UP);
        if(curPos.y > 0){
          curPos.y -= 1;
        }
        break;
      case 1: //down
        faceDirection(DOWN);
        if((curPos.y *TILE_SIZE)  < (canvas.height - TILE_SIZE)){
          curPos.y += 1;
        }
        break;
      case 2: //left
        faceDirection(LEFT);
        if(curPos.x > 0){
          curPos.x -= 1;
        }
        break;
      case 3: //right
        faceDirection(RIGHT);
        if((curPos.x* TILE_SIZE)< (canvas.width - TILE_SIZE)){
          curPos.x += 1;
        }
        break;
    }
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
    var distance = 2 * MOVE_SPEED;
    if(curPos.y * TILE_SIZE > curPosPx.y){
      curPosPx.y = Math.min(curPosPx.y + distance, curPos.y * TILE_SIZE);
    }
    if(curPos.x * TILE_SIZE > curPosPx.x){
      curPosPx.x = Math.min(curPosPx.x + distance, curPos.x * TILE_SIZE);  
    }
    if(curPos.y * TILE_SIZE < curPosPx.y){
      curPosPx.y = Math.max(curPosPx.y - distance, curPos.y * TILE_SIZE);
    }
    if(curPos.x * TILE_SIZE < curPosPx.x){
      curPosPx.x = Math.max(curPosPx.x - distance, curPos.x * TILE_SIZE);
    }
    frame ++;
    if(frame>2){
      frame = 0;
    }
  }
  
  void stopMove(){
    frame = 1;
  }
  
  void processMovements(){
    if(randomMovement){
      DateTime thisInstant = new DateTime.now();
      int delta = thisInstant.millisecondsSinceEpoch - lastUpdateTime;
      if (acDelta > MS_PER_FRAME) {
        acDelta = 0;
        moveRandom();
      } else {
        acDelta += delta;
      }
      lastUpdateTime = thisInstant.millisecondsSinceEpoch;
    }
  }

  void update(){
    processMovements();
    
    if(isMoving()){
      updateMove();
    }else{
      stopMove();
    }
    
    _ctx.drawImageToRect(this.characterImage , new Rect(curPosPx.x , curPosPx.y, TILE_SIZE, TILE_SIZE), //Rect to paint the image
        sourceRect: new Rect(((selectedChar *3) + frame) * TILE_SIZE, TILE_SIZE * faceDir, TILE_SIZE, TILE_SIZE)); //Size of the image
  }
  
}