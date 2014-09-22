/*
  Copyright (C) 2014 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library actor;

import 'dart:html';
import 'dart:async';
import 'globals.dart';
import 'scene.dart';
import '../helpers/coordinate.dart';
import 'dart:math' as Math;
import 'character.dart';

class Actor extends Character{
  
  // Max life
  int maxLife;
  // Current life
  int life;
  // Type of the actor behaviour
  int behaviour;
  // Max energy
  int maxEnergy;
  // Current energy
  int energy;
  //Message of the character
  String message;
  // If the actor can combat
  bool combatable; 
  
  Actor(HtmlDocument _doc, CanvasRenderingContext2D _ctx, CanvasElement canvas, 
        Coordinate curPos, int charSprite, Scene scene, [String message, int speed = 1]) : 
          super( _doc, _ctx, canvas, curPos, charSprite, scene, speed);
  
  void initializeActor( bool combatable, int behaviour, [int maxLife = 0, int maxEnergy = 0]){
    this.combatable = combatable;
    this.behaviour = behaviour;
    this.maxLife = maxLife;
    this.life = life;
    this.maxEnergy = maxEnergy;
    this.energy = maxEnergy;
  }
}