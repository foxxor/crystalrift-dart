import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;

import 'globals.dart';
import 'scene.dart';
import 'graphic.dart';
import 'actor.dart';
import 'entity.dart';
import 'tile.dart';
import '../helpers/coordinate.dart';

class Projectile implements Graphic {

    // Graphic vars
    HtmlDocument document;
    CanvasRenderingContext2D context;
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
            [ num this.speed = 1 ] ) {
        this.document = scene.document;
        this.context = scene.context;
        this.canvas = scene.canvas;

        this.steps = 0;
        this.curPosPx = new Coordinate( curPos.x * TILE_SIZE, curPos.y * TILE_SIZE );
        this.screenPosPx = new Coordinate( 0, 0 );
        loadGraphic( "assets/particles/projectiles/" + imageSource );
    }

    void loadGraphic( String src ) {
        this.image = new Element.tag( 'img' );
        this.image = document.createElement( 'img' );
        this.image.src = src;
    }

    Future update() async {
        updatePosition();
        updateMove();

        screenPosPx.x = curPosPx.x - scene.displayPxX;
        screenPosPx.y = curPosPx.y - scene.displayPxY;

        // Avoids rendering any image to save resources if not in camera
        if ( !scene.inCamera( this.curPosPx ) ) {
            return;
        }

        context.drawImageToRect( this.image , new Rectangle( screenPosPx.x, screenPosPx.y,
                TILE_SIZE, TILE_SIZE ), //Rect to paint the image
                sourceRect: new Rectangle( 0,
                        TILE_SIZE * faceDir,
                        TILE_SIZE, TILE_SIZE ) ); //Size of the image
    }

    void updatePosition() {
        // Checks if there's something blocking the projectile to remove it
        if ( !shallPass() ) {
            Actor actor = scene.getCharacterInFront( this );

            if ( actor != null && actor.combatable ){
                actor.doDamage( 30 );
            }

            scene.removeProjectile( this );
            return;
        }

        // After the projectile reached it max range remove it
        if ( steps == range ){
            scene.removeProjectile( this );
            return;
        }

        switch ( faceDir ) {
            case 0: //down
                if ( curPosPx.y == ( curPos.y * TILE_SIZE ) ) {
                    curPos.y ++;
                    steps ++;
                }
                break;
            case 1: //left
                if( curPosPx.x == ( curPos.x * TILE_SIZE ) ) {
                    curPos.x --;
                    steps ++;
                }
                break;
            case 2: //right
                if( curPosPx.x == ( curPos.x * TILE_SIZE ) ) {
                    curPos.x ++;
                    steps ++;
                }
                break;
            case 3: //up
                if( curPosPx.y == ( curPos.y * TILE_SIZE ) ) {
                    curPos.y --;
                    steps ++;
                }
                break;
        }
    }

    bool shallPass(){
        var tileObject = scene.mapSet.eventMapset.get( curPos.x, curPos.y );

        if ( tileObject != null ) {
            if ( tileObject is Actor && !tileObject.phasable && !identical( tileObject, scene.player ) ) {
                return false;
            } else if ( tileObject is Tile ) {
                return false;
            } else if ( tileObject is Entity ) {
                return false;
            }
        }
        return true;
    }

    void updateMove() {
        num distance = 2 * this.speed ;
        if ( curPos.y * TILE_SIZE > curPosPx.y ) {
            curPosPx.y = Math.min ( curPosPx.y + distance, curPos.y * TILE_SIZE );
        }
        if ( curPos.x * TILE_SIZE > curPosPx.x ) {
            curPosPx.x = Math.min( curPosPx.x + distance, curPos.x * TILE_SIZE );
        }
        if ( curPos.y * TILE_SIZE < curPosPx.y ) {
            curPosPx.y = Math.max( curPosPx.y - distance, curPos.y * TILE_SIZE );
        }
        if ( curPos.x * TILE_SIZE < curPosPx.x ) {
            curPosPx.x = Math.max( curPosPx.x - distance, curPos.x * TILE_SIZE );
        }
    }

    int getCurrentDirection() {
        switch ( faceDir ) {
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
}