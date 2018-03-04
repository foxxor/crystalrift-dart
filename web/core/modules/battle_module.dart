
import 'dart:html';
import 'dart:async';
import '../globals.dart';
import '../scene.dart';
import '../graphic.dart';
import '../../helpers/coordinate.dart';
import '../../helpers/matrix.dart';
import 'dart:math' as Math;

class BattleModule {

  //Graphic vars
  HtmlDocument htmlDocument;
  CanvasRenderingContext2D context2d;
  CanvasElement canvas;
  ImageElement characterImage;

  // Scene calling this class
  Scene scene;

  BattleModule(HtmlDocument this.htmlDocument, CanvasRenderingContext2D this.context2d, CanvasElement this.canvas, Scene this.scene){

  }

  static num calculateDamage(){

  }
}