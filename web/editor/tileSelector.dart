/*
  Copyright (C) 2014 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library TileSelector;

import 'dart:html';
import '../core/tile.dart';
import '../helpers/matrix.dart';
import '../helpers/coordinate.dart';
import '../core/globals.dart';

class TileSelector{
  HtmlDocument doc;
  CanvasRenderingContext2D ctx;
  CanvasElement canvas;
  ImageElement image;
  var selection;
  int selectionMode;
  
  TileSelector(HtmlDocument doc, CanvasRenderingContext2D ctx, CanvasElement canvas){
    this.doc = doc;
    this.ctx = ctx;
    this.canvas = canvas;
    this.ctx.strokeStyle = '#000';
    this.ctx.lineWidth   = 1;
    selection = new Tile(0, 0);
    resetCanvasSize(TILE_SIZE, TILE_SIZE);
    loadGraphic('tileset.png');
  }
  
  void loadGraphic(String src){
    image = new ImageElement(src:'assets/tileset/'+src, width:TILE_SIZE, height:TILE_SIZE);
    image.onLoad.listen((value) => loadTileset());
  }
  
  void loadTileset(){
    num cols = image.width / TILE_SIZE;
    num rows = image.height / TILE_SIZE;
    ctx.drawImage( image, 0, 0);
  }
  
  void setSelection(var selection){
    this.selection = selection;
  }
  
  void setSelectionMode(int mode){
    if(mode == MULTI_TILE_SELECTION){
      image.width = TILE_SIZE * selection.cols;
      image.height = TILE_SIZE * selection.rows;
    }else{
      image.width = TILE_SIZE;
      image.height = TILE_SIZE;
    }
    selectionMode = mode;
  }
  
  void resetCanvasSize(int width, int height){
    canvas.width = width;
    canvas.height = height;
}
  
  void update(){
    ctx.clearRect(0, 0, TILE_SIZE, TILE_SIZE);
    if(selectionMode == MULTI_TILE_SELECTION){
      resetCanvasSize(selection.cols * TILE_SIZE, selection.rows * TILE_SIZE);
      for(num x = 0; x < selection.cols; x++){
        for(num y = 0; y < selection.rows; y++){
          Tile tileSelected = selection.get(x, y);
          ctx.drawImageToRect(image , new Rectangle(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE), //Rect to paint the image
            sourceRect: new Rectangle( tileSelected.x * TILE_SIZE, tileSelected.y * TILE_SIZE, 
            TILE_SIZE, TILE_SIZE)); //Size of the image
        }
      }
      ctx.strokeRect(0,  0, TILE_SIZE * selection.cols, TILE_SIZE * selection.rows);
    }else{
      resetCanvasSize(TILE_SIZE, TILE_SIZE);
      ctx.drawImageToRect(image , new Rectangle(0, 0, TILE_SIZE, TILE_SIZE), //Rect to paint the image
        sourceRect: new Rectangle( selection.x * TILE_SIZE, selection.y * TILE_SIZE, 
        TILE_SIZE, TILE_SIZE)); //Size of the image
      ctx.strokeRect(0,  0, TILE_SIZE, TILE_SIZE);
    }
  }
}