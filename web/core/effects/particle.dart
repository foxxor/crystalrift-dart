/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library particle;

import 'dart:html';
import 'dart:async';
import '../globals.dart';
import '../scene.dart';
import '../../helpers/coordinate.dart';
import '../graphic.dart';
import 'dart:math' as Math;

class Particle implements Graphic{
  
  //Graphical vars
  HtmlDocument doc;
  CanvasRenderingContext2D ctx;
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
  String blendType;
  String color;
  
  Particle(Scene this.scene, Coordinate this.curPosPx, String this.effect){
    this.doc = scene.doc;
    this.ctx = scene.ctx;
    this.canvas = scene.canvas;
    
    this.particles = new List<ImageElement>();
    this.particlesCoords = new List<Coordinate>();
    this.particlesAlpha = new List<num>();
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
      alpha = 0.7;
      maxParticles = 20;
      blendType = 'lighter';
      color = "#FFF";
      width = (TILE_SIZE/ 3).floor();
      height = (TILE_SIZE/ 3).floor();
      loadGraphic('assets/particles/smoke.png');
    }else if(effect == "fire"){
      blendType = 'lighter';
      color = "#f30";
      alpha = 0.4;
      maxParticles = 25;
      width = (TILE_SIZE/ 3).floor();
      height = (TILE_SIZE/ 3).floor();
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
    const ms = const Duration(milliseconds: 60);
    Timer t = new Timer( ms, updateAnimation);
  }
  
  Future updateAnimation() async {
    var random = new Math.Random();
    Iterator<Coordinate> coordIte = particlesCoords.iterator;
    frame ++;
    num i = 0;
    while(coordIte.moveNext()){
      Coordinate c = coordIte.current;
      if(effect == "poison" || effect == "smoke"){
        num cAlpha = particlesAlpha.elementAt(i);
        if(cAlpha <= 0.05 || c.y <= curPosPx.y){
          cAlpha = alpha;
          c.y = curPosPx.y + TILE_SIZE - 17;
          c.x = curPosPx.x + (TILE_SIZE/2).floor() - 5;
        }else{
          var number = random.nextInt(2);
          var negative = random.nextBool();
          cAlpha -= number/50;
          c.y -= number;
          c.x += (negative? number * -1 : number);
        }
        particlesAlpha.insert(i, cAlpha);
      }else if(effect == "fire"){
        num cAlpha = particlesAlpha.elementAt(i);
        if(cAlpha <= 0.05 || c.y <= curPosPx.y){
          cAlpha = alpha;
          c.y = curPosPx.y + TILE_SIZE - 17;
          c.x = curPosPx.x + (TILE_SIZE/2).floor() - 5;
        }else{
          var number = random.nextInt(2);
          var negative = random.nextBool();
          cAlpha -= number/50;
          c.y -= number;
          c.x += (negative? number * -1 : number);
        }
        particlesAlpha.insert(i, cAlpha);
      }else if(effect == "circle"){
        var number = random.nextInt(6);
        c.x = curPosPx.x + (TILE_SIZE * Math.cos(frame + number)).floor();
        c.y = curPosPx.y + (TILE_SIZE * Math.sin(frame + number)).floor();
      }
      i++;
    }
    start();
  }
  
  Future update() async {
    if(scene.inCamera(this.curPosPx)){
      Iterator<ImageElement> partIte = particles.iterator;
      Iterator<Coordinate> coord = particlesCoords.iterator;
      Iterator<num> alphaIte = particlesAlpha.iterator;
      while(partIte.moveNext()){
        ImageElement p = partIte.current;
        alphaIte.moveNext();
        num nAlpha = alphaIte.current;
        coord.moveNext();
        Coordinate c = coord.current;
        ctx.save();
        ctx.globalAlpha = nAlpha;
        if(blendType != null){
          ctx.globalCompositeOperation = blendType;
          ctx.fillStyle = color;
        }
        ctx.drawImageScaled(p, c.x - scene.displayPxX, c.y - scene.displayPxY, width, height);
        ctx.restore();      
      }
    }
  }
  
  //This method doesnt work because is super slow :(
  void drawParticle(num x, num y){
    var radius = 2;
    ctx.arc(x, y, radius, 0, 
        2 * Math.PI, false);
    ctx.fillStyle = 'orange';
    ctx.fill();
  }
  
  void loadGraphic(String src){
    ImageElement particleImage = new Element.tag('img'); 
    particleImage = doc.createElement('img'); 
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