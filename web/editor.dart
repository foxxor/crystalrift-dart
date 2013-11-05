/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'editor/editorMap.dart';
import 'core/globals.dart';

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
var tileElement;
var navigation;
var windows;
List<EditorMap> maps;

void main() {
  _doc = window.document;
  loadTileSet();
  initMenuInteraction();
  loadMap();
}

void initMenuInteraction(){
  initTabs();
  loadTileSelection();
}

void initTabs(){
  navigation = _doc.query("#navigation");
  windows = _doc.query("#windows");
  navigation.onClick.listen((MouseEvent e){
    e.preventDefault();
    Element elem = e.toElement;
    String option = elem.dataset['option'];
    navigationHideAll();
    elem.parent.classes.add('active');
    switch (option){
      case "draw":
        windows.query('#drawWindow').classes.remove('hide');
        break;
      case "maps":
        windows.query('#mapWindow').classes.remove('hide');
        break;
      case "events":
        //windows.query('#drawWindow').classes.remove('hide');
        break;
      case "io":
        //windows.query('#drawWindow').classes.remove('hide');
        break;
    }
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

void loadMap(){
  maps = new List<EditorMap>();
  EditorMap m1 = new EditorMap("Map 001", 30, 20);
  mapCanvas = _doc.query("#map");
  mapCtx = mapCanvas.getContext("2d");
  m1.initContext(_doc, mapCtx, mapCanvas);
  maps.add(m1);
  drawMapsList();
}

void drawMapsList(){
  var ul = _doc.query('#mapWindow .list-group');
  for (var m in maps) {
    var li = new Element.html('<li class="list-group-item"><span class="badge">'+m.widthTiles.toString()+' x ' +m.heightTiles.toString()+'</span>'+m.name+'</li>');
    ul.children.add(li);
  }
}

void loadTileSet(){
  tilesetCanvas = _doc.query("#tileset");
  _ctx = tilesetCanvas.getContext("2d");
  _ctx.strokeStyle = '#000';
  _ctx.lineWidth   = 1;
  tilesetCanvas.width = 1024;//384;
  tilesetCanvas.height = 2016;//15096;
  tileElement = _doc.query("#tilesetCont");
  image = new ImageElement(src:'assets/tileset/tileset.png', width:tilesetCanvas.width, height:tilesetCanvas.height);
  image.onLoad.listen((value) => loadTileset());
}

void loadTileSelection(){
  tileCanvas = _doc.query("#tile");
  _ctxTile = tileCanvas.getContext("2d");
  _ctxTile.strokeStyle = '#000';
  _ctxTile.lineWidth   = 1;
  tileCanvas.width = TILE_SIZE;
  tileCanvas.height = TILE_SIZE;
  imageTile = new ImageElement(src:'assets/tileset/tileset.png', width:TILE_SIZE, height:TILE_SIZE);
  _ctxTile.strokeRect(0,  0, TILE_SIZE, TILE_SIZE);
  tilesetCanvas.onMouseDown.listen(tilesetPressed);
}

void tilesetPressed(MouseEvent e){
  int x = ((e.client.x + tileElement.scrollLeft)/TILE_SIZE).ceil() -1;
  int y = ((e.client.y + tileElement.scrollTop)/TILE_SIZE).ceil() -1;
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