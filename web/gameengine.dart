import 'dart:html';
import 'helpers/globals.dart';
import 'helpers/graphics.dart';

//System vars
HtmlDocument _doc;
CanvasRenderingContext2D _ctx;
CanvasElement canvas;
Graphics graphics;

int screenHeight = 480;
int screenWidth = 640;

void main() {
  setupCanvas();
  graphics = new Graphics(_doc, _ctx, canvas);
  setupKeys();
  window.animationFrame.then(update);
}

//refresh method
void update(num delta) {
  graphics.update();
  window.animationFrame.then(update);
}

void setupCanvas(){
  _doc = window.document;
  canvas = _doc.query("#canvas");
  canvas.width = screenWidth;
  canvas.height = screenHeight;
  _ctx = canvas.getContext("2d");
}

void setupKeys(){
  canvas.onKeyDown.listen((e) {
    graphics.moving = true;
    reactKey(e);
    //draw(characterImage);
  });
  canvas.onKeyUp.listen((e) {
    graphics.moving = false; 
    graphics.frame = INITIAL_FRAME;
  });
}

void reactKey(var evt) {
  if(evt.keyCode == 37 || evt.keyCode == 65 ) { //left
    graphics.move(3);
    //animate = true;
  }else if(evt.keyCode == 38 || evt.keyCode == 87 ){ //up
    graphics.move(1);
    //animate = true;
  }else if(evt.keyCode == 39 || evt.keyCode == 68 ){ //right
    graphics.move(4);
    //animate = true;
  }else if(evt.keyCode == 40 || evt.keyCode == 83 ){ //down
    graphics.move(2);
    //animate = true;
  }
  
}
