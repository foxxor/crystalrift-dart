import 'dart:html';
import 'dart:async';

import 'core/globals.dart';
import 'core/scene.dart';
import 'core/windowset.dart';
import 'helpers/coordinate.dart';

//System vars
HtmlDocument document;
CanvasRenderingContext2D context;
CanvasElement canvas;
Scene scene;
WindowSet gameDialog;
Element titleElement;
num lastTimeStamp = 0;  

void main() async
{
    document = window.document;
    titleElement = document.querySelector( ".navbar" );

    setupCanvas();
    scene = new Scene( document, context, canvas );
    resizeViewport();
    scene.createDialog( window );

    window.onResize.listen( (e) 
    {
        titleElement = document.querySelector( ".navbar" );
        setupCanvas();
        resizeViewport();
        scene.centerCamera( CENTER_TYPE_HORIZONTAL );
    } );

    // Refresh the animation
    while ( true )
    {
        update( await window.animationFrame );
    }
}

// Calcuolate canvas size depending on the window size
void setupCanvas()
{
    canvas = document.querySelector( "#canvas" );
    canvas.focus();

    if ( ( MAP_WIDTH_TILES * TILE_SIZE ) < window.innerWidth )
    {
        int leftMargin = ( ( window.innerWidth - ( MAP_WIDTH_TILES * TILE_SIZE ) ) / 2 ).floor();
        canvas.style.marginLeft = leftMargin.toString() + 'px';
    }
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight - titleElement.scrollHeight;
    context = canvas.getContext( "2d" );
}

// Calculate real viewport size omiting the title height
void resizeViewport()
{
    int sceneWidth;
    int sceneHeight;

    if ( ( MAP_WIDTH_TILES * TILE_SIZE ) < window.innerWidth )
    {
        sceneWidth = ( ( window.innerWidth - ( MAP_WIDTH_TILES * TILE_SIZE ) ) / 2 ).floor();
    } 
    else 
    {
        sceneWidth = window.innerWidth;
    }

    if ( ( MAP_HEIGHT_TILES * TILE_SIZE ) < ( window.innerHeight - titleElement.scrollHeight ))
    {
        sceneHeight = ( ( ( window.innerHeight - titleElement.scrollHeight ) - ( MAP_HEIGHT_TILES * TILE_SIZE ) ) / 2 ).floor();
    } 
    else 
    {
        sceneHeight = window.innerHeight - titleElement.scrollHeight;
    }

    scene.width = sceneWidth;
    scene.height = sceneHeight;
}

// Global refresh method
void update( num delta ) async
{
    context.clearRect( 0, 0, canvas.width, canvas.height );
    await scene.update();
}
