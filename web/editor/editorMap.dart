/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library editorMap;

import 'dart:html';
import '../core/tile.dart';
import '../helpers/matrix.dart';
import '../core/globals.dart';

class EditorMap{
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement mapImage;
  String name;
  int widthTiles;
  int heightTiles;
  Matrix layer1;
  Matrix layer2;
  Matrix layer3;
  
  EditorMap(String name, int width, int height){
    this.name = name;
    this.widthTiles = width;
    this.heightTiles = height;
    layer1 = new Matrix(width, height);
    layer2 = new Matrix(width, height);
    layer3 = new Matrix(width, height);
    initLayers();
  }
  
  void initContext(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas){
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    this.canvas.width = widthTiles* TILE_SIZE;
    this.canvas.height = heightTiles* TILE_SIZE;
    _ctx.strokeStyle = '#000';
    _ctx.lineWidth   = 1;
    loadGraphic('assets/tileset/tileset.png');
  }
  
  void loadGraphic(String src){
    this.mapImage = new Element.tag('img'); 
    this.mapImage = _doc.createElement('img'); 
    this.mapImage.src = src;
    this.mapImage.onLoad.listen((value) => reDraw());
  }
  
  void initLayers(){
    for (var y = 0; y < ( heightTiles); y++){
      for (var x = 0; x < (widthTiles); x++){
        Tile t = new Tile(8, 2);
        layer1.set(x, y, t);
        layer2.set(x, y, 0);
        layer3.set(x, y, 0);
      }
    }
  }
  
  void reDraw(){
    _ctx.strokeRect(0,  0, widthTiles* TILE_SIZE, heightTiles* TILE_SIZE);
    for (var e = 0; e < (heightTiles); e++){
      for (var i = 0; i < (widthTiles); i++){
        Tile tile = layer1.get( i, e);
        print(tile);
        _ctx.drawImageToRect(this.mapImage , new Rectangle(i * TILE_SIZE, e * TILE_SIZE, TILE_SIZE, TILE_SIZE), //Rect to paint the image
            sourceRect: new Rectangle( tile.xImg, tile.yImg, TILE_SIZE, TILE_SIZE)); //Size of the image
        
        if(layer2.get(i, e) != 0){
          Tile tile2 = layer2.get(i, e);
          _ctx.drawImageToRect(this.mapImage , new Rectangle(i * TILE_SIZE, e * TILE_SIZE, TILE_SIZE, TILE_SIZE), //Rect to paint the image
              sourceRect: new Rectangle( tile2.xImg, tile2.yImg, TILE_SIZE, TILE_SIZE)); //Size of the image
        }
      }
    }
  }
}