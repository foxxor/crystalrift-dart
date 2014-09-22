/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library mapset;

import 'dart:html';
import 'dart:async';
import 'globals.dart';
import 'graphic.dart';
import 'scene.dart';
import '../helpers/matrix.dart';
import 'tile.dart';
import 'dart:math' as Math;

class MapSet implements Graphic{
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement mapsetImage;
  Map structuresData;
  Scene scene;
  
  // The map matrix that represent the first visual terrain layer 
  Matrix mapset;
  // The map matrix that represent the second visual terrain layer 
  Matrix mapset2;
// The map matrix that represent the third visual terrain layer 
  Matrix mapset3;
  
  MapSet(HtmlDocument this._doc, CanvasRenderingContext2D this._ctx, CanvasElement this.canvas, 
      Scene this.scene) {
    mapset = new Matrix(MAP_WIDTH_TILES, MAP_HEIGHT_TILES);
    mapset2 = new Matrix(MAP_WIDTH_TILES, MAP_HEIGHT_TILES);
    mapset3 = new Matrix(MAP_WIDTH_TILES, MAP_HEIGHT_TILES);
    initValues();
    loadGraphic("assets/tileset/tileset.png");
  }
  
  void loadGraphic(String src){
    this.mapsetImage = new Element.tag('img'); 
    this.mapsetImage = _doc.createElement('img'); 
    this.mapsetImage.src = src;
    this.mapsetImage.onLoad.listen((value) => hideLoading());
  }
  
  void hideLoading(){
    _doc.querySelector("#loading").classes.add('hidden');
    _doc.querySelector("#canvas").classes.remove('hidden');
    update();
  }
  
  void initValues(){
    for (var y = 0; y < ( MAP_HEIGHT_TILES); y++){
      for (var x = 0; x < (MAP_WIDTH_TILES); x++){
        Tile t = new Tile(8, 2, TILE_SOIL);
        mapset.set(x, y, t);
        mapset2.set(x, y, 0);
        mapset3.set(x, y, 0);
      }
    }
  }
  
  void addBuilding(int index, int x, int y){
    Map structure = structuresData['buildings'].elementAt(index);
    //Load the first layer
    Iterator<Map> tilesMapset1 = structure['mapset1']['tiles'].iterator;
    while(tilesMapset1.moveNext()){
      Map m = tilesMapset1.current;
      Tile t = new Tile(m['xTile'], m['yTile'], m['type']);
      Iterator<Map> blocks = m['blocks'].iterator;
      while(blocks.moveNext()){
        Map block = blocks.current;
        mapset.set(x +block['x'].toInt() , y + block['y'].toInt(), t);
      }
    }
    
    //Load the second layer
    Iterator<Map> tilesMapset2 = structure['mapset2']['tiles'].iterator;
    while(tilesMapset2.moveNext()){
      Map m = tilesMapset2.current;
      Tile t = new Tile(m['xTile'], m['yTile'], m['type']);
      Iterator<Map> blocks = m['blocks'].iterator;
      while(blocks.moveNext()){
        Map block = blocks.current;
        mapset2.set(x +block['x'].toInt() , y + block['y'].toInt(), t);
      }
    }
  }
  
  void addRandomDetails(){
    var random = new Math.Random();
    for(var i = 0; i< 10; i++){
      var rX = random.nextInt(mapset2.cols);
      var rY = random.nextInt(mapset2.rows);
      Tile t = new Tile(1, 32);
      if(mapset.get(rX, rY).type == TILE_SOIL){
        mapset2.set(rX, rY, t);
      }else{
        i --;
      }
    }
    for(var i = 0; i< 12; i++){
      var rX = random.nextInt(mapset2.cols);
      var rY = random.nextInt(mapset2.rows);
      Tile t = new Tile(3, 32);
      if(mapset.get(rX, rY).type == TILE_SOIL){
        mapset2.set(rX, rY, t);
      }else{
        i --;
      }
    }
    for(var i = 0; i< 8; i++){
      var rX = random.nextInt(mapset2.cols);
      var rY = random.nextInt(mapset2.rows);
      Tile t = new Tile(4, 32);
      if(mapset.get(rX, rY).type == TILE_SOIL){
        mapset2.set(rX, rY, t);
      }else{
        i --;
      }
    }
    for(var i = 0; i< 8; i++){
      var rX = random.nextInt(mapset2.cols);
      var rY = random.nextInt(mapset2.rows);
      Tile t = new Tile(6, 33);
      if(mapset.get(rX, rY).type == TILE_SOIL){
        mapset2.set(rX, rY, t);
      }else{
        i --;
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
    for (var e = 0; e < (MAP_HEIGHT_TILES); e++){
      for (var i = 0; i < (MAP_WIDTH_TILES); i++){
        Tile tile = mapset.get( i , e);
        _ctx.drawImageToRect(this.mapsetImage , new Rectangle(i * TILE_SIZE - scene.displayPxX, e * TILE_SIZE - scene.displayPxY, TILE_SIZE, TILE_SIZE), //Rect to paint the image
            sourceRect: new Rectangle( tile.xImg, tile.yImg, TILE_SIZE, TILE_SIZE)); //Size of the image
        
        if(mapset2.get(i, e) != 0){
          Tile tile2 = mapset2.get(i, e);
          _ctx.drawImageToRect(this.mapsetImage , new Rectangle(i * TILE_SIZE - scene.displayPxX, e * TILE_SIZE - scene.displayPxY, TILE_SIZE, TILE_SIZE), //Rect to paint the image
              sourceRect: new Rectangle( tile2.xImg, tile2.yImg, TILE_SIZE, TILE_SIZE)); //Size of the image
        }
      }
    }
  }
  
}