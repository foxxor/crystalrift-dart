import 'dart:html';
import 'dart:async';
import '../globals.dart';
import '../scene.dart';
import '../actor.dart';

class InputModule {

    // Scene calling this class
    Scene scene;

    // Determines if the game input is locked
    bool inputLocked;

    InputModule ( Scene this.scene ) {
        setupKeys();


        inputLocked = GAME_START_LOCKED;
    }

    // Keyboard and keybinding
    void setupKeys() {
        scene.canvas.onKeyDown.listen((e) {
            reactKey(e);
        });
        scene.canvas.onKeyUp.listen((e) {
            scene.player.stopMove();
        });
    }

    // The callback function when a key is pressed
    void reactKey( var evt ) {
        if ( !inputLocked || evt.keyCode == 13  ) { // If the game is locked, only the action button should be enabled
            if ( evt.keyCode == 37 || evt.keyCode == 65 ) { // Left + A
                scene.movePlayer( LEFT );
            } else if ( evt.keyCode == 38 || evt.keyCode == 87 ) { // Up + W
                scene.movePlayer( UP );
            } else if ( evt.keyCode == 39 || evt.keyCode == 68 ) { // Right + D
                scene.movePlayer( RIGHT );
            } else if ( evt.keyCode == 40 || evt.keyCode == 83 ) { // Down + S
                scene.movePlayer( DOWN );
            } else if ( evt.keyCode == 13 ) { // Action button + Enter
                doAction();
            } else if ( evt.keyCode == 82 ) { // Projectile + R
                scene.battleModule.createProjectile();
            }
        }
    }

    // Function that generate the actions based in the context of the game.
    void doAction() {
        if ( scene.gameDialog != null ) {
            scene.gameDialog.moveLines();
        }

        // Trigger action for the character in front, if any.
        Actor character = scene.getCharacterInFront();
        if ( character != null ) {
            if ( character.combatable ) {
                scene.battleModule.doDamage( character );
            } else if ( !character.trigger ) {
                character.trigger = true;
                if ( character.message.isNotEmpty ) {
                    scene.createMessage( character );
                }
            }
        }
    }

    void setPauseGame( bool pause ) {
        inputLocked = pause;

        // TO-DO: Implement some kind of dark rect layover with the pause message
    }
}