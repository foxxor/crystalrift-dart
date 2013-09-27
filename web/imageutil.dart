/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';

//System vars
HtmlDocument _doc;
CanvasRenderingContext2D _ctx;
CanvasElement canvas;
ImageElement image;
int TILE_SIZE;

void main() {
  _doc = window.document;
  canvas = _doc.query("#canvas");
  _ctx = canvas.getContext("2d");
  canvas.width = 1024;//384;
  canvas.height = 2016;//15096;
  TILE_SIZE = 32;//24;
  
  image = new Element.tag('img'); 
  image = _doc.createElement('img'); 
  image.src = 'assets/tileset.png';//'assets/iconset.png';
  image.onLoad.listen((value) => update());
  
  document.onMouseDown.listen(mousePressed);

}

void mousePressed(MouseEvent e){
  int x = (e.pageX/TILE_SIZE).round() -1;
  int y = (e.pageY/TILE_SIZE).round() -1;
  
  print('X:'+ x.toString()+ ' Y:'+ y.toString());
}

void update(){
  num cols = canvas.width / TILE_SIZE;
  num rows = canvas.height / TILE_SIZE;
  _ctx.drawImage( image,0,0);
  
  for(num x = 1; x < cols; x++){
    _ctx.moveTo(x*TILE_SIZE, 0);
    _ctx.lineTo(x*TILE_SIZE, canvas.height);
    _ctx.stroke();
  }
  for(int y=1; y < rows; y++){
    _ctx.moveTo(0, y*TILE_SIZE);
    _ctx.lineTo(canvas.width, y*TILE_SIZE);
    _ctx.stroke();
  }
}