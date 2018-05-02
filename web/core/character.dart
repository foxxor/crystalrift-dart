library character;

import 'dart:html' hide Matrix;
import 'dart:async';
import 'globals.dart';
import 'scene.dart';
import 'graphic.dart';
import '../helpers/coordinate.dart';
import '../helpers/matrix.dart';
import 'dart:math' as Math;

class Character implements Graphic {
  
  //Graphic vars
  HtmlDocument document;
  CanvasRenderingContext2D context;
  CanvasElement canvas;
  ImageElement characterImage;
  
  // Current position in tiles
  Coordinate curPos;

  // Current position in pixels
  Coordinate curPosPx;

  // Current position relative to screen in pixels
  Coordinate screenPosPx;

  // Current animation frame
  int frame;

  // Facing direction
  int faceDir;

  // Current selected char
  int selectedChar;

  // Current selected char row
  int characterRow;

  // Make this character move randomly
  bool randomMovement;

  // Is this object phasable?
  bool phasable;

  // Character movement speed
  num speed;

  // Character is chasing?
  bool chasing;

  // Who is this chasing?
  Character chased;

  // Event is executing?
  bool trigger;
  
  //Parent scene calling this class
  Scene scene;
  
  // Current position offset in tiles
  int offsetX;
  int offsetY;
  
  Character( Coordinate this.curPos, int selectedChar, int characterRow, Scene this.scene, String imageSource, 
      [num this.speed = 1]) {
    this.document = scene.document;
    this.context = scene.context;
    this.canvas = scene.canvas;
    
    this.randomMovement = false;
    this.phasable = false;
    this.curPosPx = new Coordinate(curPos.x * TILE_SIZE, curPos.y * TILE_SIZE);
    this.screenPosPx = new Coordinate(0, 0);
    this.frame = INITIAL_FRAME;
    this.faceDir = INITIAL_FACE;
    this.trigger = false;
    this.chasing = false;
    offsetX = 0;
    offsetY = 0;
    this.selectedChar = selectedChar * 3; //This calculation is cached for performance 
    this.characterRow = (characterRow - 1 ) * (TILE_SIZE * 4); //This calculation is cached for performance 
    loadGraphic("assets/character/" + imageSource);
  }

  Future moveRandom() async {
    const ms = const Duration(milliseconds: 2000);
    new Timer( ms, randomMove);
  }

  void randomMove(){
    var random = new Math.Random();
    var number = random.nextInt(4);
    move(number);
    moveRandom();
  }
  
  void chaseCharacter(Character chased){
    chasing = true;
    this.chased = chased;
  }
  
  void stopChasing(){
    chasing = false;
    chased = null;
  }
  
  void moveTo(int x, int y){
    Coordinate goal = new Coordinate(x, y);
    if(identical(curPos, goal)){
      return;
    }
    List<Coordinate> closed = new List();
    List<Coordinate> open = new List();
    Matrix openUsed = new Matrix(scene.gameMap.eventMapset.cols, scene.gameMap.eventMapset.rows);
    Matrix closedUsed = new Matrix(scene.gameMap.eventMapset.cols, scene.gameMap.eventMapset.rows);
    open.add(curPos);
    openUsed.set(curPos.x, curPos.y, true);
    int iterations = 0;
    bool goalReached = false;
    
    
    while(!goalReached){
      iterations++ ;
      if(MAX_PATHFINDING_ITERATIONS == iterations){
        return;
      }
      Coordinate current = open.last;
      if(current == null){
        return;
      }
      List neighbours = getNeighbours(current, goal);
      Iterator<Coordinate> neighboursIte = neighbours.iterator;
      Coordinate bestNode;
      num bestDistance = 100;
      while(neighboursIte.moveNext()){
        Coordinate node = neighboursIte.current;
        if(node.isTheSame(goal)){
          recreatePath(open);
          return;
        }
        if(closedUsed.get(node.x, node.y) == true){
          continue;
        }
        num nodeDistance = goal.distanceToThis(node);
        if(bestDistance > nodeDistance){
          bestDistance = nodeDistance;
          bestNode = node;
        }
      }
      if(openUsed.get(bestNode.x, bestNode.y) == null || openUsed.get(bestNode.x, bestNode.y) == false){
        open.add(bestNode);
        openUsed.set(bestNode.x, bestNode.y, true);
      }
      closed.add(current);
      closedUsed.set(current.x, current.y, true);
    }
  }
  
