/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library animation;

import 'dart:html';
import 'dart:async';
import 'globals.dart';
import 'scene.dart';
import '../helpers/coordinate.dart';
import 'graphic.dart';

class Animation implements Graphic{
  
  //Graphical vars
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement animationImage;
  
  Coordinate curPos;
  int animationFrame;
  
  Animation(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas, Coordinate curPos){
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    this.curPos = curPos;
    this.animationFrame = 0;
    loadGraphic('assets/animations/fire_001.png');
  }
  
  void startAnimation(){
    const ms = const Duration(milliseconds: 100);
    Timer t = new Timer( ms, updateFrame);
  }
  
  void updateFrame(){
    if(animationFrame >= 20){
      animationFrame = 0;
    }
    animationFrame++;
    startAnimation();
  }
  
  void update(){
    num frameX = animationFrame % 5;
    num frameY = (animationFrame / 5).floor();
    _ctx.drawImageScaledFromSource(animationImage, ANIMATION_FRAME_WIDTH * frameX, ANIMATION_FRAME_HEIGHT * frameY, 
        ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT, curPos.x * TILE_SIZE, curPos.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
  }
  
  void loadGraphic(String src){
    this.animationImage = new Element.tag('img'); 
    this.animationImage = _doc.createElement('img'); 
    this.animationImage.src = src;
    this.animationImage.onLoad.listen((value) => update());
  }
}