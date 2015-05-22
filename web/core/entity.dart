/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library entity;

import 'dart:html';
import 'globals.dart';
import 'graphic.dart';
import 'scene.dart';
import '../helpers/coordinate.dart';
import 'tile.dart';
import 'dart:math' as Math;

class Entity implements Graphic{
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement itemImage;
  
  //Animation speed
  int speed;
  //Current position in tiles
  Coordinate curPos;
  //Current position in pixels
  Coordinate curPosPx;
  //Tile of the object
  Tile tile;
  //Entity is moving?
  bool moving;
  //Entity can be pushed?
  bool pushable;
  //Parent scene
  Scene scene;
  
  Entity(HtmlDocument this._doc, CanvasRenderingContext2D this._ctx, CanvasElement this.canvas, 
      Coordinate this.curPos, Tile this.tile, Scene this.scene, [bool this.pushable=false, int this.speed = 1]){
    this.curPosPx = new Coordinate(curPos.x *TILE_SIZE, curPos.y *TILE_SIZE);
    this.moving = false;
    loadGraphic("assets/tileset/tileset.png");
  }
  
  void loadGraphic(String src){
    this.itemImage = new Element.tag('img'); 
    this.itemImage = _doc.createElement('img'); 
    this.itemImage.src = src;
    this.itemImage.onLoad.listen((value) => update());
  }
  
  bool move(int face){
    if(!scene.shallPass(face, this)){
      return false;
    }
    bool moved = false;
    int initX = curPos.x;
    int initY = curPos.y;
    int deltaY = (curPos.y * TILE_SIZE - curPosPx.y).abs();
    int deltaX = (curPos.x * TILE_SIZE - curPosPx.x).abs();
    
    switch (face) {
      case 0: //up
        if(curPos.y > 0 && deltaY < TILE_SIZE){
          curPos.y -= 1;
          moved = true;
        }
        break;
      case 1: //down
        if((curPos.y *TILE_SIZE)  < (canvas.height - TILE_SIZE) && deltaY < TILE_SIZE ){
          curPos.y += 1;
          moved = true;
        }
        break;
      case 2: //left
        if(curPos.x > 0 && deltaX < TILE_SIZE ){
          curPos.x -= 1;
          moved = true;
        }
        break;
      case 3: //right
        if((curPos.x* TILE_SIZE)< (canvas.width - TILE_SIZE) && deltaX < TILE_SIZE){
          curPos.x += 1;
          moved = true;
        }
        break;
    }
    
    if(moved){
      scene.gameMap.moveToTile(initX, initY, curPos.x, curPos.y, this);
      return true;
    }
    return false;
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
  }
  
  bool isMoving(){
    return (curPosPx.x != curPos.x * TILE_SIZE || curPosPx.y != curPos.y * TILE_SIZE);
  }
  
  void updateMove(){
    var distance = 2 * speed;
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
  }
  
  void update(){
    if(isMoving()){
      updateMove();
    }
    if(!scene.inCamera(this.curPosPx)){
      return;
    }
    
    _ctx.drawImageToRect(this.itemImage , new Rectangle( curPosPx.x - scene.displayPxX, curPosPx.y - scene.displayPxY, TILE_SIZE, TILE_SIZE), //Rect to paint the image
        sourceRect: new Rectangle( tile.xImg, tile.yImg, TILE_SIZE, TILE_SIZE)); //Size of the image
  }
  
}