  void recreatePath(List<Coordinate> open){
    Iterator<Coordinate> openIte = open.iterator;
    while(openIte.moveNext()){
      Coordinate node = openIte.current;
      if(node.x > curPos.x){
        move(RIGHT);
      }else if(node.x < curPos.x){
        move(LEFT);
      }else if(node.y > curPos.y){
        move(DOWN);
      }else if(node.y < curPos.y){
        move(UP);
      }
    }
  }
  
  List getNeighbours(Coordinate node, Coordinate goal){
    List neighbours = new List();
    if(node.y - 1 >= 0){
      Coordinate neighbour1 = new Coordinate(node.x, node.y - 1);
      if(scene.objectIsPassable(this, neighbour1, UP) || neighbour1.isTheSame(goal) ){
        neighbours.add(neighbour1);
      }
    }
    if(node.y + 1 < scene.gameMap.eventMapset.rows){
      Coordinate neighbour2 = new Coordinate(node.x, node.y + 1);
      if(scene.objectIsPassable(this, neighbour2, DOWN) || neighbour2.isTheSame(goal)){
        neighbours.add(neighbour2);
      }
    }
    if(node.x - 1 >= 0){
      Coordinate neighbour3 = new Coordinate(node.x - 1, node.y);
      if(scene.objectIsPassable(this, neighbour3, LEFT)  || neighbour3.isTheSame(goal)){
          neighbours.add(neighbour3);
        }
    }
    if(node.x + 1 < scene.gameMap.eventMapset.cols){
       Coordinate neighbour4 = new Coordinate(node.x +1, node.y);
       if(scene.objectIsPassable(this, neighbour4, RIGHT) || neighbour4.isTheSame(goal)){
         neighbours.add(neighbour4);
       }
    }
    
    return neighbours;
  }
  
  bool move(int face){
    bool moved = false;
    int initX = curPos.x;
    int initY = curPos.y;
    if(!scene.shallPass(face, this)){
      faceDirection(face);
      return false;
    }
    
    switch (face) {
      case 0: //up
        faceDirection(UP);
        if(curPos.y > 0){
          curPos.y --;
          moved = true;
        }
        break;
      case 1: //down
        faceDirection(DOWN);
        if((curPos.y)  < MAP_HEIGHT_TILES - 1){
          curPos.y ++;
          moved = true;
        }
        break;
      case 2: //left
        faceDirection(LEFT);
        if(curPos.x > 0){
          curPos.x --;
          moved = true;
        }
        break;
      case 3: //right
        faceDirection(RIGHT);
        if((curPos.x) < MAP_WIDTH_TILES - 1){
          curPos.x ++;
          moved = true;
        }
        break;
    }

    // Throttle the movement to avoid camera issues
    if(curPos.y * TILE_SIZE > (curPosPx.y + (2 * TILE_SIZE))){
      curPos.y = (curPosPx.y / TILE_SIZE).ceil();
    }
    if(curPos.x * TILE_SIZE > (curPosPx.x + (2 * TILE_SIZE))){
      curPos.x = (curPosPx.x / TILE_SIZE).ceil();
    }
    if(curPos.y * TILE_SIZE < (curPosPx.y - (2 * TILE_SIZE))){
      curPos.y = (curPosPx.y / TILE_SIZE).floor();
    }
    if(curPos.x * TILE_SIZE < (curPosPx.x - (2 * TILE_SIZE))){
      curPos.x = (curPosPx.x / TILE_SIZE).floor();
    }
    
    if(moved){
      scene.gameMap.moveToTile(initX, initY, curPos.x, curPos.y, this);
      return true;
    }
    return false;
  }
  
