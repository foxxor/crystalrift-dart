/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'editor/editorMap.dart';
import 'core/globals.dart';
import 'core/tile.dart';

//System vars
HtmlDocument _doc;
CanvasRenderingContext2D _ctx;
CanvasRenderingContext2D _ctxTile;
CanvasRenderingContext2D mapCtx;
CanvasElement tilesetCanvas;
CanvasElement tileCanvas;
CanvasElement mapCanvas;
ImageElement image;
ImageElement imageTile;
Tile tileSelected;
var tileElement;
var mapElement;
var navigation;
var windows;
int currentLayer;
String currentTool;
List<EditorMap> maps;
var toolSubscription;

void main() {
  _doc = window.document;
  loadTileSet();
  initMenuInteraction();
  loadMap();
}

void initMenuInteraction(){
  initTabs();
  loadTileSelection();
  layerSelection();
  toolSelection();
}

void initTabs(){
  currentLayer = 1;
  currentTool = "pencil";
  navigation = _doc.querySelector("#navigation");
  windows = _doc.querySelector("#windows");
  navigation.onClick.listen((MouseEvent e){
    e.preventDefault();
    Element elem = e.toElement;
    String option = elem.dataset['option'];
    navigationHideAll();
    elem.parent.classes.add('active');
    switch (option){
      case "draw":
        windows.querySelector('#drawWindow').classes.remove('hide');
        break;
      case "maps":
        windows.querySelector('#mapWindow').classes.remove('hide');
        break;
      case "events":
        //windows.querySelector('#drawWindow').classes.remove('hide');
        break;
      case "io":
        //windows.querySelector('#drawWindow').classes.remove('hide');
        break;
    }
  });
}

// Listener for the layer selector
void layerSelection(){
  var layers = _doc.querySelector("#ulLayers");
  layers.onClick.listen((MouseEvent e){
    e.preventDefault();
    for (var layer in layers.children) {
      layer.classes.remove('active');
    }
    Element elem = e.toElement;
    elem.parent.classes.add('active');
    currentLayer = int.parse(elem.dataset['layer']);
  });
}

// Listener for the tool selected
void toolSelection(){
  var tools = _doc.querySelector("#toolset ");
  tools.onClick.listen((MouseEvent e){
    e.preventDefault();
    for (var layer in tools.children) {
      layer.classes.remove('active');
    }
    Element elem = e.toElement;
    elem.classes.add('active');
    currentTool = elem.dataset['tool'];
  });
}

void navigationHideAll(){
  for (var element in navigation.children) {
    element.classes.remove('active');
  }
  for (var window in windows.children) {
    window.classes.add('hide');
  }
}

// Draw the editor map
void loadMap(){
  maps = new List<EditorMap>();
  EditorMap m1 = new EditorMap("Map 001", 30, 20);
  mapCanvas = _doc.querySelector("#map");
  mapCtx = mapCanvas.getContext("2d");
  mapElement = _doc.querySelector('#mapContainer');
  m1.initContext(_doc, mapCtx, mapCanvas);
  maps.add(m1);
  drawMapsList();
  loadMapSelection();
}

void drawMapsList(){
  var ul = _doc.querySelector('#mapWindow ul.list-group');
  for (var m in maps){
    var li = new Element.html('<li class="list-group-item"><span class="badge">'+m.widthTiles.toString()+' x ' +m.heightTiles.toString()+'</span>'+m.name+'</li>');
      ul.children.add(li);
  }
}

//Listener for the map 
void loadMapSelection(){
  int dragX, dragY;
  mapCanvas.onMouseUp.listen((MouseEvent e){
    int x = ((e.client.x + mapElement.scrollLeft - 360)/TILE_SIZE).ceil();
    int y = ((e.client.y + mapElement.scrollTop - 10)/TILE_SIZE).ceil();
    if(dragX != x || dragY != y ){
      int iX = (dragX > x ? x: dragX );
      int iY = (dragY > y ? y: dragY );
      int fX = (dragX > x ? dragX: x );
      int fY = (dragX > x ? dragY: y );
      EditorMap curMap = maps.elementAt(0);
      for(num e = iX; e < fX; e++){
        for(num i = iY; i < fY; i++){
          if(currentTool == "pencil"){
            curMap.setTile(e, i, tileSelected.x, tileSelected.y, currentLayer);
          }else{ //Eraser
            curMap.setTile(e, i, 0, 0, currentLayer);
          }
        }
      }
      curMap.reDraw();
    }
  });
  
  mapCanvas.onMouseDown.listen((MouseEvent e){
    int x = ((e.client.x + mapElement.scrollLeft - 360)/TILE_SIZE).ceil() -1;
    int y = ((e.client.y + mapElement.scrollTop - 10)/TILE_SIZE).ceil() -1;
    dragX = x;
    dragY = y;
    EditorMap curMap = maps.elementAt(0);
    if(currentTool == "pencil"){
      curMap.setTile(x, y, tileSelected.x, tileSelected.y, currentLayer);
    }else{ //Eraser
      curMap.setTile(x, y, 0, 0, currentLayer);
    }
    curMap.reDraw();
  });
  
  //Update the selector position
  mapCanvas.onMouseMove.listen((MouseEvent e){
    int x = ((e.client.x + mapElement.scrollLeft - 360)/TILE_SIZE).ceil() -1;
    int y = ((e.client.y + mapElement.scrollTop - 10)/TILE_SIZE).ceil() -1;
    EditorMap curMap = maps.elementAt(0);
    curMap.updateSelector(x, y);
    curMap.reDraw(true);
  });
}

void loadTileSet(){
  tilesetCanvas = _doc.querySelector("#tileset");
  _ctx = tilesetCanvas.getContext("2d");
  _ctx.strokeStyle = '#000';
  _ctx.lineWidth   = 1;
  tilesetCanvas.width = 1024;//384;
  tilesetCanvas.height = 2016;//15096;
  tileElement = _doc.querySelector("#tilesetCont");
  image = new ImageElement(src:'assets/tileset/tileset.png', width:tilesetCanvas.width, height:tilesetCanvas.height);
  image.onLoad.listen((value) => loadTileset());
}

// Listener for the tile selection
void loadTileSelection(){
  tileCanvas = _doc.querySelector("#tile");
  _ctxTile = tileCanvas.getContext("2d");
  _ctxTile.strokeStyle = '#000';
  _ctxTile.lineWidth   = 1;
  tileCanvas.width = TILE_SIZE;
  tileCanvas.height = TILE_SIZE;
  imageTile = new ImageElement(src:'assets/tileset/tileset.png', width:TILE_SIZE, height:TILE_SIZE);
  _ctxTile.strokeRect(0,  0, TILE_SIZE, TILE_SIZE);
  tileSelected = new Tile(0, 0);
  tilesetCanvas.onMouseDown.listen(tilesetPressed);
}

void tilesetPressed(MouseEvent e){
  int x = ((e.client.x + tileElement.scrollLeft)/TILE_SIZE).ceil() -1;
  int y = ((e.client.y + tileElement.scrollTop)/TILE_SIZE).ceil() -1;
  tileSelected = new Tile(x, y);
  _ctxTile.clearRect(0, 0, TILE_SIZE, TILE_SIZE);
  _ctxTile.drawImageToRect(imageTile , new Rectangle(0, 0, TILE_SIZE, TILE_SIZE), //Rect to paint the image
      sourceRect: new Rectangle( x * TILE_SIZE, y* TILE_SIZE, TILE_SIZE, TILE_SIZE)); //Size of the image
  _ctxTile.strokeRect(0,  0, TILE_SIZE, TILE_SIZE);
}

void loadTileset(){
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