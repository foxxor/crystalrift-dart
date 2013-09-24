import 'dart:html';
import 'helpers/globals.dart';
import 'helpers/coordinate.dart';
import 'helpers/character.dart';
import 'helpers/scene.dart';


//System vars
HtmlDocument _doc;
CanvasRenderingContext2D _ctx;
CanvasElement canvas;
Character char;
Scene scene;
//List<Graphic> elems;

int lastUpdateTime = 0;
int acDelta = 0;

void main() {
  setupCanvas();
  Coordinate initCoor = new Coordinate(0,0);//((SCREEN_WIDTH/2).floor(), (SCREEN_HEIGHT/2).floor() );
  char = new Character(_doc, _ctx, canvas, initCoor);
  scene = new Scene(_doc, _ctx, canvas);
  setupKeys();
  window.animationFrame.then(update);
}

//refresh method
void update(num delta) {
  /*DateTime thisInstant = new DateTime.now();
  int delta = thisInstant.millisecondsSinceEpoch - lastUpdateTime;
  if (acDelta > MS_PER_FRAME) {
    acDelta = 0;
    char.moveRandom();
  } else {
    acDelta += delta;
  }
  lastUpdateTime = thisInstant.millisecondsSinceEpoch;*/
  
  _ctx.clearRect(0, 0, canvas.width, canvas.height);
  scene.update();
  char.update();
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
    char.moving = true;
    reactKey(e);
    //draw(characterImage);
  });
  canvas.onKeyUp.listen((e) {
    char.moving = false; 
    char.frame = INITIAL_FRAME;
  });
}

void reactKey(var evt) {
  if(evt.keyCode == 37 || evt.keyCode == 65 ) { //left
    char.move(2);
    //animate = true;
  }else if(evt.keyCode == 38 || evt.keyCode == 87 ){ //up
    char.move(0);
    //animate = true;
  }else if(evt.keyCode == 39 || evt.keyCode == 68 ){ //right
    char.move(3);
    //animate = true;
  }else if(evt.keyCode == 40 || evt.keyCode == 83 ){ //down
    char.move(1);
    //animate = true;
  }
  
}
