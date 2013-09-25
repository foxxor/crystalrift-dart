/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'globals.dart';
import '../helpers/matrix.dart';

class Scene {
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement sceneImage;
  Matrix mapset;
  
  Scene(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas) {
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    mapset = new Matrix((SCREEN_HEIGHT / TILE_SIZE).floor(), (SCREEN_WIDTH / TILE_SIZE).floor());
    initValues();
    loadImage("assets/tileset.png");
  }
  
  void loadImage(String src){
    this.sceneImage = new Element.tag('img'); 
    this.sceneImage = _doc.createElement('img'); 
    this.sceneImage.src = src;
    this.sceneImage.onLoad.listen((value) => update());
  }
  
  void initValues(){
    for (var x = 0; x < (SCREEN_HEIGHT / TILE_SIZE); x++){
      for (var y = 0; y < (SCREEN_WIDTH / TILE_SIZE); y++){
        mapset.set(x, y, 17*TILE_SIZE);
      }
    }
  }
  
  void update(){
    for (var e = 0; e < (SCREEN_HEIGHT / TILE_SIZE); e++){
      for (var i = 0; i < (SCREEN_WIDTH / TILE_SIZE); i++){
        int tile = mapset.get(e, i);
        _ctx.drawImageToRect(this.sceneImage , new Rect(i * TILE_SIZE, e * TILE_SIZE, TILE_SIZE, TILE_SIZE), //Rect to paint the image
            sourceRect: new Rect( tile, 0, TILE_SIZE, TILE_SIZE)); //Size of the image
      }
    }
  }
  
}