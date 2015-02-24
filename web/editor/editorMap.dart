/*
  Copyright (C) 2014 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library editorMap;

import 'dart:html';
import '../core/tile.dart';
import '../helpers/matrix.dart';
import '../helpers/coordinate.dart';
import '../core/globals.dart';
import 'mapEvent.dart';

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
  Coordinate initialSelection;
  bool mouseSelecting;
  var selection;
  int selectionMode;
  bool active;
  // If the add event option was selected.
  bool addingEvent;
  // List of the events
  List<MapEvent> events;
  
  EditorMap(String name, int width, int height){
    this.name = name;
    this.widthTiles = width;
    this.heightTiles = height;
    layer1 = new Matrix(width, height);
    layer2 = new Matrix(width, height);
    layer3 = new Matrix(width, height);
    this.mouseSelector = new Coordinate(0, 0);
    this.mouseSelecting = false;
    active = false;
    addingEvent = false;
    events = new List<MapEvent>();
    // Initial point event
    MapEvent initPointEvent = new MapEvent(EVENT_TYPE_STARTING_POINT, 16, 11, 'Starting point');
    events.add(initPointEvent);
    initLayers();
  }
  
  void initContext(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas){
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    _ctx.strokeStyle = '#000';
    _ctx.lineWidth   = 1;
    loadGraphic('assets/tileset/tileset.png');
  }
  
  void canvasReDraw(){
    this.canvas.width = widthTiles* TILE_SIZE;
    this.canvas.height = heightTiles* TILE_SIZE;
  }
  
  void loadGraphic(String src){
    this.mapImage = new Element.tag('img'); 
    this.mapImage = _doc.createElement('img'); 
    this.mapImage.src = src;
    this.mapImage.onLoad.listen((value) => update());
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
    mouseSelector.x = x;
    mouseSelector.y = y;
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
  
  void setSelection(var selection){
    this.selection = selection;
  }
  
  // There should be just 1 starting point per map
  void setStartingPoint(MapEvent initPointEvent){
    events.insert(0, initPointEvent);
  }
  
  void update([bool drawSelector = false]){
    if(active){
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
      for (var event in events){
        int realX = (event.currentPosition.x) * TILE_SIZE;
        int realY = (event.currentPosition.y) * TILE_SIZE;
        
        _ctx.strokeStyle = "rgba(235, 235, 235, 0.85)";
        _ctx.fillStyle = "rgba(180, 180, 180, 0.5)";
        _ctx.lineWidth   = 2;
        _ctx.fillRect(realX,  realY, TILE_SIZE, TILE_SIZE);
        _ctx.strokeRect(realX,  realY, TILE_SIZE, TILE_SIZE);
        _ctx..save()
        ..font = '12pt Verdana'
        ..fillStyle = "rgba(255, 255, 255, 0.75)"
        ..lineWidth = 3
        ..strokeStyle = "rgba(0, 0, 0, 0.85)";
        
        var eventTypeString = "";
        if(event.type == EVENT_TYPE_STARTING_POINT){
          eventTypeString = "S";
        }else if(event.type == EVENT_TYPE_CHARACTER){
          eventTypeString = "C";
        }else if(event.type == EVENT_TYPE_OBJECT){
          eventTypeString = "O";
        }else if(event.type == EVENT_TYPE_ITEM){
          eventTypeString = "I";
        }
        _ctx.strokeText(eventTypeString, realX + (TILE_SIZE / 3).floor(), 
            realY + (TILE_SIZE * 2 / 3).floor());
        _ctx.fillText(eventTypeString, realX + (TILE_SIZE / 3).floor(), 
            realY + (TILE_SIZE * 2 / 3).floor());
        _ctx.restore();
      }
      
      if(drawSelector){
        //Draw of the map selector icon
        _ctx.strokeStyle = '#FFF';
        _ctx.lineWidth   = 1;
        if(mouseSelecting){
          int selectWidth = (initialSelection.x - mouseSelector.x) * TILE_SIZE;
          int selectHeight = (initialSelection.y - mouseSelector.y) * TILE_SIZE;
          _ctx.strokeRect((mouseSelector.x +1) * TILE_SIZE,  (mouseSelector.y +1) * TILE_SIZE, 
              selectWidth, selectHeight);
        }else{
          if(selectionMode == MULTI_TILE_SELECTION){
              _ctx.strokeRect(mouseSelector.x * TILE_SIZE,  mouseSelector.y * TILE_SIZE, 
              selection.cols * TILE_SIZE, selection.rows * TILE_SIZE);
          }else{
            _ctx.strokeRect(mouseSelector.x * TILE_SIZE,  mouseSelector.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
          }
        }
      }
    }
  }
  
  void beginSelection(){
    initialSelection = new Coordinate(mouseSelector.x-1, mouseSelector.y-1);
    mouseSelecting = true;
  }
  
  void stopSelection(){
    mouseSelecting = false;
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
    update();
  }
}