
library projectile;

import 'dart:html';
import 'dart:async';
import 'globals.dart';
import 'scene.dart';
import 'graphic.dart';
import '../helpers/coordinate.dart';
import '../helpers/matrix.dart';
import 'dart:math' as Math;

class Projectile implements Graphic{

  // Graphic vars
  HtmlDocument doc;
  CanvasRenderingContext2D ctx;
  CanvasElement canvas;
  ImageElement image;

  // Current position in tiles
  Coordinate curPos;

  // Current position in pixels
  Coordinate curPosPx;

  // Current position relative to screen in pixels
  Coordinate screenPosPx;

  // Facing direction
  int faceDir;

  // Character movement speed
  num speed;

  // Parent scene calling this class
  Scene scene;

  // The max range of this projectile
  num range;

  // Number of steps advanced
  num steps;

  Projectile( Coordinate this.curPos, int this.faceDir, Scene this.scene, String imageSource, num this.range,
      [num this.speed = 1]) {
    this.doc = scene.doc;
    this.ctx = scene.ctx;
    this.canvas = scene.canvas;

    this.steps = 0;
    this.curPosPx = new Coordinate(curPos.x * TILE_SIZE, curPos.y * TILE_SIZE);
    this.screenPosPx = new Coordinate(0, 0);
    loadGraphic("assets/particles/projectiles/" + imageSource);
  }

  void loadGraphic(String src){
    this.image = new Element.tag('img');
    this.image = doc.createElement('img');
    this.image.src = src;
  }

  Future update() async {
    updatePosition();
    updateMove();

    screenPosPx.x = curPosPx.x - scene.displayPxX;
    screenPosPx.y = curPosPx.y - scene.displayPxY;

    // Avoids rendering any image to save resources if not in camera
    if(!scene.inCamera(this.curPosPx)){
      return;
    }

    ctx.drawImageToRect(this.image , new Rectangle(screenPosPx.x, screenPosPx.y,
        TILE_SIZE, TILE_SIZE), //Rect to paint the image
        sourceRect: new Rectangle(0,
            TILE_SIZE * faceDir,
            TILE_SIZE, TILE_SIZE)); //Size of the image
  }

  void updatePosition(){
    if (steps == range){
      scene.removeProjectile(this);
    }

    switch (faceDir) {
      case 0: //down
        if(curPosPx.y == (curPos.y * TILE_SIZE) ){
          curPos.y ++;
          steps ++;
        }
        break;
      case 1: //left
        if(curPosPx.x == (curPos.x * TILE_SIZE) ){
          curPos.x --;
          steps ++;
        }
        break;
      case 2: //right
        if(curPosPx.x == (curPos.x * TILE_SIZE) ){
          curPos.x ++;
          steps ++;
        }
        break;
      case 3: //up
        if(curPosPx.y == (curPos.y * TILE_SIZE) ){
          curPos.y --;
          steps ++;
        }
        break;
    }
  }

  void updateMove(){
    num distance = 2 * this.speed ;
    if(curPos.y * TILE_SIZE > curPosPx.y){
      curPosPx.y = Math.min(curPosPx.y + distance, curPos.y * TILE_SIZE);
    }
    if(curPos.x * TILE_SIZE > curPosPx.x){
      curPosPx.x = Math.min(curPosPx.x + distance, curPos.x * TILE_SIZE);
    }
    if(curPos.y * TILE_SIZE < curPosPx.y){
      curPosPx.y = Math.max(curPosPx.y - distance, curPos.y * TILE_SIZE);
    }
    if(curPos.x * TILE_SIZE < curPosPx.x){
      curPosPx.x = Math.max(curPosPx.x - distance, curPos.x * TILE_SIZE);
    }
  }
}