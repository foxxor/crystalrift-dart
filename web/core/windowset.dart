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
    this.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec tincidunt posuere nibh, vitae dignissim ligula molestie nec. Fusce in mauris nibh. Vivamus sodales vitae eros et dapibus. Donec vitae leo tincidunt risus viverra dapibus. Donec sit amet eros rhoncus lacus aliquam laoreet. Nulla id augue quis nisl tempor ullamcorper. Maecenas lacinia lectus vel erat eleifend egestas.";
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
      _ctx.drawImageToRect(windowImage , new Rectangle(x, y, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE), //Rect to paint the image
          sourceRect: new Rectangle(0, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE)); //Size of the image
      _ctx.drawImageToRect(windowImage , new Rectangle(x, y + WINDOWSET_FG_TILE, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE), //Rect to paint the image
          sourceRect: new Rectangle(0, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE)); //Size of the image
    }
    _ctx.restore();
    
    //Draw border borders
    _ctx.drawImageToRect(windowImage , new Rectangle(curPos.x, curPos.y, 9, 9), //Rect to paint the image
        sourceRect: new Rectangle(64, 0, 9, 9)); //Size of the image
    _ctx.drawImageToRect(windowImage , new Rectangle(curPos.x + width - 8, curPos.y, 10, 9), //Rect to paint the image
        sourceRect: new Rectangle(64 + 48 + 9, 0, 9, 9)); //Size of the image
    _ctx.drawImageToRect(windowImage , new Rectangle(curPos.x, curPos.y + height - 8, 9, 9), //Rect to paint the image
        sourceRect: new Rectangle(64, 48 + 9, 9, 9)); //Size of the image
    _ctx.drawImageToRect(windowImage , new Rectangle(curPos.x + width - 9, curPos.y + height - 8, 10, 9), //Rect to paint the image
        sourceRect: new Rectangle(64 + 48 + 9, 48 + 9, 9, 9)); //Size of the image
    
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
    
    drawText();
  }
  
  void drawText() {
    num x = curPos.x + WINDOWSET_TEXT_PADDING;
    num y = curPos.y + WINDOWSET_TEXT_PADDING + 10;
    var words = text.split(" ");
    var line = "";
    var numLines = 0;
    _ctx..save()
      ..font = '12pt Verdana'
      ..fillStyle = "white"
      ..lineWidth = 3
      ..strokeStyle = "black";
    //Shadow Text
    _ctx..shadowOffsetX = 0
        ..shadowOffsetY = 0
        ..shadowBlur    = 5
        ..shadowColor = 'rgba(0, 0, 0, 1)';
    
    for(var n = 0; n < words.length; n++) {
      var testLine = '${line}${words[n]} ';
      var metrics = _ctx.measureText(testLine);
      var testWidth = metrics.width;
      if(testWidth > (width - (WINDOWSET_TEXT_PADDING* 2))) {
        _ctx.fillText(line, x, y);
        line = '${words[n]} ';
        y += 25;
        numLines ++;
      }
      else { line = testLine; }
      
      if(numLines >= 4)
        break;
    }
    _ctx.restore();
  }
  
  void loadGraphic(String src){
    this.windowImage = new Element.tag('img'); 
    this.windowImage = _doc.createElement('img'); 
    this.windowImage.src = src;
    this.windowImage.onLoad.listen((value) => update());
  }
}