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
import 'animation.dart';
import 'particle.dart';

class Scene{
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  
  MapSet gameMap;
  List<Character> chars; //List of current characters
  Character mainCharacter;
  List<Item> items;
  List<Action> activeEvents;
  List<Animation> activeAnimations;
  Particle particle;
  int offsetX;
  int offsetY;
  
  Scene(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas) {
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    gameMap = new MapSet(_doc, _ctx, canvas);
    Coordinate initCoor = new Coordinate(10, 6);
    Coordinate initCoor2 = new Coordinate(12 * TILE_SIZE, 4* TILE_SIZE);
    Animation animation = new Animation(_doc, _ctx, canvas, initCoor2, 'fire_001');
    animation.startAnimation();
    
    Coordinate partCoor = new Coordinate(12 * TILE_SIZE, 7 * TILE_SIZE);
    particle = new Particle(_doc, _ctx, canvas, partCoor, "fire");
    particle.start();
    activeAnimations = new List<Animation>();
    activeAnimations.add(animation);
    mainCharacter = new Character(_doc, _ctx, canvas, initCoor, 0, this, ""); //Main Player
    chars = new List<Character>();
    items = new List<Item>();
    //offsetX = 3; TO-DO: Camera offset
    //offsetY = 3;
    activeEvents = new List<Action>();
    loadProperties();
  }
  
  void update(){
    //The order of rendering here controls the priority of visualization
    
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
    
    Iterator<Animation> animationsIte = activeAnimations.iterator;
    while(animationsIte.moveNext()){
      Animation a = animationsIte.current;
      a.update();
    }
    particle.update();
    
    Iterator<Action> eventIte = activeEvents.iterator;
    while(eventIte.moveNext()){
      Action e = eventIte.current;
      e.update();
    }
  }
  
  void loadProperties(){
    var request = HttpRequest.getString("data/characters.json").then(loadCharacters);
    var request2 = HttpRequest.getString("data/structures.json").then(loadStructures);
    var request3 = HttpRequest.getString("data/items.json").then(loadItems);
  }
  
  void loadItems(String responseText){
    Map itemsData = parse(responseText);
    Iterator<Map> iteItems = itemsData['items'].iterator;
    while(iteItems.moveNext()){
      Map i = iteItems.current;
      Coordinate coords = new Coordinate(i['x'], i['y']);
      Tile tile = new Tile(i['xTile'], i['yTile']);
      Item item = new Item(_doc, _ctx, canvas, coords, tile, this, i['pushable']);
      items.add(item);
    }
  }
  
  void loadCharacters(String responseText) {
    Map charactersData = parse(responseText);
    Iterator<Map> characters = charactersData['characters'].iterator;
    while(characters.moveNext()){
      Map m = characters.current;
      Coordinate coords = new Coordinate(m['x'], m['y']);
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
  
  void createAnimation(Character char){
    Coordinate coord = new Coordinate(0,0);
    Animation animation = new Animation(_doc, _ctx, canvas, coord, 'light_002');
    animation.startAnimation();
    const ms = const Duration(milliseconds: 10000);
    Timer t = new Timer( ms, removeEvent);
    Action event = new Action(char, animation, EVENT_TYPE_ANIMATION);
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