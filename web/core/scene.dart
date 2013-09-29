/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library scene;

import 'dart:html';
import 'dart:async';
import 'dart:json';
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
  Map structuresData;
  
  // The map matrix that represent the first visual terrain layer 
  Matrix mapset;
  // The map matrix that represent the second visual terrain layer 
  Matrix mapset2;
// The map matrix that represent the third visual terrain layer 
  Matrix mapset3;
  
  Scene(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas) {
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    mapset = new Matrix(( SCREEN_WIDTH / TILE_SIZE).floor(), ( SCREEN_HEIGHT / TILE_SIZE).floor());
    mapset2 = new Matrix(( SCREEN_WIDTH / TILE_SIZE).floor(), ( SCREEN_HEIGHT / TILE_SIZE).floor());
    mapset3 = new Matrix(( SCREEN_WIDTH / TILE_SIZE).floor(), ( SCREEN_HEIGHT / TILE_SIZE).floor());
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
        Tile t = new Tile(5, 2, TILE_SOIL);
        mapset.set(x, y, t);
        mapset2.set(x, y, 0);
        mapset3.set(x, y, 0);
      }
    }
    loadFile();
  }
  
  void loadFile(){
    String url = "data/structures.json";
    var request = HttpRequest.getString(url).then(loadStructures);
  }
  
  void loadStructures(String responseText) {
    structuresData = parse(responseText);
    addBuilding(0, 6,5);
    addRandomDetails();
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
    for(var i = 0; i< 7; i++){
      var rX = random.nextInt(mapset2.cols);
      var rY = random.nextInt(mapset2.rows);
      Tile t = new Tile(5, 10);
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