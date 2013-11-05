/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library editorMap;

import 'dart:html';

class EditorMap{
  
  String name;
  int widthTiles;
  int heightTiles;
  
  EditorMap(String name, int width, int height){
    this.name = name;
    this.widthTiles = width;
    this.heightTiles = height;
  }
}