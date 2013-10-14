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
  List<num> particlesAlpha;
  String effect;
  Coordinate curPosPx;
  num frame;
  int maxParticles;
  int width;
  int height;
  num alpha;
  Scene scene;
  
  Particle(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas, Scene scene, Coordinate curPosPx, String effect){
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    this.scene = scene;
    this.curPosPx = curPosPx;
    this.particles = new List<ImageElement>();
    this.particlesCoords = new List<Coordinate>();
    this.particlesAlpha = new List<num>();
    this.effect = effect;
    this.frame = 0;
    initEffect();
  }
  
  void initEffect(){
    if(effect == "poison"){
      alpha = 0.5;
      maxParticles = 10;
      width = (TILE_SIZE/ 5).floor();
      height = (TILE_SIZE/ 5).floor();
      loadGraphic('assets/particles/particle_purple.png');
    }else if(effect == "smoke"){
      alpha = 0.5;
      maxParticles = 25;
      width = (TILE_SIZE/ 3).floor();
      height = (TILE_SIZE/ 3).floor();
      loadGraphic('assets/particles/smoke.png');
    }else if(effect == "fire"){
      alpha = 0.55;
      maxParticles = 5;
      width = (TILE_SIZE/ 3).floor();
      height = (TILE_SIZE/ 3).floor();
      loadGraphic('assets/particles/particle_red.png');
      loadGraphic('assets/particles/particle_yellow.png');
    }else if(effect == "circle"){
      alpha = 0.6;
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
    Iterator<num> alphaIte = particlesAlpha.iterator;
    frame ++;
    
    while(coordIte.moveNext()){
      Coordinate c = coordIte.current;
      if(effect == "poison" || effect == "smoke"){
        alphaIte.moveNext();
        var nOpacity = random.nextInt(3);
        num cAlpha = alphaIte.current;
        cAlpha -= nOpacity/100;
        
        if(cAlpha <= 0){
          cAlpha = 0.25;
        }
        
        var number = random.nextInt(3);
        var negative = random.nextBool();
        if(c.y < curPosPx.y){
          c.y = curPosPx.y + TILE_SIZE -12;
        }else{
          c.y -= number;
        }
        if(c.x < curPosPx.x || c.x > (curPosPx.x + TILE_SIZE -10)){
          c.x = curPosPx.x + (TILE_SIZE/2).floor();
        }else{
          c.x += (negative? number * -1 : number);
        }
      }else if(effect == "fire"){
        alphaIte.moveNext();
        var nOpacity = random.nextInt(3);
        num cAlpha = alphaIte.current;
        cAlpha -= nOpacity/100;
        
        if(cAlpha <= 0){
          cAlpha = 0.25;
        }
        
        var number = random.nextInt(2);
        var negative = random.nextBool();
        if(c.y < curPosPx.y){
          c.y = curPosPx.y + TILE_SIZE -16;
        }else{
          c.y -= number;
        }
        if(c.x < curPosPx.x || c.x > (curPosPx.x + TILE_SIZE - 10)){
          c.x = curPosPx.x + (TILE_SIZE/2).floor();
        }else{
          c.x += (negative? number * -1 : number);
        }
      }else if(effect == "circle"){
        var number = random.nextInt(6);
        c.x = curPosPx.x + (TILE_SIZE * Math.cos(frame + number)).floor();
        c.y = curPosPx.y + (TILE_SIZE * Math.sin(frame + number)).floor();
      }
    }
    start();
  }
  
  void update(){
    Iterator<ImageElement> partIte = particles.iterator;
    Iterator<Coordinate> coord = particlesCoords.iterator;
    Iterator<num> alphaIte = particlesAlpha.iterator;
    while(partIte.moveNext()){
      ImageElement p = partIte.current;
      alphaIte.moveNext();
      num nAlpha = alphaIte.current;
      coord.moveNext();
      Coordinate c = coord.current;
      _ctx.save();
      _ctx.globalAlpha = nAlpha;
      _ctx.drawImageScaled(p, c.x - scene.displayPxX, c.y - scene.displayPxY, width, height);
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
      Coordinate coordinateN = new Coordinate(curPosPx.x + (TILE_SIZE / 2).floor() + number, curPosPx.y + TILE_SIZE - 16);
      particlesCoords.add(coordinateN);
      num nAlpha = alpha;
      particlesAlpha.add(nAlpha);
    }
  }
}