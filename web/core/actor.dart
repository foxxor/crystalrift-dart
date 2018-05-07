
library actor;

import 'dart:html';
import 'dart:async';
import 'globals.dart';
import 'scene.dart';
import '../helpers/coordinate.dart';
import 'dart:math' as Math;
import 'character.dart';

class Actor extends Character {
    
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
    
    // HP and MP life bars
    ImageElement barHpImage;
    ImageElement emptyBarHpImage;
    ImageElement barMpImage;
    
    String srcBarHp = "hp_pixel.png";
    String srcEmptyBarHp = "empty_hp_pixel.png";
    String srcBarMp = "mp_pixel.png";
    
    Actor( Coordinate curPos, int charSprite, int charRow, Scene scene, String imageSource, [ num speed = 1, bool randomMovement = false ] ) : 
        super( curPos, charSprite, charRow, scene, imageSource, speed, randomMovement );
    
    void initializeActor( bool combatable, int behaviour, 
        [ int maxLife = 0, int maxEnergy = 0, String message = "", int attack = 0, int defense = 0, bool dead = false, int speed = 1 ] ) {

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
    
    void loadBars() {
        barHpImage = new Element.tag( 'img' ); 
        barHpImage = document.createElement( 'img' ); 
        barHpImage.src = "assets/particles/extra/" + srcBarHp;

        emptyBarHpImage = new Element.tag( 'img' ); 
        emptyBarHpImage = document.createElement( 'img' ); 
        emptyBarHpImage.src = "assets/particles/extra/" + srcEmptyBarHp;

        barMpImage = new Element.tag( 'img' ); 
        barMpImage = document.createElement( 'img' ); 
        barMpImage.src = "assets/particles/extra/" + srcBarMp;
    }

    void doDamage( int damage ) {
        if ( !this.dead ) {
            this.life = this.life - ( damage - ( this.defense * 0.1 ).floor() );
            if ( this.life <= 0 ) {
                this.dead = true;
            }   

            scene.createAnimation( this );
            chaseCharacter( scene.player );
        }
    }
    
    Future update() async {
        super.update();
        if ( combatable && !this.dead ) {
            // If the life of the enemy is low, force to render the bar to 10% of the max width
            var renderedLife = ( life < ( maxLife * 0.1 ) ? ( maxLife * 0.1 ) : life );

            context.drawImageScaled( emptyBarHpImage, screenPosPx.x + 2, screenPosPx.y + TILE_SIZE + 5,
                TILE_SIZE - 4, 3 );

            int lifeBarWeight = ( TILE_SIZE * ( renderedLife / maxLife ) ).floor();
            context.drawImageScaled( barHpImage, screenPosPx.x + 2, screenPosPx.y + TILE_SIZE + 5,
                lifeBarWeight - 4, 3 );
        }

        if ( this.dead ) {
            stopChasing();
            randomMovement = false;
        }
    }
}