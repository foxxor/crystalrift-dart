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
  
  Coordinate curPosPx;
  
  Particle(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas, Coordinate curPosPx, String effect){
    this._doc = _doc;
    this._ctx = _ctx;
    this.canvas = canvas;
    this.curPosPx = curPosPx;
    this.particles = new List<ImageElement>();
    loadGraphic('assets/particles/particle_yellow.png');
  }
  
  void start(){
    const ms = const Duration(milliseconds: 100);
    Timer t = new Timer( ms, updateAnimation);
  }
  
  void updateAnimation(){
    var random = new Math.Random();
    var number = random.nextInt(10);
  }
  
  void update(){
    Iterator<ImageElement> partIte = particles.iterator;
    while(partIte.moveNext()){
      ImageElement p = partIte.current;
      _ctx.save();
      _ctx.globalAlpha = 0.4; //Modify the transparency
      _ctx.drawImageScaled(p, curPosPx.x, curPosPx.y, TILE_SIZE/5, TILE_SIZE/5);
      _ctx.restore();      
    }
  }
  
  void loadGraphic(String src){
    ImageElement particleImage = new Element.tag('img'); 
    particleImage = _doc.createElement('img'); 
    particleImage.src = src;
    particleImage.onLoad.listen((value) => update());
    particles.add(particleImage);
    for(num i = 0; i<10; i++){
      ImageElement particleImageN = particleImage.clone(false);
      particles.add(particleImageN);
    }
  }
}