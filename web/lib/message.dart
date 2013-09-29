/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library message;

import 'dart:html';

class Message{
  CanvasRenderingContext2D _ctx; 
  String text;
  num x;
  num y;
  int maxWidth;
  int lineHeight;
  int duration;
  
  Message(CanvasRenderingContext2D context, String text, num x, num y, int maxWidth, int lineHeight, [int duration = 10]){
    this._ctx = context;
    this.text = text;
    this.x = x;
    this.y = y;
    this.maxWidth = maxWidth;
    this.lineHeight = lineHeight;
    this.duration = duration;
    wrapText();
  }
  
  wrapText() {
    x -= text.length * 2.5;
    y -= 8;
    var words = text.split(" ");
    var line = "";
    for(var n = 0; n < words.length; n++) {
      var testLine = '${line}${words[n]} ';
      var metrics = _ctx.measureText(testLine);
      var testWidth = metrics.width;
      if(testWidth > maxWidth) {
        _ctx.fillText(line, x, y);
        line = '${words[n]} ';
        y += lineHeight;
      }
      else { line = testLine; }
    }
    _ctx..save()
        ..font = '12pt Verdana'
        ..fillStyle = "white"
        ..lineWidth = 3
        ..strokeStyle = "black";
    
    //Shadow Text
    //_ctx..shadowOffsetX = 0
    //    ..shadowOffsetY = 0
    //    ..shadowBlur    = 5
    //    ..shadowColor = 'rgba(0, 0, 0, 1)';
    
    //Stroke
    _ctx.strokeText(line, x, y);
    _ctx.fillText(line, x, y);
    _ctx.restore();
  }
  
  void update(){
    wrapText();
  }
}


