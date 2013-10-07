/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library particle;

import 'dart:html';
import 'dart:async';
import 'globals.dart';
import 'scene.dart';
import '../helpers/coordinate.dart';
import 'graphic.dart';
import 'dart:math' as Math;

class Particle implements Graphic{
  
  //Graphical vars
  HtmlDocument _doc;
  CanvasRenderingContext2D _ctx;
  CanvasElement canvas;
  List<ImageElement> particles;
  List<Coordinate> particlesCoords;
  String effect;
  Coordinate curPosPx;
  num frame;
  int maxParticles;
  int width;
  int height;
  
  Particle(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas, Coordinate curPosPx, String effect){
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    this.curPosPx = curPosPx;
    this.particles = new List<ImageElement>();
    this.particlesCoords = new List<Coordinate>();
    this.effect = effect;
    this.frame = 0;
    initEffect();
  }
  
  void initEffect(){
    if(effect == "poison"){
      maxParticles = 10;
      width = (TILE_SIZE/ 5).floor();
      height = (TILE_SIZE/ 5).floor();
      loadGraphic('assets/particles/particle_purple.png');
    }else if(effect == "fire"){
      maxParticles = 20;
      width = (TILE_SIZE/ 5).floor();
      height = (TILE_SIZE/ 5).floor();
      loadGraphic('assets/particles/particle_yellow.png');
      loadGraphic('assets/particles/particle_red.png');
    }else if(effect == "circle"){
      maxParticles = 3;
      width = TILE_SIZE;
      height = TILE_SIZE;
      loadGraphic('assets/particles/star_yellow.png');
      loadGraphic('assets/particles/star_red.png');
      loadGraphic('assets/particles/star_blue.png');
      loadGraphic('assets/particles/star_green.png');
    }
  }
  
  void start(){
    const ms = const Duration(milliseconds: 50);
    Timer t = new Timer( ms, updateAnimation);
  }
  
  void updateAnimation(){
    var random = new Math.Random();
    Iterator<Coordinate> coordIte = particlesCoords.iterator;
    frame ++;
    
    while(coordIte.moveNext()){
      Coordinate c = coordIte.current;
      
      if(effect == "poison"){
        var number = random.nextInt(3);
        var negative = random.nextBool();
        if(c.y < curPosPx.y){
          c.y = curPosPx.y + TILE_SIZE -1;
        }else{
          c.y -= number;
        }
        if(c.x < curPosPx.x || c.x > (curPosPx.x + TILE_SIZE)){
          c.x = curPosPx.x + (TILE_SIZE/2).floor();
        }else{
          c.x += (negative? number * -1 : number);
        }
      }else if(effect == "fire"){
        var number = random.nextInt(2);
        var negative = random.nextBool();
        if(c.y < curPosPx.y){
          c.y = curPosPx.y + TILE_SIZE -1;
        }else{
          c.y -= number;
        }
        if(c.x < curPosPx.x || c.x > (curPosPx.x + TILE_SIZE)){
          c.x = curPosPx.x + (TILE_SIZE/2).floor();
        }else{
          c.x += (negative? number * -1 : number);
        }
      }else if(effect == "circle"){
        var number = random.nextInt(5);
        c.x = curPosPx.x + (TILE_SIZE * Math.cos(frame + number)).floor();
        c.y = curPosPx.y + (TILE_SIZE * Math.sin(frame + number)).floor();
      }
    }
    start();
  }
  
  void update(){
    Iterator<ImageElement> partIte = particles.iterator;
    Iterator<Coordinate> coord = particlesCoords.iterator;
    while(partIte.moveNext()){
      ImageElement p = partIte.current;
      coord.moveNext();
      Coordinate c = coord.current;
      _ctx.save();
      _ctx.globalAlpha = 0.6; //Modify the transparency
      _ctx.drawImageScaled(p, c.x, c.y, width, height);
      _ctx.restore();      
    }
  }
  
  void loadGraphic(String src){
    ImageElement particleImage = new Element.tag('img'); 
    particleImage = _doc.createElement('img'); 
    particleImage.src = src;
    particleImage.onLoad.listen((value) => update());
    var random = new Math.Random();
    
    for(num i = 0; i<maxParticles; i++){
      ImageElement particleImageN = particleImage.clone(false);
      particles.add(particleImageN);
      var number = random.nextInt(5);
      Coordinate coordinateN = new Coordinate(curPosPx.x + (TILE_SIZE / 2).floor() + number, curPosPx.y +TILE_SIZE - 1);
      particlesCoords.add(coordinateN);
    }
  }
}