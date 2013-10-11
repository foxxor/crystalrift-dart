/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library windowset;

import 'dart:html';
import 'globals.dart';
import 'scene.dart';
import 'graphic.dart';
import '../helpers/coordinate.dart';

class WindowSet implements Graphic{
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement windowImage;
  Coordinate curPos;
  int width;
  int height;
  String text;
  
  WindowSet(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas, int x, int y, int width, int height ){
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    this.width = width;
    this.height = height;
    this.curPos = new Coordinate(x, y);
    loadGraphic('assets/window/BlueGloss.png');
  }
  
  void update(){
    _ctx.save();
    _ctx.globalAlpha = 0.7;
    //Draw background
    _ctx.drawImageScaledFromSource(windowImage, 0, 0, WINDOWSET_BG_TILE, WINDOWSET_BG_TILE,
        curPos.x + WINDOWSET_BORDER_PADDING, curPos.y + WINDOWSET_BORDER_PADDING, 
        width - (WINDOWSET_BORDER_PADDING * 2), height - (WINDOWSET_BORDER_PADDING * 2));
    
    //Draw foreground
    int y = curPos.y;
    for(int x = curPos.x; x <= width ; x = x + WINDOWSET_FG_TILE){
      _ctx.drawImageToRect(windowImage , new Rect(x, y, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE), //Rect to paint the image
          sourceRect: new Rect(0, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE)); //Size of the image
      _ctx.drawImageToRect(windowImage , new Rect(x, y + WINDOWSET_FG_TILE, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE), //Rect to paint the image
          sourceRect: new Rect(0, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE)); //Size of the image
    }
    _ctx.restore();
    
    //Draw border borders
    _ctx.drawImageToRect(windowImage , new Rect(curPos.x, curPos.y, 9, 9), //Rect to paint the image
        sourceRect: new Rect(64, 0, 9, 9)); //Size of the image
    _ctx.drawImageToRect(windowImage , new Rect(curPos.x + width - 8, curPos.y, 10, 9), //Rect to paint the image
        sourceRect: new Rect(64 + 48 + 9, 0, 9, 9)); //Size of the image
    _ctx.drawImageToRect(windowImage , new Rect(curPos.x, curPos.y + height - 8, 9, 9), //Rect to paint the image
        sourceRect: new Rect(64, 48 + 9, 9, 9)); //Size of the image
    _ctx.drawImageToRect(windowImage , new Rect(curPos.x + width - 9, curPos.y + height - 8, 10, 9), //Rect to paint the image
        sourceRect: new Rect(64 + 48 + 9, 48 + 9, 9, 9)); //Size of the image
    
    //Draw border side lines
    _ctx.drawImageScaledFromSource(windowImage, 64 + 9, 0, 9, 9,
        curPos.x + 9, curPos.y, 
        width - (9 * 2) +1, 9);
    _ctx.drawImageScaledFromSource(windowImage, 64 + 9, 0, 9, 9,
        curPos.x + 9, curPos.y + height - 9, 
        width - (9 * 2), 9);
    _ctx.drawImageScaledFromSource(windowImage, 64, 9, 9, 9,
        curPos.x, curPos.y + 9, 
        9, height - (9*2) +1);
    _ctx.drawImageScaledFromSource(windowImage, 64, 9, 9, 9,
        curPos.x + width - 9, curPos.y + 9, 
        9, height - (9*2) +1);
  }
  
  void loadGraphic(String src){
    this.windowImage = new Element.tag('img'); 
    this.windowImage = _doc.createElement('img'); 
    this.windowImage.src = src;
    this.windowImage.onLoad.listen((value) => update());
  }
}