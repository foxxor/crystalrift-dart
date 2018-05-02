/*
  Copyright (C) 2014 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library menuTileset;

import 'dart:html' hide Matrix;
import '../core/tile.dart';
import '../helpers/matrix.dart';
import '../helpers/coordinate.dart';
import '../core/globals.dart';

class MenuTileset{
  HtmlDocument doc;
  CanvasRenderingContext2D ctx;
  CanvasElement canvas;
  ImageElement image;
  var tilesetContainer;
  bool mouseSelecting;
  Coordinate initialSelection;
  Coordinate mouseSelector;
  
  MenuTileset(HtmlDocument doc, CanvasRenderingContext2D ctx, CanvasElement canvas, var tilesetContainer){
    this.doc = doc;
    this.ctx = ctx;
    this.canvas = canvas;
    this.tilesetContainer = tilesetContainer;
    this.canvas.width = 1024;
    this.canvas.height = 2016;
    this.mouseSelector = new Coordinate(0, 0);
    this.mouseSelecting = false;  
    loadGraphic('tileset.png');
  }
  
  void loadGraphic(String src){
    image = new ImageElement(src:'assets/tileset/'+src, width:canvas.width, height:canvas.height);
    image.onLoad.listen((value) => loadTileset());
  }
  
  void loadTileset(){
    //num cols = image.width / TILE_SIZE;
    //num rows = image.height / TILE_SIZE;
    ctx.drawImage(image, 0, 0);
    /*ctx.save();
    ctx.globalAlpha = 0.1;
    ctx.strokeStyle = '#000';
    ctx.lineWidth   = 1;
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
    ctx.restore();*/
  }
  
  void updateSelector(int x, int y){
    mouseSelector.x = x;
    mouseSelector.y = y;
  }
  
  void beginSelection(){
    initialSelection = new Coordinate(mouseSelector.x - 1, mouseSelector.y - 1);
    mouseSelecting = true;
  }
  
  void stopSelection(){
    mouseSelecting = false;
  }
  
  void update(){
    loadTileset();

    //Draw of the map selector icon
    ctx.strokeStyle = '#FFF';
    ctx.lineWidth   = 1;
    if(mouseSelecting){
      int selectWidth = (initialSelection.x - mouseSelector.x) * TILE_SIZE;
      int selectHeight = (initialSelection.y - mouseSelector.y) * TILE_SIZE;
      ctx.strokeRect((mouseSelector.x +1) * TILE_SIZE,  (mouseSelector.y +1) * TILE_SIZE, 
          selectWidth, selectHeight);
    }else{
      ctx.strokeRect(mouseSelector.x * TILE_SIZE,  mouseSelector.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
    }
  }
}