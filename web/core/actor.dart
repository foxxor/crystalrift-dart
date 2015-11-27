/*
  Copyright (C) 2014 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library actor;

import 'dart:html';
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
  // How much damage this actor can make
  int attack;
  // Defense modifier against damage
  int defense;
  // If the actor is dead
  bool dead;
  
  ImageElement barHpImage;
  ImageElement barMpImage;
  
  String srcBarHp = "hp_pixel.png";
  String srcBarMp = "mp_pixel.png";
  
  Actor(Coordinate curPos, int charSprite, int charRow, Scene scene, String imageSource, [ num speed = 1]) : 
          super( curPos, charSprite, charRow, scene, imageSource, speed);
  
  void initializeActor( bool combatable, int behaviour, [int maxLife = 0, int maxEnergy = 0, String message = "", int attack = 0, int defense = 0, bool dead = false]){
    this.combatable = combatable;
    this.behaviour = behaviour;
    this.maxLife = maxLife;
    this.life = maxLife;
    this.maxEnergy = maxEnergy;
    this.energy = maxEnergy;
    this.message = message;
    this.attack = attack;
    this.defense = defense;
    this.dead = dead;
    loadBars();
  }
  
  void loadBars(){
    barHpImage = new Element.tag('img'); 
    barHpImage = doc.createElement('img'); 
    barHpImage.src = "assets/particles/extra/hp_pixel.png";
    barMpImage = new Element.tag('img'); 
    barMpImage = doc.createElement('img'); 
    barMpImage.src = "assets/particles/extra/" + srcBarMp;
  }
  
  void damage(int numAttack){
    this.life = this.life - (numAttack - (this.defense * 0.1).floor());
    if(this.life <= 0){
      this.dead = true;
    }   
  }
  
  void update(){
    super.update();
    if(combatable && !this.dead){
      int barWeigth = (TILE_SIZE * (life / maxLife)).floor();
      ctx.drawImageScaled(barHpImage, screenPosPx.x, screenPosPx.y + TILE_SIZE + 3, 
          barWeigth, 3);
    }

    if(this.dead){
      this.chasing = false;
    }
  }
  
  
}