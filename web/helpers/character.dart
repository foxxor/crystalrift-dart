import 'dart:html';
import 'globals.dart';
import 'coordinate.dart';
import 'dart:math' as Math;

class Character{
  
  Coordinate curPos;
  Coordinate curPosPx;
  
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
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    
    this.curPos = curPos;
    this.curPosPx = new Coordinate(curPos.x *TILE_SIZE, curPos.y *TILE_SIZE);
    this.moving = false;
    this.frame = INITIAL_FRAME;
    this.faceDir = INITIAL_FACE;
    loadImage("assets/characters.png");
  }
  
  void moveRandom(){
    var random = new Math.Random();
    var number = random.nextInt(4);
    move(number);
  }
  
  void move(int face){
    switch (face) {
      case 0: //up
        faceDir = 3;
        if(curPos.y > 0){
          curPos.y -= 1;
        }
        break;
      case 1: //down
        faceDir = 0;
        if((curPos.y *TILE_SIZE)  < (canvas.height - TILE_SIZE)){
          curPos.y += 1;
        }
        break;
      case 2: //left
        faceDir = 1;
        if(curPos.x > 0){
          curPos.x -= 1;
        }
        break;
      case 3: //right
        faceDir = 2;
        if((curPos.x* TILE_SIZE)< (canvas.width - 1)){
          curPos.x += 1;
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
  
  
  bool isMoving(){
    return (curPosPx.x != curPos.x * TILE_SIZE || curPosPx.y != curPos.y * TILE_SIZE);
  }
  
  void update_move(){
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
  
  void stop_move(){
    frame = 0;
  }

  void update(){
    if(isMoving()){
      update_move();
    }else{
      stop_move();
    }
    
    _ctx.drawImageToRect(this.characterImage , new Rect(curPosPx.x , curPosPx.y, TILE_SIZE, TILE_SIZE), //Rect to paint the image
        sourceRect: new Rect((SELECTED_CHAR + frame) * TILE_SIZE, TILE_SIZE * faceDir, TILE_SIZE, TILE_SIZE)); //Size of the image
  }
  
}