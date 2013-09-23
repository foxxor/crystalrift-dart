import 'dart:html';
import 'helpers/graphics.dart';

//System vars
HtmlDocument _doc;
CanvasRenderingContext2D _ctx;
CanvasElement canvas;
Graphics graphics;

var curDirection = 0;
var animate = false;
var frame = 0;
var acDelta = 0;
var lastUpdateTime = 0;

//Engine vars
var INITIAL_FRAME = 1;
var MS_PER_FRAME = 30;

void main() {
  setupCanvas();
  graphics = new Graphics(_doc, _ctx, canvas);
  setupKeys();
  window.animationFrame.then(update);
}

//refresh method
void update(num delta) {
  if(animate){
    DateTime thisInstant = new DateTime.now();
    var delta = thisInstant.millisecondsSinceEpoch - lastUpdateTime;
    if (acDelta > MS_PER_FRAME) {
      acDelta = 0;
      frame--;
      if (frame < 0)
        frame = 2;
    } else {
      acDelta += delta;
    }
    lastUpdateTime = thisInstant.millisecondsSinceEpoch;
  }
  
  graphics.drawCharacter(frame, curDirection);
  window.animationFrame.then(update);
}

void setupCanvas(){
  _doc = window.document;
  canvas = _doc.query("#canvas");
  canvas.width = 500;
  canvas.height = 500;
  _ctx = canvas.getContext("2d");
}

void setupKeys(){
  canvas.onKeyDown.listen((e) {
    animate = true;
    reactKey(e);
    //draw(characterImage);
  });
  canvas.onKeyUp.listen((e) {
    animate = false; 
    frame = INITIAL_FRAME;
  });
}

void reactKey(var evt) {
  if(evt.keyCode == 37 || evt.keyCode == 65 ) { //left
    curDirection = 1;
    //curX -= 3;
    //animate = true;
  }else if(evt.keyCode == 38 || evt.keyCode == 87 ){ //up
    curDirection = 3;
    //curY -= 3;
    //animate = true;
  }else if(evt.keyCode == 39 || evt.keyCode == 68 ){ //right
    curDirection = 2;
    //curX += 3;
    //animate = true;
  }else if(evt.keyCode == 40 || evt.keyCode == 83 ){ //down
    curDirection = 0;
    //curY += 3;
    //animate = true;
  }
  
}
