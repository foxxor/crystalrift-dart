/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library scene;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'globals.dart';
import '../helpers/coordinate.dart';
import '../lib/message.dart';
import 'mapset.dart';
import 'character.dart';
import 'entity.dart';
import 'tile.dart';
import 'action.dart';
import 'animation.dart';
import 'particle.dart';
import 'dart:math' as Math;

class Scene{
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  
  MapSet gameMap;
  List<Character> chars; //List of current characters
  Character mainCharacter;
  List<Entity> entities;
  List<Action> activeEvents;
  List<Animation> activeAnimations;
  Particle particle;
  
  //Camera offset tiles
  int displayX;
  int displayY;
  
//Camera offset tiles
  int displayPxX;
  int displayPxY;
  
  Scene(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas) {
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    gameMap = new MapSet(_doc, _ctx, canvas, this);
    Coordinate initCoor = new Coordinate(10, 6);
    Coordinate initCoor2 = new Coordinate(12 * TILE_SIZE, 4* TILE_SIZE);
    Animation animation = new Animation(_doc, _ctx, canvas, this, initCoor2, 'fire_001');
    animation.startAnimation();
    Coordinate partCoor = new Coordinate(12 * TILE_SIZE, 7 * TILE_SIZE);
    particle = new Particle(_doc, _ctx, canvas, this, partCoor, "fire");
    particle.start();
    activeAnimations = new List<Animation>();
    activeAnimations.add(animation);
    mainCharacter = new Character(_doc, _ctx, canvas, initCoor, 0, this, ""); //Main Player
    //mainCharacter.moveTo( 13, 4);
    chars = new List<Character>();
    entities = new List<Entity>();
    displayX = 0;
    displayY = 0;
    displayPxX = 0 * TILE_SIZE;
    displayPxY = 0 * TILE_SIZE;
    activeEvents = new List<Action>();
    loadProperties();
  }
  
