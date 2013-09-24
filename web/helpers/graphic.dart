import 'dart:html';
import 'globals.dart';

class Graphic {
  
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  ImageElement characterImage;
  
  void init(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas){
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
  }
  
}