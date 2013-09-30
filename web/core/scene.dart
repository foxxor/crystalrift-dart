/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library scene;

import 'dart:html';
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
  
  Scene(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas) {
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    gameMap = new MapSet(_doc, _ctx, canvas);
    
    Coordinate initCoor1 = new Coordinate(10, 6);
    Coordinate initCoor2 = new Coordinate(2, 2);
    mainCharacter = new Character(_doc, _ctx, canvas, initCoor1, 0); //Main Player
    Character char2 = new Character(_doc, _ctx, canvas, initCoor2, 2);
    chars = new List<Character>();
    //char2.randomMovement = true;
    chars.add(char2);
    
    Coordinate initCoor3 = new Coordinate(5,8);
    Coordinate initCoor4 = new Coordinate(3,5);
    Tile tile = new Tile(20, 34);//(7, 32); //Rock
    Tile tile2 = new Tile(5, 31);
    Item item1 = new Item(_doc, _ctx, canvas, initCoor3, tile, true);
    Item item2 = new Item(_doc, _ctx, canvas, initCoor4, tile2, true);
    items = new List<Item>();
    items.add(item1);
    items.add(item2);
    
    activeEvents = new List<Action>();
  }
  
  void update(){
    gameMap.update();
    
    Iterator<Character> charas = chars.iterator;
    while(charas.moveNext()){
      Character c = charas.current;
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
  

  void createMessage(Character char){
    Message msg = new Message(_ctx, 'ola k ase', char.curPosPx.x, char.curPosPx.y, 100, 10);
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
  
  bool shallPass(int face, Character c){
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