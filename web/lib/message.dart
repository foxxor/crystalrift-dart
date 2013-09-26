/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library message;

import 'dart:html';

wrapText(context, String text, x, y, maxWidth, lineHeight) {
  x -= text.length * 2.5;
  y -= 8;
  var words = text.split(" ");
  var line = "";
  for(var n = 0; n < words.length; n++) {
    var testLine = '${line}${words[n]} ';
    var metrics = context.measureText(testLine);
    var testWidth = metrics.width;
    if(testWidth > maxWidth) {
      context.fillText(line, x, y);
      line = '${words[n]} ';
      y += lineHeight;
    }
    else { line = testLine; }
  }
  context.save();
  context.font = '12pt Verdana';
  context.fillStyle = "white";
  //context.shadowOffsetX = 0;
  //context.shadowOffsetY = 0;
  //context.shadowBlur    = 5;
  //context.shadowColor = 'rgba(0, 0, 0, 1)';
  
  context.lineWidth = 3;
  context.strokeStyle = "black";
  context.strokeText(line, x, y);
  context.fillText(line, x, y);
  context.restore();
  //context.stroke();
}
