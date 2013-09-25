import 'dart:html';
import 'helpers/globals.dart';
import 'helpers/coordinate.dart';
import 'helpers/character.dart';
import 'helpers/scene.dart';

//System vars
HtmlDocument _doc;
CanvasRenderingContext2D _ctx;
CanvasElement canvas;
//Character char;
Scene scene;
List<Character> chars; //List of current characters

void main() {
  setupCanvas();
  scene = new Scene(_doc, _ctx, canvas);
  Coordinate initCoor1 = new Coordinate(0,0);
  Coordinate initCoor2 = new Coordinate(2,2);
  Character char1 = new Character(_doc, _ctx, canvas, initCoor1, 0); //Main Player
  Character char2 = new Character(_doc, _ctx, canvas, initCoor2, 2);
  chars = new List<Character>();
  chars.add(char1);
  //char2.randomMovement = true;
  chars.add(char2);
  setupKeys();
  window.animationFrame.then(update);
}

//refresh method
void update(num delta) {
  _ctx.clearRect(0, 0, canvas.width, canvas.height);
  scene.update();
  
  Iterator<Character> charas = chars.iterator;
  while(charas.moveNext()){
    Character c = charas.current;
    c.update();
  }
  //char.update();
  window.animationFrame.then(update);
}

void setupCanvas(){
  _doc = window.document;
  canvas = _doc.query("#canvas");
  canvas.width = SCREEN_WIDTH;
  canvas.height = SCREEN_HEIGHT;
  _ctx = canvas.getContext("2d");
}

void setupKeys(){
  canvas.onKeyDown.listen((e) {
    reactKey(e);
    //draw(characterImage);
  });
  canvas.onKeyUp.listen((e) {
    chars.first.frame = INITIAL_FRAME;
  });
}

bool shallPass(int face, Character c){
  Iterator<Character> charas = chars.iterator;
  while(charas.moveNext()){
    Character char = charas.current;
    if(!char.phasable && char.curPos.nextToThis(c.curPos) == face){
        return false;
    }
  }
  return true;
}

void reactKey(var evt) {
  if(evt.keyCode == 37 || evt.keyCode == 65 ) { //left
    if(shallPass(LEFT,chars.first)){
      chars.first.move(LEFT);
    }else{
      chars.first.faceDirection(LEFT);
    }
  }else if(evt.keyCode == 38 || evt.keyCode == 87 ){ //up
    if(shallPass(UP,chars.first)){
      chars.first.move(UP);
    }else{
      chars.first.faceDirection(UP);
    }
  }else if(evt.keyCode == 39 || evt.keyCode == 68 ){ //right
    if(shallPass(RIGHT,chars.first)){
      chars.first.move(RIGHT);
    }else{
      chars.first.faceDirection(RIGHT);
    }
  }else if(evt.keyCode == 40 || evt.keyCode == 83 ){ //down
    if(shallPass(DOWN,chars.first)){
      chars.first.move(DOWN);
    }else{
      chars.first.faceDirection(DOWN);
    }
  }
  
}
