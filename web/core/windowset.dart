library windowset;

import 'dart:html';
import 'dart:async';
import 'globals.dart';
import 'scene.dart';
import 'graphic.dart';
import '../helpers/coordinate.dart';

class WindowSet implements Graphic
{
    HtmlDocument document;
    CanvasRenderingContext2D context;
    CanvasElement canvas;
    ImageElement windowImage;
    Coordinate curPos;
    // Width of the window
    int width;
    // Height of the window
    int height;
    // Text
    String text;
    // Text offset to display
    int startLine;
    // Flag to mark if text ended
    bool endOfLine;
  
    WindowSet( HtmlDocument this.document, CanvasRenderingContext2D this.context, CanvasElement this.canvas, 
        int x, int y, int this.width, int this.height, String this.text )
    {
        this.curPos = new Coordinate( x, y );
        this.startLine = 0;
        this.endOfLine = false;
        loadGraphic( 'assets/window/BlueGloss.png' );
    }
  
    Future update() async
    {
        context.save();
        context.globalAlpha = 0.7;

        // Draw background
        context.drawImageScaledFromSource( windowImage, 0, 0, WINDOWSET_BG_TILE, WINDOWSET_BG_TILE,
            curPos.x + WINDOWSET_BORDER_PADDING, curPos.y + WINDOWSET_BORDER_PADDING, 
            width - ( WINDOWSET_BORDER_PADDING * 2 ), height - ( WINDOWSET_BORDER_PADDING * 2 ) );

        // Draw foreground
        int y = curPos.y;
        for ( int x = curPos.x; x <= width * 1.5; x = x + WINDOWSET_FG_TILE )
        {
            context.drawImageToRect( windowImage , new Rectangle(x, y, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE ), // Rect to paint the image
                sourceRect: new Rectangle( 0, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE ) ); // Size of the image
            context.drawImageToRect( windowImage , new Rectangle(x, y + WINDOWSET_FG_TILE , WINDOWSET_FG_TILE, WINDOWSET_FG_TILE ),
                sourceRect: new Rectangle( 0, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE, WINDOWSET_FG_TILE ) ); 
        }
        context.restore();

        // Draw border borders
        context.drawImageToRect(windowImage , new Rectangle( curPos.x, curPos.y, 9, 9 ), // Rect to paint the image
            sourceRect: new Rectangle( 64, 0, 9, 9 ) ); // Size of the image
        context.drawImageToRect(windowImage , new Rectangle( curPos.x + width - 8, curPos.y, 10, 9 ), // Rect to paint the image
            sourceRect: new Rectangle( 64 + 48 + 9, 0, 9, 9 ) ); // Size of the image
        context.drawImageToRect(windowImage , new Rectangle( curPos.x, curPos.y + height - 8, 9, 9 ), // Rect to paint the image
            sourceRect: new Rectangle( 64, 48 + 9, 9, 9 ) ); // Size of the image
        context.drawImageToRect(windowImage , new Rectangle( curPos.x + width - 9, curPos.y + height - 8, 10, 9) , // Rect to paint the image
            sourceRect: new Rectangle( 64 + 48 + 9, 48 + 9, 9, 9 ) ); // Size of the image

        //Draw border side lines
        context.drawImageScaledFromSource( windowImage, 64 + 9, 0, 9, 9,
            curPos.x + 9, curPos.y, 
            width - ( 9 * 2 ) + 1, 9 );
        context.drawImageScaledFromSource( windowImage, 64 + 9, 0, 9, 9,
            curPos.x + 9, curPos.y + height - 9, 
            width - ( 9 * 2 ), 9 );
        context.drawImageScaledFromSource( windowImage, 64, 9, 9, 9,
            curPos.x, curPos.y + 9, 
            9, height - ( 9 * 2 ) + 1 );
        context.drawImageScaledFromSource( windowImage, 64, 9, 9, 9,
            curPos.x + width - 9, curPos.y + 9, 
            9, height - ( 9 * 2 ) + 1 );
    
        drawText();
    }
  
    void drawText()
    {
        num x = curPos.x + WINDOWSET_TEXT_PADDING;
        num y = curPos.y + WINDOWSET_TEXT_PADDING + 15;
        context..save()
            ..font = '16pt Verdana'
            ..fillStyle = "white"
            ..lineWidth = 3;
        //Shadow Text
        context..shadowOffsetX = 0
            ..shadowOffsetY = 0
            ..shadowBlur    = 5
            ..shadowColor = 'rgba(0, 0, 0, 1)';

        var words = text.split(" ");
        var line = "";
        var numLines = 0;
        for ( var n = 0; n < words.length; n++ )
        {
            var testLine = '${line}${words[n]} ';
            var metrics = context.measureText( testLine );
            if ( metrics.width > ( width - ( WINDOWSET_TEXT_PADDING * 2 ) ) || words[n] == '\n' )
            {
                if ( numLines >= startLine ){
                    context.fillText( line, x, y );
                    y += 30;
                }
                if ( words[n] == '\n' ){
                    line = '';
                }
                else
                {
                    line = '${words[n]} ';
                }
                numLines ++;
            }
            else
            { 
                line = testLine;
            }

            if ( line != " " && n == words.length - 1 )
            {
                context.fillText( line, x, y );
            }
    
            if ( numLines >= ( startLine + 3 ) )
            {
                drawArrow();
                break;
            }
        }

        if ( numLines < startLine )
        {
            endOfLine = true;
        }
    
        context.restore();
    }
  
    void drawArrow()
    {
        context.drawImageScaledFromSource( windowImage, 96, 65, 17, 16,
            curPos.x + ( width / 2 ) - 25, curPos.y + height - 25, 
            20, 20 );
    }
  
    void moveLines()
    {
        startLine += 3;
    }
  
    void loadGraphic( String src )
    {
        this.windowImage = new Element.tag( 'img' ); 
        this.windowImage = document.createElement( 'img' ); 
        this.windowImage.src = src;
        this.windowImage.onLoad.listen( (value) => update() );
    }
}