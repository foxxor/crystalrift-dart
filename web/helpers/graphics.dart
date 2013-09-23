import 'dart:html';

class Graphics {
  
  //Engine vars
  var SELECTED_CHAR = 0; // Define the selected char to use;
  var TILE_SIZE = 32;
  
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement characterImage;
  
  Graphics(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas) {
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    loadImage("assets/characters.png");
  }
  
  void loadImage(String src){
    this.characterImage = new Element.tag('img'); 
    this.characterImage = _doc.createElement('img'); 
    this.characterImage.src = src;
    this.characterImage.onLoad.listen((value) => drawCharacter(0, 1));
  }

  void drawCharacter(var frame, var curDirection){
    _ctx.clearRect(0, 0, TILE_SIZE, TILE_SIZE);
    _ctx.drawImageToRect(this.characterImage , new Rect(0, 0, TILE_SIZE, TILE_SIZE), //Rect to paint the image
        sourceRect: new Rect((SELECTED_CHAR + frame) * TILE_SIZE, TILE_SIZE * curDirection, TILE_SIZE, TILE_SIZE)); //Size of the image
  }
  
}