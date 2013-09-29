/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'dart:async';
import 'lib/message.dart';
import 'helpers/coordinate.dart';
import 'core/globals.dart';
import 'core/character.dart';
import 'core/item.dart';
import 'core/scene.dart';
import 'core/tile.dart';
import 'core/action.dart';

//System vars
HtmlDocument _doc;
CanvasRenderingContext2D _ctx;
CanvasElement canvas;
//Character char;
Scene scene;
List<Character> chars; //List of current characters
Character mainCharacter;
List<Item> items;
List<Action> activeEvents;

void main() {
  setupCanvas();
  scene = new Scene(_doc, _ctx, canvas);
  Coordinate initCoor1 = new Coordinate(0,0);
  Coordinate initCoor2 = new Coordinate(2,2);
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
  
  setupKeys();
  window.animationFrame.then(update);
}

//refresh method
void update(num delta) {
  _ctx.clearRect(0, 0, canvas.width, canvas.height);
  scene.update();
  
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
  
  window.animationFrame.then(update);
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

void setupCanvas(){
  _doc = window.document;
  canvas = _doc.query("#canvas");
  canvas.width = SCREEN_WIDTH;
  canvas.height = SCREEN_HEIGHT;
  _ctx = canvas.getContext("2d");
}

bool shallPass(int face, Character c){
  if(scene.nextToTile(c.curPos.x, c.curPos.y, face)){
    return false;
  }
  
  Iterator<Character> charas = chars.iterator;
  while(charas.moveNext()){
    Character char = charas.current;
    int nextTo = char.curPosPx.nextToThis(c.curPosPx);
    if(!char.phasable && nextTo == face){
        return false;
    }
  }
  Iterator<Item> itemsIte = items.iterator;
  while(itemsIte.moveNext()){
    Item item = itemsIte.current;
    int itemFace = item.curPosPx.nextToThis(c.curPosPx);
    if(!item.pushable && itemFace == face){
        return false;
    }else if(itemFace == face){
      if(!item.move(itemFace)){
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

//Keyboard and keybinding

void setupKeys(){
  canvas.onKeyDown.listen((e) {
    reactKey(e);
  });
  canvas.onKeyUp.listen((e) {
    mainCharacter.stopMove();
  });
}

void reactKey(var evt) {
  if(evt.keyCode == 37 || evt.keyCode == 65 ) { //left
    if(shallPass(LEFT,mainCharacter)){
      mainCharacter.move(LEFT);
    }else{
      mainCharacter.faceDirection(LEFT);
    }
  }else if(evt.keyCode == 38 || evt.keyCode == 87 ){ //up
    if(shallPass(UP,mainCharacter)){
      mainCharacter.move(UP);
    }else{
      mainCharacter.faceDirection(UP);
    }
  }else if(evt.keyCode == 39 || evt.keyCode == 68 ){ //right
    if(shallPass(RIGHT,mainCharacter)){
      mainCharacter.move(RIGHT);
    }else{
      mainCharacter.faceDirection(RIGHT);
    }
  }else if(evt.keyCode == 40 || evt.keyCode == 83 ){ //down
    if(shallPass(DOWN,mainCharacter)){
      mainCharacter.move(DOWN);
    }else{
      mainCharacter.faceDirection(DOWN);
    }
  }else if(evt.keyCode == 13 ){ //Action
    Character c = getCharacterInFront();
    if(c != null){
      if(!c.trigger){
        c.trigger = true;
        createMessage(c);
      }
    }
  }
  
}
