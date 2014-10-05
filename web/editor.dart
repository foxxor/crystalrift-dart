/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'editor/editorMap.dart';
import 'editor/menuTileset.dart';
import 'editor/tileSelector.dart';
import 'helpers/matrix.dart';
import 'core/globals.dart';
import 'core/tile.dart';
import 'dart:convert';

//System vars
HtmlDocument _doc;
CanvasRenderingContext2D _ctx;
CanvasRenderingContext2D _ctxTile;
CanvasRenderingContext2D mapCtx;
// Tileset menu canvas
CanvasElement tilesetCanvas;
// Selected Tile canvas
CanvasElement tileCanvas;
// Map canvas
CanvasElement mapCanvas;
ImageElement image;
ImageElement imageTile;
var tileElement;
var mapElement;
var navigation;
var windows;
int currentLayer;
String currentTool;
// List of the maps
List<EditorMap> maps;
// Tileset menu
MenuTileset menuTileset;
// Tile selector
TileSelector tileSelector;
// Current tool in use
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
    Element elem = e.target;
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
        windows.querySelector('#eventWindow').classes.remove('hide');
        break;
      case "io":
        windows.querySelector('#ioWindow').classes.remove('hide');
        break;
    }
  });
}

// Listener for the layer selector
void layerSelection(){
  var layers = _doc.querySelector("#ulLayers");
  layers.onClick.listen((MouseEvent e){
    e.preventDefault();
    Element elem = e.target;
    if(elem.dataset['layer'] != null){
      for (var layer in layers.children) {
        layer.classes.remove('active');
      }
      elem.parent.classes.add('active');
      currentLayer = int.parse(elem.dataset['layer']);
    }
  });
}

// Listener for the tool selected
void toolSelection(){
  var toolsButtons = _doc.querySelector("#toolset");
  var toolPencil = _doc.querySelector("#toolPencil");
  toolPencil.onClick.listen((MouseEvent e){
    e.preventDefault();
    for (var button in toolsButtons.children) {
      button.classes.remove('active');
    }
    toolPencil.classes.add('active');
    currentTool = toolPencil.dataset['tool'];
    EditorMap curMap = maps.elementAt(0);
    curMap.selectionMode = tileSelector.selectionMode;
  });
  
  var toolEraser = _doc.querySelector("#toolEraser");
  toolEraser.onClick.listen((MouseEvent e){
    e.preventDefault();
    for (var button in toolsButtons.children) {
      button.classes.remove('active');
    }
    toolEraser.classes.add('active');
    currentTool = toolEraser.dataset['tool'];
    EditorMap curMap = maps.elementAt(0);
    curMap.selectionMode = SINGLE_TILE_SELECTION;
  });
  
  var genJsonButton = _doc.querySelector("#generateMap");
  genJsonButton.onClick.listen((MouseEvent e){
    EditorMap curMap = maps.elementAt(0);
    String jsonData = JSON.encode(curMap.toJson());
    var jsonTextArea = _doc.querySelector("#genJsonTextArea");
    jsonTextArea.setInnerHtml(jsonData);
  });
  
  var loadJsonButton = _doc.querySelector("#loadJson");
  loadJsonButton.onClick.listen((MouseEvent e){
    var jsonTextArea = _doc.querySelector("#genJsonTextArea");
    String jsonData = jsonTextArea.value;
    Map parsedJson = JSON.decode(jsonData);
    EditorMap curMap = maps.elementAt(0);
    curMap.loadMap(parsedJson);
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
  m1.selectionMode = SINGLE_TILE_SELECTION;
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
    EditorMap curMap = maps.elementAt(0);
    if(curMap.selectionMode == SINGLE_TILE_SELECTION){
      if(dragX != x || dragY != y ){
        int iX = (dragX > x ? x: dragX );
        int iY = (dragY > y ? y: dragY );
        int fX = (dragX > x ? dragX: x );
        int fY = (dragY > y ? dragY: y );
        
          for(num e = iX; e < fX; e++){
            for(num i = iY; i < fY; i++){
              if(currentTool == "pencil"){
                curMap.setTile(e, i, tileSelector.selection.x, tileSelector.selection.y, currentLayer);
              }else{ //Eraser
                curMap.setTile(e, i, 0, 0, currentLayer);
              }
            }
          }
        curMap.stopSelection();
        curMap.update();
      }
    }else{
      int xTile = 0;
      for(num e = x - 1; e < x + curMap.selection.cols - 1; e++){
        int yTile = 0;
        for(num i = y - 1; i < y + curMap.selection.rows - 1; i++){
          Tile curTile = curMap.selection.get(xTile, yTile);
          curMap.setTile(e, i, curTile.x, curTile.y, currentLayer);
          yTile++;
        }
        xTile++;
      }
      curMap.stopSelection();
      curMap.update();
    }
  });
  
  mapCanvas.onMouseDown.listen((MouseEvent e){
    int x = ((e.client.x + mapElement.scrollLeft - 360)/TILE_SIZE).ceil() -1;
    int y = ((e.client.y + mapElement.scrollTop - 10)/TILE_SIZE).ceil() -1;
    dragX = x;
    dragY = y;
    EditorMap curMap = maps.elementAt(0);
    curMap.beginSelection();
    if(curMap.selectionMode == SINGLE_TILE_SELECTION){
      if(currentTool == "pencil"){
        curMap.setTile(x, y, tileSelector.selection.x, tileSelector.selection.y, currentLayer);
      }else{ //Eraser
        curMap.setTile(x, y, 0, 0, currentLayer);
      }
    }
    curMap.update();
  });
  
  //Update the selector position
  mapCanvas.onMouseMove.listen((MouseEvent e){
    int x = ((e.client.x + mapElement.scrollLeft - 360)/TILE_SIZE).ceil() -1;
    int y = ((e.client.y + mapElement.scrollTop - 10)/TILE_SIZE).ceil() -1;
    EditorMap curMap = maps.elementAt(0);
    curMap.updateSelector(x, y);
    curMap.update(true);
  });
}

