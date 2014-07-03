/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library editorMap;

import 'dart:html';
import '../core/tile.dart';
import '../helpers/matrix.dart';
import '../helpers/coordinate.dart';
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
  Coordinate mouseSelector;
  
  EditorMap(String name, int width, int height){
    this.name = name;
    this.widthTiles = width;
    this.heightTiles = height;
    layer1 = new Matrix(width, height);
    layer2 = new Matrix(width, height);
    layer3 = new Matrix(width, height);
    this.mouseSelector = new Coordinate(0, 0);
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
  
  void updateSelector(int x, int y){
    this.mouseSelector.x = x;
    this.mouseSelector.y = y;
  }
  
  void setTile(int x, int y, int tx, int ty, [int layer=1,int type=TILE_SOIL]){
    Tile t = new Tile(tx, ty);
    if(layer == 1){
      layer1.set(x, y, t);
    }else if(layer == 2){
      layer2.set(x, y, t);
    }else if(layer == 3){
      layer3.set(x, y, t);
    }
  }
  
  void reDraw([bool drawSelector = false]){
    _ctx.strokeRect(0,  0, widthTiles* TILE_SIZE, heightTiles* TILE_SIZE);
    
    for (var e = 0; e < (heightTiles); e++){
      for (var i = 0; i < (widthTiles); i++){
        Tile tile = layer1.get( i, e);
        _ctx.drawImageToRect(this.mapImage , new Rectangle(i * TILE_SIZE, e * TILE_SIZE, TILE_SIZE, TILE_SIZE), //Rect to paint the image
            sourceRect: new Rectangle( tile.xImg, tile.yImg, TILE_SIZE, TILE_SIZE)); //Size of the image
        
        if(layer2.get(i, e) != 0){
          Tile tile2 = layer2.get(i, e);
          _ctx.drawImageToRect(this.mapImage , new Rectangle(i * TILE_SIZE, e * TILE_SIZE, TILE_SIZE, TILE_SIZE), //Rect to paint the image
              sourceRect: new Rectangle( tile2.xImg, tile2.yImg, TILE_SIZE, TILE_SIZE)); //Size of the image
        }
        if(layer3.get(i, e) != 0){
          Tile tile3 = layer3.get(i, e);
          _ctx.drawImageToRect(this.mapImage , new Rectangle(i * TILE_SIZE, e * TILE_SIZE, TILE_SIZE, TILE_SIZE), //Rect to paint the image
              sourceRect: new Rectangle( tile3.xImg, tile3.yImg, TILE_SIZE, TILE_SIZE)); //Size of the image
        }
      }
    }
    if(drawSelector){
      //Draw of the map selector icon
      _ctx.strokeStyle = '#FFF';
      _ctx.lineWidth   = 1;
      _ctx.strokeRect(this.mouseSelector.x * TILE_SIZE,  this.mouseSelector.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
    }
    
  }
  
  //Method to serialize a matrix in something dart understands
  Map toJson() { 
    Map map = new Map();
    map['layer1'] = this.layer1.toJson();
    map['layer2'] = this.layer2.toJson();
    map['layer3'] = this.layer3.toJson();
    return map;
  }
  
  void loadMap(Map mapData){
    Map nLayer1 = mapData['layer1'];
    Map nLayer2 = mapData['layer2'];
    Map nLayer3 = mapData['layer3'];
    for (var i = 0; i < nLayer1.length; i++){
      for (var e = 0; e < nLayer1[i.toString()].length; e++){
        Tile t1 = new Tile(nLayer1[i.toString()][e.toString()]['x'], nLayer1[i.toString()][e.toString()]['y']);
        var t2 = (nLayer2[i.toString()][e.toString()] is Map ?
          new Tile(nLayer2[i.toString()][e.toString()]['x'], nLayer2[i.toString()][e.toString()]['y']) :
          0 );
        var t3 = (nLayer3[i.toString()][e.toString()] is Map?
          new Tile(nLayer3[i.toString()][e.toString()]['x'], nLayer3[i.toString()][e.toString()]['y']) :
          0 );
        layer1.set(i, e, t1);
        layer2.set(i, e, t2);
        layer3.set(i, e, t3);
      }
    }
    reDraw();
  }
}