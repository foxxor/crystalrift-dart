/*
  Copyright (C) 2014 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library menuTileset;

import 'dart:html';
import '../core/tile.dart';
import '../helpers/matrix.dart';
import '../helpers/coordinate.dart';
import '../core/globals.dart';

class MenuTileset{
  HtmlDocument doc;
  CanvasRenderingContext2D ctx;
  CanvasElement canvas;
  ImageElement tilesetImage;
  var tileElement;
  
  MenuTileset(HtmlDocument doc, CanvasRenderingContext2D ctx, CanvasElement canvas, var tileElement){
    this.doc = doc;
    this.ctx = ctx;
    this.canvas = canvas;
    this.tileElement = tileElement;
    this.canvas.width = 1024;
    this.canvas.height = 2016;
    loadGraphic('tileset.png');
  }
  
  void loadGraphic(String src){
    tileElement = doc.querySelector("#tilesetCont");
    tilesetImage = new ImageElement(src:'assets/tileset/'+src, width:canvas.width, height:canvas.height);
    tilesetImage.onLoad.listen((value) => loadTileset());
  }
  
  void loadTileset(){
    num cols = tilesetImage.width / TILE_SIZE;
    num rows = tilesetImage.height / TILE_SIZE;
    ctx.drawImage( tilesetImage, 0, 0);
    
    for(num x = 1; x < cols; x++){
      ctx.moveTo(x * TILE_SIZE, 0);
      ctx.lineTo(x * TILE_SIZE, tilesetImage.height);
      ctx.stroke();
    }
    for(int y=1; y < rows; y++){
      ctx.moveTo(0, y * TILE_SIZE);
      ctx.lineTo(tilesetImage.width, y * TILE_SIZE);
      ctx.stroke();
    }
  }
}