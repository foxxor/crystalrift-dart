/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'globals.dart';
import 'graphic.dart';
import '../helpers/matrix.dart';
import 'tile.dart';
import 'dart:math' as Math;

class Scene implements Graphic{
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement sceneImage;
  
  //The map matrix that represent the first visual terrain layer 
  Matrix mapset;
//The map matrix that represent the second visual terrain layer 
  Matrix mapset2;
  
  Scene(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas) {
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    mapset = new Matrix(( SCREEN_WIDTH / TILE_SIZE).floor(), ( SCREEN_HEIGHT / TILE_SIZE).floor());
    mapset2 = new Matrix(( SCREEN_WIDTH / TILE_SIZE).floor(), ( SCREEN_HEIGHT / TILE_SIZE).floor());
    initValues();
    loadGraphic("assets/tileset.png");
  }
  
  void loadGraphic(String src){
    this.sceneImage = new Element.tag('img'); 
    this.sceneImage = _doc.createElement('img'); 
    this.sceneImage.src = src;
    this.sceneImage.onLoad.listen((value) => update());
  }
  
  void initValues(){
    for (var y = 0; y < ( SCREEN_HEIGHT/ TILE_SIZE); y++){
      for (var x = 0; x < (SCREEN_WIDTH / TILE_SIZE); x++){
        Tile t = new Tile(17, 0, TILE_SOIL);
        mapset.set(x, y, t);
        mapset2.set(x, y, 0);
      }
    }
    addBuilding(5,3);
    addDecoration();
  }
  
  void addBuilding(int x, int y){
    Tile t = new Tile(23, 20, TILE_BUILDING_UNPASSABLE);
    mapset.set(x, y, t);
    mapset.set(x+1, y, t);
    mapset.set(x+2, y, t);
    Tile t2 = new Tile(23, 21, TILE_BUILDING_UNPASSABLE);
    mapset.set(x, y+1, t2);
    mapset.set(x+1, y+1, t2);
    mapset.set(x+2, y+1, t2);
    Tile t3 = new Tile(23, 22, TILE_BUILDING_UNPASSABLE);
    mapset.set(x, y+2, t3);
    mapset.set(x+1, y+2, t3);
    mapset.set(x+2, y+2, t3);
    Tile t4 = new Tile(23, 23, TILE_BUILDING_PASSABLE);
    mapset.set(x, y+3, t4);
    mapset.set(x+1, y+3, t4);
    mapset.set(x+2, y+3, t4);
  }
  
  void addDecoration(){
    var random = new Math.Random();
    
    for(var i = 0; i< 5; i++){
      var rX = random.nextInt(mapset2.cols);
      var rY = random.nextInt(mapset2.rows);
      Tile t = new Tile(1, 32);
      if(mapset.get(rX, rY).type == TILE_SOIL){
        mapset2.set(rX, rY, t);
      }
    }
  }
  
  bool nextToTile(int x, int y, int face){
    if(x >= 1){
      Tile t1 = mapset.get(x-1, y);
      if( t1.type == TILE_BUILDING_UNPASSABLE && face == LEFT){
        return true;
      }
    }
    if(y >= 1){
      Tile t2 = mapset.get(x, y-1);
      if( t2.type == TILE_BUILDING_UNPASSABLE && face == UP){
        return true;
      }
    }
    if(x < mapset.cols -1){
      Tile t3 = mapset.get(x+1, y);
      if( t3.type == TILE_BUILDING_UNPASSABLE && face == RIGHT){
        return true;
      }
    }
    if(y < mapset.rows -1){
      Tile t4 = mapset.get(x, y+1);
      if( t4.type == TILE_BUILDING_UNPASSABLE && face == DOWN){
        return true;
      }
    }
    
    return false;
  }
  
  void update(){
    for (var e = 0; e < (SCREEN_HEIGHT / TILE_SIZE); e++){
      for (var i = 0; i < (SCREEN_WIDTH / TILE_SIZE); i++){
        Tile tile = mapset.get(i, e);
        _ctx.drawImageToRect(this.sceneImage , new Rect(i * TILE_SIZE, e * TILE_SIZE, TILE_SIZE, TILE_SIZE), //Rect to paint the image
            sourceRect: new Rect( tile.xImg, tile.yImg, TILE_SIZE, TILE_SIZE)); //Size of the image
        
        if(mapset2.get(i, e) != 0){
          Tile tile2 = mapset2.get(i, e);
          _ctx.drawImageToRect(this.sceneImage , new Rect(i * TILE_SIZE, e * TILE_SIZE, TILE_SIZE, TILE_SIZE), //Rect to paint the image
              sourceRect: new Rect( tile2.xImg, tile2.yImg, TILE_SIZE, TILE_SIZE)); //Size of the image
        }
      }
    }
  }
  
}