  void faceDirection(int direction){
    switch (direction) {
      case DOWN: //down
        faceDir = 0;
        break;
      case LEFT: //left
        faceDir = 1;
        break;
      case RIGHT: //right
        faceDir = 2;
        break;
      case UP: //up
        faceDir = 3;
        break;
    }
  }
  
  int getCurrentDirection(){
    switch (faceDir) {
      case 0: //down
        return DOWN;
      case 1: //left
        return LEFT;
      case 2: //right
        return RIGHT;
      case 3: //up
        return UP;
    }

    return -1;
  }
  
  void loadGraphic(String src){
    this.characterImage = new Element.tag('img'); 
    this.characterImage = document.createElement('img'); 
    this.characterImage.src = src;
  }

  void animate(){
    frame ++;
    if(frame > 2 * ANIMATION_SPEED){
      frame = 0;
    }
  }

  void updateMove(){
    num distance = 2 * this.speed ;
    if(curPos.y * TILE_SIZE > curPosPx.y){
      faceDirection(DOWN);
      curPosPx.y = Math.min(curPosPx.y + distance, curPos.y * TILE_SIZE);
    }
    if(curPos.x * TILE_SIZE > curPosPx.x){
      faceDirection(RIGHT);
      curPosPx.x = Math.min(curPosPx.x + distance, curPos.x * TILE_SIZE);
    }
    if(curPos.y * TILE_SIZE < curPosPx.y){
      faceDirection(UP);
      curPosPx.y = Math.max(curPosPx.y - distance, curPos.y * TILE_SIZE);
    }
    if(curPos.x * TILE_SIZE < curPosPx.x){
      faceDirection(LEFT);
      curPosPx.x = Math.max(curPosPx.x - distance, curPos.x * TILE_SIZE);
    }

    animate();
  }

  void stopMove(){
    if(curPos.y * TILE_SIZE > curPosPx.y){
      num dy = (curPosPx.y + (TILE_SIZE - (curPosPx.y % TILE_SIZE))) / TILE_SIZE;
      curPos.y = Math.min(dy.floor(), curPos.y);
    }
    if(curPos.x * TILE_SIZE > curPosPx.x){
      num dx = (curPosPx.x + (TILE_SIZE - (curPosPx.x % TILE_SIZE))) / TILE_SIZE;
      curPos.x = Math.min(dx.floor(), curPos.x);
    }
    if(curPos.y * TILE_SIZE < curPosPx.y){
      num dy = (curPosPx.y + (TILE_SIZE - (curPosPx.y % TILE_SIZE))) / TILE_SIZE;
      curPos.y = Math.max(dy.floor(), curPos.y) - 1;
    }
    if(curPos.x * TILE_SIZE < curPosPx.x){
      num dx = (curPosPx.x + (TILE_SIZE - (curPosPx.x % TILE_SIZE))) / TILE_SIZE;
      curPos.x = Math.max(dx.floor(), curPos.x) - 1;
    }
    frame = 1 * ANIMATION_SPEED;
  }

  bool isMoving(){
    return (curPosPx.x != curPos.x * TILE_SIZE || curPosPx.y != curPos.y * TILE_SIZE);
  }

  void update(){
    if(isMoving()){
      updateMove();
    }else{
      stopMove();
    }

    screenPosPx.x = curPosPx.x - scene.displayPxX;
    screenPosPx.y = curPosPx.y - scene.displayPxY;
    if(!scene.inCamera(this.curPosPx)){
      return;
    }
    if(chasing){
      if(!curPos.nextToThis(faceDir, chased.curPos) ){
        moveTo(chased.curPos.x, chased.curPos.y);
        faceDirection(curPos.facingThis(faceDir, chased.curPos));
      }
    }

    context.drawImageToRect(this.characterImage , new Rectangle(screenPosPx.x, screenPosPx.y,
      TILE_SIZE, TILE_SIZE), //Rect to paint the image
      sourceRect: new Rectangle(((selectedChar) + (frame / ANIMATION_SPEED).floor() ) * TILE_SIZE, 
          (TILE_SIZE * faceDir) + characterRow, 
          TILE_SIZE, TILE_SIZE)); //Size of the image
  }
}