library damageAnimation;

import 'dart:html';
import 'dart:async';
import '../globals.dart';
import '../scene.dart';
import '../../helpers/coordinate.dart';
import '../graphic.dart';
import '../character.dart';

class DamageAnimation implements Graphic{
  
  //Graphical vars
  HtmlDocument doc;
  CanvasRenderingContext2D ctx;
  CanvasElement canvas;
  ImageElement animationImage;
  Scene scene;
  Coordinate curPosPx;
  int animationFrame;
  
  DamageAnimation(Scene this.scene, Character character){
    this.doc = scene.doc;
    this.ctx = scene.ctx;
    this.canvas = scene.canvas;
    this.curPosPx = new Coordinate(character.curPosPx.x + (TILE_SIZE / 2).floor(), character.curPosPx.y + 10 );
    
    this.animationFrame = 0;
  }
  
  void startAnimation(){
    const ms = const Duration(milliseconds: 100);
    Timer timer = new Timer( ms, updateFrame);
  }
  
  Future updateFrame() async {
    num maxFrames = (animationImage.height / ANIMATION_FRAME_HEIGHT) * 5;
    if(animationFrame >= maxFrames){
      animationFrame = 0;
    }
    animationFrame++;
    startAnimation();
  }
  
  Future update() async {
    this.curPosPx.y -= 1;
    
    if(scene.inCamera(this.curPosPx)){
      num frameX = animationFrame % 5;
      num frameY = (animationFrame / 5).floor();

      ctx.drawImageScaledFromSource(animationImage, ANIMATION_FRAME_WIDTH * frameX, ANIMATION_FRAME_HEIGHT * frameY, 
          ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT, curPosPx.x - scene.displayPxX, curPosPx.y - scene.displayPxY, TILE_SIZE, TILE_SIZE + 10);
    }
  }
  
  void loadGraphic(String src){
    this.animationImage = new Element.tag('img'); 
    this.animationImage = doc.createElement('img'); 
    this.animationImage.src = src;
    this.animationImage.onLoad.listen((value) => update());
  }
}