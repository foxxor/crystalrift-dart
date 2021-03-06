/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library mapset;

import 'dart:html' hide Matrix;
import 'dart:async';
import 'globals.dart';
import 'graphic.dart';
import 'scene.dart';
import '../helpers/matrix.dart';
import 'tile.dart';
import 'dart:math' as Math;

class MapSet implements Graphic
{
  HtmlDocument document;
  CanvasRenderingContext2D context;
  CanvasElement canvas;
  ImageElement mapsetImage;
  Map structuresData;
  Scene scene;
  int width;
  int height;
  
  // The map matrix that represent the first visual terrain layer 
  Matrix mapset1;
  // The map matrix that represent the second visual terrain layer 
  Matrix mapset2;
  // The map matrix that represent the third visual terrain layer 
  Matrix mapset3;
  // The map matrix that represent the event layer, to track movement correctly
  Matrix eventMapset;
  
  MapSet( Scene this.scene, int this.width, int this.height )
  {
    this.document = scene.document;
    this.context  = scene.context;
    this.canvas   = scene.canvas;
    
    mapset1 = new Matrix( this.width, this.height );
    mapset2 = new Matrix( this.width, this.height );
    mapset3 = new Matrix( this.width, this.height );
    eventMapset = new Matrix( this.width, this.height );
    initValues();
    loadGraphic("assets/tileset/tileset.png");
  }
  
  void loadGraphic( String src )
  {
    this.mapsetImage = new Element.tag('img'); 
    this.mapsetImage = document.createElement('img'); 
    this.mapsetImage.src = src;
    this.mapsetImage.onLoad.listen( ( value ) => hideLoading() );
  }
  
  void hideLoading()
  {
    document.querySelector("#loading").classes.add('hidden');
    document.querySelector("#canvas").classes.remove('hidden');
    update();
  }
  
  void initValues()
  {
    for ( var y = 0; y < ( this.height); y++ )
    {
      for ( var x = 0; x < (this.width); x++ )
      {
        Tile t = new Tile( 8, 2, TILE_SOIL );
        mapset1.set( x, y, t );
        mapset2.set( x, y, 0 );
        mapset3.set( x, y, 0 );
        eventMapset.set( x, y, null );
      }
    }
  }
  
  void addBuilding( int index, int x, int y )
  {
    Map structure = structuresData['buildings'].elementAt( index );
    //Load the first layer
    var tilesMapset1 = structure['mapset1']['tiles'].iterator;

    while ( tilesMapset1.moveNext() )
    {
      Map m = tilesMapset1.current;
      Tile t = new Tile( m['xTile'], m['yTile'], m['type'] );
      var blocks = m['blocks'].iterator;
      while ( blocks.moveNext() )
      {
        Map block = blocks.current;
        mapset1.set( x +block['x'].toInt() , y + block['y'].toInt(), t );
        if ( m['type'] == TILE_BUILDING_UNPASSABLE )
        {
          occupyTile( x +block['x'].toInt() , y + block['y'].toInt(), t );
        }
      }
    }
    
    //Load the second layer
    var tilesMapset2 = structure['mapset2']['tiles'].iterator;
    while ( tilesMapset2.moveNext() )
    {
      Map m = tilesMapset2.current;
      Tile t = new Tile( m['xTile'], m['yTile'], m['type'] );
      var blocks = m['blocks'].iterator;
      while ( blocks.moveNext() )
      {
        Map block = blocks.current;
        mapset2.set( x +block['x'].toInt() , y + block['y'].toInt(), t );
        if ( m['type'] == TILE_BUILDING_UNPASSABLE )
        {
          occupyTile(x +block['x'].toInt() , y + block['y'].toInt(), t);
        }
      }
    }
  }
  
  void addRandomDetails()
  {
    var random = new Math.Random();
    for ( var i = 0; i< 10; i++ )
    {
      var rX = random.nextInt( mapset2.cols );
      var rY = random.nextInt( mapset2.rows );
      Tile t = new Tile(1, 32);
      if ( mapset1.get( rX, rY ).type == TILE_SOIL )
      {
        mapset2.set( rX, rY, t );
      }
      else
      {
        i --;
      }
    }
    for ( var i = 0; i< 12; i++ )
    {
      var rX = random.nextInt( mapset2.cols );
      var rY = random.nextInt( mapset2.rows );
      Tile t = new Tile(3, 32);
      if ( mapset1.get( rX, rY ).type == TILE_SOIL )
      {
        mapset2.set( rX, rY, t );
      }
      else
      {
        i --;
      }
    }
    for ( var i = 0; i< 8; i++ )
    {
      var rX = random.nextInt( mapset2.cols );
      var rY = random.nextInt( mapset2.rows );
      Tile t = new Tile( 4, 32 );
      if ( mapset1.get( rX, rY ).type == TILE_SOIL )
      {
        mapset2.set( rX, rY, t );
      }
      else
      {
        i --;
      }
    }
    for ( var i = 0; i< 8; i++ )
    {
      var rX = random.nextInt( mapset2.cols );
      var rY = random.nextInt( mapset2.rows );
      Tile t = new Tile( 6, 33 );
      if ( mapset1.get( rX, rY ).type == TILE_SOIL )
      {
        mapset2.set( rX, rY, t );
      }
      else
      {
        i --;
      }
    }
  }
  
  void occupyTile( int x, int y, var tileObject )
  {
    eventMapset.set( x, y, tileObject );
  }
  
  void freeTile( int x, int y )
  {
    eventMapset.set( x, y, null );
  }
  
  void moveToTile( int xi, int yi, int xf, int yf, var tileObject )
  {
    occupyTile( xf, yf, tileObject );
    freeTile( xi, yi );
  }
  
  Future update() async
  {
    int offsetInitX = ( scene.displayPxX / TILE_SIZE ).floor();
    int offsetInitY = ( scene.displayPxY / TILE_SIZE ).floor();
    
    int offsetFinalX = ( canvas.width / TILE_SIZE ).ceil() + offsetInitX + 1; // Added 1 to prevent showing not loaded tiles
    int offsetFinalY = ( canvas.height / TILE_SIZE ).ceil() + offsetInitY + 1; // Added 1 to prevent showing not loaded tiles

    offsetFinalX = ( this.width < offsetFinalX ? this.width : offsetFinalX );
    offsetFinalY = ( this.height < offsetFinalY ? this.height : offsetFinalY ); 
    
    for ( var y = offsetInitY; y < offsetFinalY; y++ )
    {
      for ( var x = offsetInitX; x < offsetFinalX; x++ )
      {
        Tile tile = mapset1.get( x, y );
        context.drawImageToRect( this.mapsetImage , new Rectangle( x * TILE_SIZE - scene.displayPxX, y * TILE_SIZE - scene.displayPxY, TILE_SIZE, TILE_SIZE ), //Rect to paint the image
            sourceRect: new Rectangle( tile.xImg, tile.yImg, TILE_SIZE, TILE_SIZE ) ); //Size of the image
        
        if ( mapset2.get( x, y ) != 0 )
        {
          Tile tile2 = mapset2.get( x, y );
          context.drawImageToRect( this.mapsetImage , new Rectangle( x * TILE_SIZE - scene.displayPxX, y * TILE_SIZE - scene.displayPxY, TILE_SIZE, TILE_SIZE ), //Rect to paint the image
              sourceRect: new Rectangle( tile2.xImg, tile2.yImg, TILE_SIZE, TILE_SIZE ) ); //Size of the image
        }
      }
    }
  }
  
}