import 'dart:html';

class Graphics {
  
  //Engine vars
  int SELECTED_CHAR = 0; // Define the selected char to use;
  int TILE_SIZE = 32;
  int charCurX = 0;
  int charCurY = 0;
  
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
  
  void move(int face){
    switch (face) {
      case 1: //up
        if(charCurY > 0){
          charCurY -= TILE_SIZE;
        }
        break;
      case 2: //down
        if(charCurY < (canvas.height - TILE_SIZE)){
          charCurY += TILE_SIZE;
        }
        break;
      case 3: //left
        if(charCurX > 0){
          charCurX -= TILE_SIZE;
        }
        break;
      case 4: //right
        if(charCurX < (canvas.width - TILE_SIZE)){
          charCurX += TILE_SIZE;
        }
        break;
    }
  }
  
  void loadImage(String src){
    this.characterImage = new Element.tag('img'); 
    this.characterImage = _doc.createElement('img'); 
    this.characterImage.src = src;
    this.characterImage.onLoad.listen((value) => drawCharacter(0, 1));
  }

  void drawCharacter(var frame, var curDirection){
    _ctx.clearRect(0, 0, canvas.width, canvas.height);
    _ctx.drawImageToRect(this.characterImage , new Rect(charCurX, charCurY, TILE_SIZE, TILE_SIZE), //Rect to paint the image
        sourceRect: new Rect((SELECTED_CHAR + frame) * TILE_SIZE, TILE_SIZE * curDirection, TILE_SIZE, TILE_SIZE)); //Size of the image
  }
  
}