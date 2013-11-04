/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';

//System vars
HtmlDocument _doc;
CanvasRenderingContext2D _ctx;
CanvasRenderingContext2D _ctxTile;
CanvasElement canvas;
CanvasElement tileCanvas;
ImageElement image;
ImageElement imageTile;
var tileElement;
int TILE_SIZE;

void main() {
  _doc = window.document;
  canvas = _doc.query("#canvas");
  _ctx = canvas.getContext("2d");
  canvas.width = 1024;//384;
  canvas.height = 2016;//15096;
  image = new ImageElement(src:'assets/tileset/tileset.png', width:canvas.width, height:canvas.height);
  image.onLoad.listen((value) => update());
  TILE_SIZE = 32;
  
  tileCanvas = _doc.query("#tile");
  _ctxTile = tileCanvas.getContext("2d");
  tileCanvas.width = TILE_SIZE;
  tileCanvas.height = TILE_SIZE;
  
  imageTile = new ImageElement(src:'assets/tileset/tileset.png', width:TILE_SIZE, height:TILE_SIZE);
  document.onMouseDown.listen(mousePressed);
}

void mousePressed(MouseEvent e){
  int x = (e.client.x/TILE_SIZE).round() -1;
  int y = (e.client.y/TILE_SIZE).round() -1;
  _ctxTile.clearRect(0, 0, TILE_SIZE, TILE_SIZE);
  _ctxTile.drawImageToRect(imageTile , new Rectangle(0, 0, TILE_SIZE, TILE_SIZE), //Rect to paint the image
      sourceRect: new Rectangle( x * TILE_SIZE, y* TILE_SIZE, TILE_SIZE, TILE_SIZE)); //Size of the image
}

void update(){
  num cols = image.width / TILE_SIZE;
  num rows = image.height / TILE_SIZE;
  _ctx.drawImage( image,0,0);
  
  for(num x = 1; x < cols; x++){
    _ctx.moveTo(x*TILE_SIZE, 0);
    _ctx.lineTo(x*TILE_SIZE, image.height);
    _ctx.stroke();
  }
  for(int y=1; y < rows; y++){
    _ctx.moveTo(0, y*TILE_SIZE);
    _ctx.lineTo(image.width, y*TILE_SIZE);
    _ctx.stroke();
  }
}