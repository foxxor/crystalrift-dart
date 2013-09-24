import 'dart:html';
import 'globals.dart';

class Scene {
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement sceneImage;
  
  Scene(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas) {
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    loadImage("assets/tileset.png");
  }
  
  void loadImage(String src){
    this.sceneImage = new Element.tag('img'); 
    this.sceneImage = _doc.createElement('img'); 
    this.sceneImage.src = src;
    this.sceneImage.onLoad.listen((value) => update());
  }
  
  void update(){
    for (var e = 0; e < (SCREEN_HEIGHT / TILE_SIZE); e++){
      for (var i = 0; i < (SCREEN_WIDTH / TILE_SIZE); i++){
        _ctx.drawImageToRect(this.sceneImage , new Rect(i * TILE_SIZE, e * TILE_SIZE, TILE_SIZE, TILE_SIZE), //Rect to paint the image
            sourceRect: new Rect(29*TILE_SIZE, 0, TILE_SIZE, TILE_SIZE)); //Size of the image
      }
    }
    
  }
  
}