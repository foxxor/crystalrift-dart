/*
  * Copyright (C) 2015 Jorge Vargas <vargasjorgeluis@gmail.com>
  * 
  * This class represents the assets tree necesary to create events and elements.
*/
library fileScan;

import 'dart:html';
import 'dart:async';
import 'dart:convert';

class FileScan{
  List<String> characters;
  List<String> tilesets;
  List<String> icons;

  FileScan(){
    characters = new List<String>();
    tilesets = new List<String>();
    icons = new List<String>();
    HttpRequest.getString("editor/data/files.json").then(generateTree);
  }
  
  void generateTree(String responseText){
    Map foldersData = JSON.decode(responseText);
    Iterator<String> iteratorCharacters = foldersData['folders']['characters'].iterator;
    while(iteratorCharacters.moveNext()){
      String fileName = iteratorCharacters.current;
      characters.add(fileName);
    }
    Iterator<String> iteratorTilesets = foldersData['folders']['tilesets'].iterator;
    while(iteratorTilesets.moveNext()){
      String fileName = iteratorTilesets.current;
      tilesets.add(fileName);
    }
    Iterator<String> iteratorIcons = foldersData['folders']['icons'].iterator;
    while(iteratorIcons.moveNext()){
      String fileName = iteratorIcons.current;
      icons.add(fileName);
    }
  }
}