  void update(){
    //The order of rendering here controls the priority of visualization
    if(isMoving() && mainCharacter.isMoving()){
      updateMove();
    }else{
      stopMove();
    }
    gameMap.update();
    Iterator<Character> charas = chars.iterator;
    while(charas.moveNext()){
      Character c = charas.current;
      c.update();
    }
    Iterator<Entity> entitiesIte = entities.iterator;
    while(entitiesIte.moveNext()){
      Entity i = entitiesIte.current;
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
  
  void updateMove(){
    var distance = 2 * mainCharacter.speed;
    if(displayY * TILE_SIZE > displayPxY){
      displayPxY = Math.min(displayPxY + distance, displayY * TILE_SIZE);
    }
    if(displayX * TILE_SIZE > displayPxX){
      displayPxX = Math.min(displayPxX + distance, displayX * TILE_SIZE);  
    }
    if(displayY * TILE_SIZE < displayPxY){
      displayPxY = Math.max(displayPxY - distance, displayY * TILE_SIZE);
    }
    if(displayX * TILE_SIZE < displayPxX){
      displayPxX = Math.max(displayPxX - distance, displayX * TILE_SIZE);
    }
  }
  
  bool isMoving(){
    return (displayPxX != displayX * TILE_SIZE || displayPxY != displayY * TILE_SIZE);
  }
  
  void stopMove(){
    if(displayY * TILE_SIZE > displayPxY){
      num dy = (displayY + (TILE_SIZE - (displayPxY % TILE_SIZE))) / TILE_SIZE;
      displayY = Math.min(dy.floor(), displayY);
    }
    if(displayX * TILE_SIZE > displayPxX){
      num dx = (displayX + (TILE_SIZE - (displayPxX % TILE_SIZE))) / TILE_SIZE;
      displayX = Math.min(dx.floor(), displayX);
    }
    if(displayY * TILE_SIZE < displayPxY){
      num dy = (displayPxY + (TILE_SIZE - (displayPxY % TILE_SIZE))) / TILE_SIZE;
      displayY = Math.max(dy.floor(), displayY) -1;
    }
    if(displayX * TILE_SIZE < displayPxY){
      num dx = (displayPxX + (TILE_SIZE - (displayPxX % TILE_SIZE))) / TILE_SIZE;
      displayX = Math.max(dx.floor(), displayX) -1;
    }
  }
  
  void move(int direction){
    switch (direction){
      case UP:
        mainCharacter.move(UP);
        if(mainCharacter.curPos.y > (CAMERA_HEIGHT_TILES / 2 )
            && mainCharacter.curPos.y < (MAP_HEIGHT_TILES - displayY)
            && mainCharacter.curPos.y < MAP_HEIGHT_TILES - (CAMERA_HEIGHT_TILES / 2)){
          centerCamera(2);
        }
        break;
      case DOWN:
        mainCharacter.move(DOWN);
        if(mainCharacter.curPos.y > (CAMERA_HEIGHT_TILES / 2 )
            && mainCharacter.curPos.y < (MAP_HEIGHT_TILES - displayY)
            && mainCharacter.curPos.y < MAP_HEIGHT_TILES - (CAMERA_HEIGHT_TILES / 2)){
          centerCamera(2);
        }
        break;
      case LEFT:
        mainCharacter.move(LEFT);
        if(mainCharacter.curPos.x < (MAP_WIDTH_TILES - displayX)
            && mainCharacter.curPos.x < MAP_WIDTH_TILES - (CAMERA_WIDTH_TILES / 2)
            && mainCharacter.curPos.x < MAP_WIDTH_TILES - (CAMERA_WIDTH_TILES / 2)){
          centerCamera(1);
        }
        break;
      case RIGHT:
        mainCharacter.move(RIGHT);
        if(mainCharacter.curPos.x < (MAP_WIDTH_TILES - displayX)
            && mainCharacter.curPos.x < MAP_WIDTH_TILES - (CAMERA_WIDTH_TILES / 2)
            && mainCharacter.curPos.x < MAP_WIDTH_TILES - (CAMERA_WIDTH_TILES / 2)){
          centerCamera(1);
        }
        break;  
    }
  }
  
  void centerCamera(int type){
    if(type == 1){
      displayX = Math.max(Math.min(mainCharacter.curPos.x - (CAMERA_WIDTH_TILES / 2).floor(), MAP_WIDTH_TILES), 0);
    }else{
      displayY = Math.max(Math.min(mainCharacter.curPos.y - (CAMERA_HEIGHT_TILES / 2).floor(), MAP_HEIGHT_TILES), 0);
    }
  }
  
  void loadProperties(){
    var request = HttpRequest.getString("data/characters.json").then(loadCharacters);
    var request2 = HttpRequest.getString("data/structures.json").then(loadStructures);
    var request3 = HttpRequest.getString("data/entities.json").then(loadEntities);
  }
  
  void loadEntities(String responseText){
    Map entitiesData = JSON.decode(responseText);
    Iterator<Map> iteEntities = entitiesData['entities'].iterator;
    while(iteEntities.moveNext()){
      Map i = iteEntities.current;
      Coordinate coords = new Coordinate(i['x'], i['y']);
      Tile tile = new Tile(i['xTile'], i['yTile']);
      Entity item = new Entity(_doc, _ctx, canvas, coords, tile, this, i['pushable']);
      entities.add(item);
    }
  }
  
  void loadCharacters(String responseText) {
    Map charactersData = JSON.decode(responseText);
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
    gameMap.structuresData = JSON.decode(responseText);
    gameMap.addBuilding(0, 6,5);
    gameMap.addRandomDetails();
  }
  
  void createMessage(Character char){
    Message msg = new Message(_ctx, char.message, char.curPosPx.x, char.curPosPx.y, 100, 20);
    const ms = const Duration(milliseconds: 5000);
    Timer t = new Timer( ms, removeEvent);
    Action event = new Action(char, msg, EVENT_TYPE_MESSAGE);
    activeEvents.add(event);
  }
  
  void createAnimation(Character char){
    Coordinate coord = new Coordinate(0,0);
    Animation animation = new Animation(_doc, _ctx, canvas, this, coord, 'light_002');
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
    Coordinate newCoords;
    if(face == UP){
      newCoords = new Coordinate(c.curPos.x, c.curPos.y - 1);
    }else if(face == DOWN){
      newCoords = new Coordinate(c.curPos.x, c.curPos.y + 1);
    }else if(face == LEFT){
      newCoords = new Coordinate(c.curPos.x -1, c.curPos.y);
    }else if(face == RIGHT){
      newCoords = new Coordinate(c.curPos.x +1, c.curPos.y);
    }
    
    if(gameMap.nextToTile(c.curPos.x, c.curPos.y, face)){
      return false;
    }
    Iterator<Character> charas = chars.iterator;
    while(charas.moveNext()){
      Character char = charas.current;
      bool nextTo = char.curPos.nextToThis2(newCoords);
      if(!char.phasable && nextTo){
        return false;
      }
    }
    if(c != mainCharacter){
      bool nextTo = mainCharacter.curPos.nextToThis2(newCoords);
      if(!mainCharacter.phasable && nextTo){
        return false;
      }
    }
    
    Iterator<Entity> entitiesIte = entities.iterator;
    while(entitiesIte.moveNext()){
      Entity item = entitiesIte.current;
      bool itemFace = item.curPos.nextToThis2(newCoords);
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