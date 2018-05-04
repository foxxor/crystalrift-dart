import 'dart:html';

import 'core/globals.dart';
import 'core/scene.dart';
import 'helpers/coordinate.dart';

//System vars
HtmlDocument document;
CanvasRenderingContext2D context;
CanvasElement canvas;
Scene scene;
WindowSet gameDialog;
Element titleElement;

void main() {
    document = window.document;
    titleElement = document.querySelector( ".navbar" );
    setupCanvas();
    scene = new Scene( document, context, canvas );
    resizeViewport();
    scene.createDialog( window );

    window.onResize.listen((e) {
        titleElement = document.querySelector( ".navbar" );
        setupCanvas();
        resizeViewport();
        scene.centerCamera( CENTER_TYPE_HORIZONTAL );
    });

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

// Global refresh method
update( num delta ) async {
    context.clearRect( 0, 0, canvas.width, canvas.height );
    scene.update();
    
    // Callback this same function, to create a loop
    window.animationFrame.then( update );
}
