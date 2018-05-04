import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;

import '../globals.dart';
import '../scene.dart';
import '../actor.dart';
import '../../helpers/coordinate.dart';
import '../projectile.dart';


class BattleModule {

    // Scene calling this class
    Scene scene;

    BattleModule( Scene this.scene ) {

    }

    static num calculateDamage() {

    }

    void doDamage( Actor enemy ) {
        enemy.doDamage( 30 );
    }

    void createProjectile() {
        Coordinate curPos = new Coordinate( scene.player.curPos.x, scene.player.curPos.y );
        Projectile projectile = new Projectile( curPos, scene.player.faceDir, scene, 'energy_ball.png', 5, 2 );
        scene.projectiles.add( projectile );
    }
}