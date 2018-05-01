/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';
import 'core/globals.dart';
import 'core/actor.dart';
import 'core/projectile.dart';
import 'core/scene.dart';
import 'core/windowset.dart';
import 'helpers/coordinate.dart';

//System vars
HtmlDocument document;
CanvasRenderingContext2D context;
CanvasElement canvas;
Scene scene;
WindowSet windowInfo;
Element titleElement;

void main() {
    document = window.document;
    titleElement = document.querySelector( ".navbar" );
    setupCanvas();
    scene = new Scene( document, context, canvas );
    resizeViewport();

    window.onResize.listen((e) {
        titleElement = document.querySelector( ".navbar" );
        setupCanvas();
        resizeViewport();
        scene.centerCamera( CENTER_TYPE_HORIZONTAL );
    });
  
    setupKeys();
    String text = "Hi, welcome to this demo of Crystal Rift! \n Please use the A/S/D/W keys to move around. \n Use enter key to interact with characters and close this window. ";
    windowInfo = new WindowSet( document, context, canvas, 
        ( ( canvas.width ) / 2 ).floor() - ( ( WINDOW_WIDTH / 2 ).floor() + ( scene.width == window.innerWidth ? 0 : scene.width ) ), 
        scene.height - WINDOW_HEIGHT - 50, 
        WINDOW_WIDTH, WINDOW_HEIGHT, text );

    window.animationFrame.then( update );
}

// Calcuolate canvas size depending on the window size
void setupCanvas() {
    canvas = document.querySelector( "#canvas" );
    canvas.focus();

    if ( ( MAP_WIDTH_TILES * TILE_SIZE ) < window.innerWidth ) {
        int leftMargin = ( ( window.innerWidth - ( MAP_WIDTH_TILES * TILE_SIZE ) ) / 2 ).floor();
        canvas.style.marginLeft = leftMargin.toString() + 'px';
    }
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight - titleElement.scrollHeight;
    context = canvas.getContext( "2d" );
}

// Calculate real viewport size omiting the title height
void resizeViewport() {
    int sceneWidth;
    int sceneHeight;

    if ( ( MAP_WIDTH_TILES * TILE_SIZE ) < window.innerWidth ) {
        sceneWidth = ( ( window.innerWidth - ( MAP_WIDTH_TILES * TILE_SIZE ) ) / 2 ).floor();
    } else {
        sceneWidth = window.innerWidth;
    }

    if ( ( MAP_HEIGHT_TILES * TILE_SIZE ) < ( window.innerHeight - titleElement.scrollHeight )) {
        sceneHeight = ( ( ( window.innerHeight - titleElement.scrollHeight ) - ( MAP_HEIGHT_TILES * TILE_SIZE ) ) / 2 ).floor();
    } else {
        sceneHeight = window.innerHeight - titleElement.scrollHeight;
    }

    scene.width = sceneWidth;
    scene.height = sceneHeight;
}

//refresh method
void update( num delta ) {
    context.clearRect( 0, 0, canvas.width, canvas.height );
    scene.update();

    if ( !windowInfo.endOfLine ) {
        windowInfo.update();
    }
    
    // Callback this same function, to create a loop
    window.animationFrame.then( update );
}

// Function that generate the actions based in the context of the game.
void doAction() {
    windowInfo.moveLines();
    // Trigger action for the character in front, if any.
    Actor character = scene.getCharacterInFront();
    if ( character != null ) {
        if ( character.combatable ) {
            character.doDamage();
        } else if ( !character.trigger ) {
            character.trigger = true;
            if ( character.message.isNotEmpty ) {
                scene.createMessage( character );
            }
        }
    }
}

void createProjectile(){
    Coordinate curPos = new Coordinate( scene.player.curPos.x, scene.player.curPos.y );
    Projectile projectile = new Projectile( curPos, scene.player.faceDir, scene, 'energy_ball.png', 5, 2 );
    scene.projectiles.add(projectile);
}

// Keyboard and keybinding
void setupKeys(){
    canvas.onKeyDown.listen((e) {
        reactKey(e);
    });
    canvas.onKeyUp.listen((e) {
        scene.player.stopMove();
    });
}

void reactKey( var evt ) {
    if ( evt.keyCode == 37 || evt.keyCode == 65 ) { // Left + A
        scene.movePlayer( LEFT );
    } else if ( evt.keyCode == 38 || evt.keyCode == 87 ) { // Up + W
        scene.movePlayer( UP );
    } else if ( evt.keyCode == 39 || evt.keyCode == 68 ) { // Right + D
        scene.movePlayer( RIGHT );
    } else if ( evt.keyCode == 40 || evt.keyCode == 83 ) { // Down + S
        scene.movePlayer( DOWN );
    } else if ( evt.keyCode == 13 ) { // Action
        doAction();
    } else if ( evt.keyCode == 82 ) { // Projectile
        createProjectile();
    }
}
