/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library scene;

import 'dart:html';
import 'dart:async';
import 'dart:json';
import 'globals.dart';
import '../helpers/coordinate.dart';
import '../lib/message.dart';
import 'mapset.dart';
import 'character.dart';
import 'item.dart';
import 'tile.dart';
import 'action.dart';

class Scene{
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  
  MapSet gameMap;
  List<Character> chars; //List of current characters
  Character mainCharacter;
  List<Item> items;
  List<Action> activeEvents;
  int offsetX;
  int offsetY;
  
  Scene(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas) {
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    
    gameMap = new MapSet(_doc, _ctx, canvas);
    Coordinate initCoor = new Coordinate(10, 6);
    mainCharacter = new Character(_doc, _ctx, canvas, initCoor, 0, this, ""); //Main Player
    chars = new List<Character>();
    
    Coordinate initCoor3 = new Coordinate(5,8);
    Coordinate initCoor4 = new Coordinate(3,5);
    Tile tile = new Tile(20, 34);
    Tile tile2 = new Tile(5, 31);
    Item item1 = new Item(_doc, _ctx, canvas, initCoor3, tile, this, true);
    Item item2 = new Item(_doc, _ctx, canvas, initCoor4, tile2, this, true);
    items = new List<Item>();
    items.add(item1);
    items.add(item2);
    //offsetX = 3; TO-DO: Camera offset
    //offsetY = 3;
    activeEvents = new List<Action>();
    loadFiles();
  }
  
  void update(){
    gameMap.offsetX = offsetX;
    gameMap.offsetY = offsetY;
    gameMap.update();
    
    Iterator<Character> charas = chars.iterator;
    while(charas.moveNext()){
      Character c = charas.current;
      c.offsetX = offsetX;
      c.offsetY = offsetY;
      c.update();
    }
    
    Iterator<Item> itemsIte = items.iterator;
    while(itemsIte.moveNext()){
      Item i = itemsIte.current;
      i.update();
    }
    mainCharacter.update();  
    
    Iterator<Action> eventIte = activeEvents.iterator;
    while(eventIte.moveNext()){
      Action e = eventIte.current;
      e.update();
    }
  }
  
  void loadFiles(){
    var request = HttpRequest.getString("data/characters.json").then(loadCharacters);
    var request2 = HttpRequest.getString("data/structures.json").then(loadStructures);
  }
  
  void loadCharacters(String responseText) {
    Map charactersData = parse(responseText);
    Iterator<Map> characters = charactersData['characters'].iterator;
    while(characters.moveNext()){
      Map m = characters.current;
      Coordinate coords = new Coordinate(m['xTile'], m['yTile']);
      Character character = new Character(_doc, _ctx, canvas, coords, m['characterId'], this, m['message']);
      if(m['moveRandom']){
        character.moveRandom();
      }
      chars.add(character);
    }
  }
  
  void loadStructures(String responseText) {
    gameMap.structuresData = parse(responseText);
    gameMap.addBuilding(0, 6,5);
    gameMap.addRandomDetails();
  }
  
  void createMessage(Character char){
    Message msg = new Message(_ctx, char.message, char.curPosPx.x, char.curPosPx.y, 100, 10);
    const ms = const Duration(milliseconds: 5000);
    Timer t = new Timer( ms, removeEvent);
    Action event = new Action(char, msg, EVENT_TYPE_MESSAGE);
    activeEvents.add(event);
  }
  
  void removeEvent(){
    Action event = activeEvents.elementAt(0);
    if(event.type == EVENT_TYPE_MESSAGE){
      Character char = event.object;
      char.trigger = false;
    }
    activeEvents.removeAt(0);
  }
  
  bool shallPass(int face, var c){
    if(gameMap.nextToTile(c.curPos.x, c.curPos.y, face)){
      return false;
    }
    
    Iterator<Character> charas = chars.iterator;
    while(charas.moveNext()){
      Character char = charas.current;
      bool nextTo = char.curPosPx.nextToThis(face, c.curPosPx);
      if(!char.phasable && nextTo){
        return false;
      }
    }
    
    Iterator<Item> itemsIte = items.iterator;
    while(itemsIte.moveNext()){
      Item item = itemsIte.current;
      bool itemFace = item.curPosPx.nextToThis(face ,c.curPosPx);
      if(!item.pushable && itemFace){
          return false;
      }else if(itemFace){
        if(!item.move(face)){
          return false;
        }
      }
    }
    return true;
  }
  
  Character getCharacterInFront(){
    Iterator<Character> charas = chars.iterator;
    while(charas.moveNext()){
      Character char = charas.current;
      int charFace = char.curPosPx.facingThis(mainCharacter.getCurrentDirection(), mainCharacter.curPosPx);
      if(charFace >= 0){
        char.faceDirection(charFace);
        return char;
      }
    }
    return null;
  }
  
}