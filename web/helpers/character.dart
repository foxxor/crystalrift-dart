import 'dart:html';
import 'globals.dart';
import 'coordinate.dart';

class Character{
  
  Coordinate curPos;
  Coordinate desPos;
  
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement characterImage;
  int frame;
  bool moving;
  int faceDir;
  
  var acDelta = 0;
  var lastUpdateTime = 0;
  
  Character(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas, Coordinate curPos) {
    this.curPos = curPos;
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    this.moving = false;
    this.frame = INITIAL_FRAME;
    this.faceDir = INITIAL_FACE;
    loadImage("assets/characters.png");
  }
  
  void move(int face){
    switch (face) {
      case 1: //up
        faceDir = 3;
        if(curPos.y > 0){
          //curPos.y -= TILE_SIZE;
          desPos = new Coordinate(curPos.x, curPos.y - 1);
        }
        break;
      case 2: //down
        faceDir = 0;
        if((curPos.y *TILE_SIZE)  < (canvas.height - TILE_SIZE)){
          //curPos.y += TILE_SIZE;
          desPos = new Coordinate(curPos.x, curPos.y + 1);
        }
        break;
      case 3: //left
        faceDir = 1;
        if(curPos.x > 0){
          //curPos.x -= TILE_SIZE;
          desPos = new Coordinate(curPos.x - 1, curPos.y);
        }
        break;
      case 4: //right
        faceDir = 2;
        if((curPos.x* TILE_SIZE)< (canvas.width - 1)){
          //curPos.x += TILE_SIZE;
          desPos = new Coordinate(curPos.x + 1, curPos.y);
        }
        break;
    }
  }
  
  void loadImage(String src){
    this.characterImage = new Element.tag('img'); 
    this.characterImage = _doc.createElement('img'); 
    this.characterImage.src = src;
    this.characterImage.onLoad.listen((value) => update());
  }

  void update(){
    var deltaY = 0;
    var deltaX = 0;
    if(desPos != null){
      deltaY = desPos.y - curPos.y;
      deltaX = desPos.x - curPos.x;
    }
    
    if(moving){      
      DateTime thisInstant = new DateTime.now();
      var delta = thisInstant.millisecondsSinceEpoch - lastUpdateTime;
      if (acDelta > MS_PER_FRAME) {
        acDelta = 0;
      } else {
        acDelta += delta;
      }
      if(acDelta < MS_PER_FRAME / 2){
        curPos.y += (deltaY/2).floor();
        curPos.x += (deltaX/2).floor();
        frame = 1;
      }else if(acDelta > MS_PER_FRAME / 2 && acDelta < MS_PER_FRAME){
        curPos.y += (deltaY/2).floor();
        curPos.x += (deltaX/2).floor();
        frame = 2;
      }else{
        frame = 0;
        curPos.y = desPos.y;
        curPos.x = desPos.x;
      }
      lastUpdateTime = thisInstant.millisecondsSinceEpoch;
    }else{
      if(desPos != null){
        curPos.y = desPos.y;
        curPos.x = desPos.x;
      }
      frame = 0;
    }
    
    _ctx.drawImageToRect(this.characterImage , new Rect(curPos.x *TILE_SIZE, curPos.y*TILE_SIZE, TILE_SIZE, TILE_SIZE), //Rect to paint the image
        sourceRect: new Rect((SELECTED_CHAR + frame) * TILE_SIZE, TILE_SIZE * faceDir, TILE_SIZE, TILE_SIZE)); //Size of the image
  }
  
}