// Initialization for the tileset menu
void loadTileSet(){
  tilesetCanvas = _doc.querySelector("#tileset");
  _ctx = tilesetCanvas.getContext("2d");
  tileElement = _doc.querySelector("#tilesetCont");
  menuTileset = new MenuTileset(_doc, _ctx, tilesetCanvas, tileElement);
}

// Listener for the tile selection
void loadTileSelection(){
  tileCanvas = _doc.querySelector("#tile");
  _ctxTile = tileCanvas.getContext("2d");
  tileSelector = new TileSelector(_doc, _ctxTile, tileCanvas);
  tileSelector.selectionMode = SINGLE_TILE_SELECTION;
  tileSelector.update();
  tileSelectorBinds();
}

// Listeners for the tileset menu selection
void tileSelectorBinds(){
  int dragX, dragY;
  tilesetCanvas.onMouseDown.listen((MouseEvent e){
    int x = ((e.client.x + tileElement.scrollLeft)/TILE_SIZE).ceil() - 1;
    int y = ((e.client.y + tileElement.scrollTop)/TILE_SIZE).ceil() - 1;
    dragX = x;
    dragY = y;
    menuTileset.beginSelection();
    menuTileset.update();
  });
  
  //This is to multiple select tiles in the tileset area
  tilesetCanvas.onMouseUp.listen((MouseEvent e){
    EditorMap curMap = maps.elementAt(0);
    int x = ((e.client.x + tileElement.scrollLeft)/TILE_SIZE).ceil();
    int y = ((e.client.y + tileElement.scrollTop)/TILE_SIZE).ceil();
    if(dragX != x || dragY != y ){
      int iX = (dragX > x ? x : dragX );
      int iY = (dragY > y ? y : dragY );
      int fX = (dragX > x ? dragX : x );
      int fY = (dragY > y ? dragY : y );
      int dX = (iX - fX).abs();
      int dY = (iY - fY).abs();
      
      if(dX == 1 && dY == 1){
        Tile tileSelected = new Tile(x -1, y -1);
        tileSelector.setSelection(tileSelected);
        tileSelector.setSelectionMode(SINGLE_TILE_SELECTION);
        curMap.setSelection(tileSelected);
        curMap.selectionMode = SINGLE_TILE_SELECTION;
      }else{
        Matrix tilesSelected = new Matrix(dX ,dY);
        int x = 0;
        for(num e = iX; e < fX; e++){
          int y = 0;
          for(num i = iY; i < fY; i++){
            Tile tileSelected = new Tile(e, i);
            tilesSelected.set(x, y, tileSelected);
            y ++;
          }
          x++;
        }
        tileSelector.setSelection(tilesSelected);
        tileSelector.setSelectionMode(MULTI_TILE_SELECTION);
        curMap.setSelection(tilesSelected);
        curMap.selectionMode = MULTI_TILE_SELECTION;
      }
      tileSelector.update();
      menuTileset.stopSelection();
      menuTileset.update();
    }
  });
    
  //Update the selector position
  tilesetCanvas.onMouseMove.listen((MouseEvent e){
    int x = ((e.client.x + tileElement.scrollLeft)/TILE_SIZE).ceil() -1;
    int y = ((e.client.y + tileElement.scrollTop)/TILE_SIZE).ceil() -1;
    menuTileset.updateSelector(x, y);
    menuTileset.update();
  });
}
