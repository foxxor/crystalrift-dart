import 'dart:html' hide Matrix;
import 'dart:js';
import 'dart:convert';

import 'editor/editorMap.dart';
import 'editor/menuTileset.dart';
import 'editor/tileSelector.dart';
import 'editor/mapEvent.dart';
import 'editor/eventCharacter.dart';
import 'editor/eventObject.dart';
import 'editor/filescan.dart';

import 'core/globals.dart';
import 'core/tile.dart';
import 'helpers/matrix.dart';

//System vars
HtmlDocument document;
CanvasRenderingContext2D main2DContext;
CanvasRenderingContext2D tile2DContext;
CanvasRenderingContext2D map2DContext;

// HTML containers
var tileElement;
var mapElement;
var navigation;
var windows;

// Tileset menu canvas
CanvasElement tilesetCanvas;

// Selected Tile canvas
CanvasElement tileCanvas;

// Map canvas
CanvasElement mapCanvas;
ImageElement image;
ImageElement imageTile;

int currentLayer;
String currentTool;

// List of the maps
List<EditorMap> maps;

// Tileset menu
MenuTileset menuTileset;

// Tile selector
TileSelector tileSelector;

// Current tool in use
var toolSubscription;

// Current map visible
EditorMap currentMap;

// Object with files information
FileScan files;

void main() {
    document = window.document;
    files = new FileScan();
    loadTileSet();
    initMenuInteraction();
    loadMap();
}

void initMenuInteraction() {
    initTabs();
    loadTileSelection();
    layerSelection();
    toolSelection();
    bindMapOptions();
    bindEventOptions();
}

void initTabs() {
    currentLayer = 1;
    currentTool = "pencil";
    navigation = document.querySelector( "#navigation" );
    windows = document.querySelector( "#windows" );
    navigation.onClick.listen(( MouseEvent e ) {
        e.preventDefault();
        Element elem = e.target;
        String option = elem.dataset[ 'option' ];
        navigationHideAll();
        elem.parent.classes.add( 'active' );
        switch ( option ){
            case "draw":
                windows.querySelector( '#drawWindow' ).classes.remove( 'hide' );
                break;
            case "maps":
                windows.querySelector( '#mapWindow' ).classes.remove( 'hide' );
                break;
            case "events":
                windows.querySelector( '#eventWindow' ).classes.remove( 'hide' );
                break;
            case "io":
                windows.querySelector( '#ioWindow' ).classes.remove( 'hide' );
                break;
        }
    });
}

// Listener for the layer selector
void layerSelection() {
    var layers = document.querySelector( "#ulLayers" );
    layers.onClick.listen(( MouseEvent e ) {
        e.preventDefault();
        Element elem = e.target;
        if ( elem.dataset[ 'layer' ] != null ){
            for ( var layer in layers.children ) {
                layer.classes.remove( 'active' );
            }
            elem.parent.classes.add( 'active' );
            currentLayer = int.parse( elem.dataset[ 'layer' ] );
        }
    });
}

// Listener for the tool selected
void toolSelection() {
    var toolsButtons = document.querySelector( "#toolset" );
    var toolPencil = document.querySelector( "#toolPencil" );
    toolPencil.onClick.listen(( MouseEvent e ) {
        e.preventDefault();
        for ( var button in toolsButtons.children ) {
            button.classes.remove( 'active' );
        }
        toolPencil.classes.add( 'active' );
        currentTool = toolPencil.dataset[ 'tool' ];
        currentMap.selectionMode = tileSelector.selectionMode;
    });
    
    var toolEraser = document.querySelector( "#toolEraser" );
    toolEraser.onClick.listen(( MouseEvent e ) {
        e.preventDefault();
        for ( var button in toolsButtons.children ) {
            button.classes.remove( 'active' );
        }
        toolEraser.classes.add( 'active' );
        currentTool = toolEraser.dataset[ 'tool' ];
        currentMap.selectionMode = SINGLE_TILE_SELECTION;
    });
    
    var genJsonButton = document.querySelector( "#generateMap" );
    genJsonButton.onClick.listen(( MouseEvent e ) {
        String jsonData = json.encode( currentMap.toJson() );
        var jsonTextArea = document.querySelector( "#genJsonTextArea" );
        jsonTextArea.setInnerHtml( jsonData );
    });
    
    var loadJsonButton = document.querySelector( "#loadJson" );
    loadJsonButton.onClick.listen(( MouseEvent e ) {
        var jsonTextArea = document.querySelector( "#genJsonTextArea" );
        String jsonData = jsonTextArea.text;
        if ( jsonData.trim() != "" ) {
            Map parsedJson = json.decode( jsonData );
            currentMap.loadMap( parsedJson );
            drawMapsList();
        }
    });
}

void navigationHideAll() {
    for ( var element in navigation.children ) {
        element.classes.remove( 'active' );
    }
    for ( var window in windows.children ) {
        window.classes.add( 'hide' );
    }
}

// Draw the editor map
void loadMap() {
    mapCanvas = document.querySelector( "#mapCanvas" );
    map2DContext = mapCanvas.getContext( "2d" );
    mapElement = document.querySelector( '#mapContainer' );
    
    mapCanvas.width = EDITOR_MAP_DEFAULT_TILES_WIDTH * TILE_SIZE;
    mapCanvas.height = EDITOR_MAP_DEFAULT_TILES_HEIGHT * TILE_SIZE;
    maps = new List<EditorMap>();
    EditorMap initialMap = new EditorMap( "Map 001", EDITOR_MAP_DEFAULT_TILES_WIDTH, EDITOR_MAP_DEFAULT_TILES_HEIGHT );
    initialMap.initContext( document, map2DContext, mapCanvas );
    initialMap.selectionMode = SINGLE_TILE_SELECTION;
    initialMap.active = true;
    maps.add( initialMap );
    currentMap = maps.elementAt( 0 );
    currentMap.canvasReDraw();
    drawMapsList();
    drawEventsList();
    loadMapSelection();
}

// Listener for the map 
void loadMapSelection() {
    int dragX, dragY;
    mapCanvas.onMouseUp.listen(( MouseEvent e ) {
        int x = ( ( e.client.x - mapElement.offsetLeft ) / TILE_SIZE ).ceil();
        int y = ( ( e.client.y - mapElement.offsetTop ) / TILE_SIZE ).ceil();

        if ( !currentMap.addingEvent && !windows.querySelector( '#drawWindow' ).classes.contains( 'hide' ) ) {
            if ( currentMap.selectionMode == SINGLE_TILE_SELECTION ) {
                if ( dragX != x || dragY != y ) {
                    int iX = ( dragX > x ? x : dragX );
                    int iY = ( dragY > y ? y : dragY );
                    int fX = ( dragX > x ? dragX : x );
                    int fY = ( dragY > y ? dragY : y );

                    for ( num e = iX; e < fX; e++ ) {
                        for ( num i = iY; i < fY; i++ ) {
                            if ( currentTool == "pencil" ) {
                                currentMap.setTile(
                                        e, i, tileSelector.selection.x, tileSelector.selection.y,
                                        currentLayer );
                            } else { //Eraser
                                currentMap.setTile( e, i, 0, 0, currentLayer );
                            }
                        }
                    }
                    currentMap.stopSelection();
                    currentMap.update();
                }
            } else if ( currentMap.addingEvent && !windows.querySelector( '#eventWindow' ).classes.contains( 'hide' ) ) {
                int xTile = 0;
                for ( num e = x - 1; e < x + currentMap.selection.cols - 1; e++ ) {
                    int yTile = 0;
                    for ( num i = y - 1; i < y + currentMap.selection.rows - 1; i++ ) {
                        Tile curTile = currentMap.selection.get( xTile, yTile );
                        currentMap.setTile( e, i, curTile.x, curTile.y, currentLayer );
                        yTile++;
                    }
                    xTile++;
                }
                currentMap.stopSelection();
                currentMap.update();
            } else if ( currentMap.selectionMode == MULTI_TILE_SELECTION && currentTool == "pencil" ) {
                for ( var i = 0; i < tileSelector.selection.rows; i++ ) {
                    for ( var e = 0; e < tileSelector.selection.cols; e++ ) {
                        currentMap.setTile( x+e-1, y+i-1, tileSelector.selection.get( e, i ).x,
                                tileSelector.selection.get( e, i ).y, currentLayer );
                    }
                }
                currentMap.stopSelection();
                currentMap.update();
            }
        }
    });
    
    mapCanvas.onMouseDown.listen(( MouseEvent e ) {
        int x = ( ( e.client.x - mapElement.offsetLeft ) / TILE_SIZE ).ceil() - 1;
        int y = ( ( e.client.y - mapElement.offsetTop ) / TILE_SIZE ).ceil() - 1;
        if ( !currentMap.addingEvent && !windows.querySelector( '#drawWindow' ).classes.contains( 'hide' ) ) {
            dragX = x;
            dragY = y;
            currentMap.beginSelection();
            if ( currentMap.selectionMode == SINGLE_TILE_SELECTION ) {
                if ( currentTool == "pencil" ) {
                    currentMap.setTile( x, y, tileSelector.selection.x, tileSelector.selection.y, currentLayer );
                } else { //Eraser
                    currentMap.setTile( x, y, 0, 0, currentLayer );
                }
            }
            currentMap.update();
        } else if ( currentMap.addingEvent && !windows.querySelector( '#eventWindow' ).classes.contains( 'hide' ) ){ 
            MapEvent newEvent = new MapEvent( EVENT_TYPE_NOT_SPECIFIED, x, y, "Event " + currentMap.events.length.toString().padLeft( 3, '0' ) );
            currentMap.events.add( newEvent );
            InputElement eventNameInput = document.querySelector( '#eventNameInput' );
            eventNameInput.text = newEvent.name;
            context.callMethod( 'jQuery', [ '#addEventModal' ] ).callMethod( 'modal', [ 'show' ] );
            drawEventsList();
        }
    });
    
    //Update the selector position
    mapCanvas.onMouseMove.listen(( MouseEvent e ) {
        int x = ( ( e.client.x - mapElement.parent.offsetLeft + mapElement.scrollLeft ) / TILE_SIZE ).ceil() - 1;
        int y = ( ( e.client.y - mapElement.parent.offsetTop + mapElement.scrollTop ) / TILE_SIZE ).ceil() - 1;
        currentMap.updateSelector( x, y );
        currentMap.update( true );
    });
}

// Initialization for the tileset menu
void loadTileSet() {
    tilesetCanvas = document.querySelector( "#tilesetCanvas" );
    main2DContext = tilesetCanvas.getContext( "2d" );
    tileElement = document.querySelector( "#tilesetContainer" );
    menuTileset = new MenuTileset( document, main2DContext, tilesetCanvas, tileElement );
}

// Listener for the tile selection
void loadTileSelection() {
    tileCanvas = document.querySelector( "#tile" );
    tile2DContext = tileCanvas.getContext( "2d" );
    tileSelector = new TileSelector( document, tile2DContext, tileCanvas );
    tileSelector.selectionMode = SINGLE_TILE_SELECTION;
    tileSelector.update();
    tileSelectorBinds();
}

// Listeners for the tileset menu selection
void tileSelectorBinds() {
    int dragX, dragY;
    tilesetCanvas.onMouseDown.listen(( MouseEvent e ) {
        int x = (( e.client.x + tileElement.scrollLeft ) / TILE_SIZE ).ceil() - 1;
        int y = (( e.client.y + tileElement.scrollTop ) / TILE_SIZE ).ceil() - 1;
        dragX = x;
        dragY = y;
        menuTileset.beginSelection();
        menuTileset.update();
    });
    
    // This is to select multiple tiles in the tileset container
    tilesetCanvas.onMouseUp.listen(( MouseEvent e ) {
        int x = (( e.client.x + tileElement.scrollLeft ) / TILE_SIZE ).ceil();
        int y = (( e.client.y + tileElement.scrollTop ) / TILE_SIZE ).ceil();
        if ( dragX != x || dragY != y ){
            int iX = ( dragX > x ? x : dragX );
            int iY = ( dragY > y ? y : dragY );
            int fX = ( dragX > x ? dragX : x );
            int fY = ( dragY > y ? dragY : y );
            int dX = ( iX - fX ).abs();
            int dY = ( iY - fY ).abs();
            
            if ( dX == 1 && dY == 1 ) {
                Tile tileSelected = new Tile( x - 1, y - 1 );
                tileSelector.setSelection( tileSelected );
                tileSelector.setSelectionMode( SINGLE_TILE_SELECTION );
                currentMap.setSelection( tileSelected );
                currentMap.selectionMode = SINGLE_TILE_SELECTION;
            } else {
                Matrix tilesSelected = new Matrix( dX ,dY );
                int x = 0;
                for ( num e = iX; e < fX; e++ ) {
                    int y = 0;
                    for ( num i = iY; i < fY; i++ ) {
                        Tile tileSelected = new Tile( e, i );
                        tilesSelected.set( x, y, tileSelected );
                        y ++;
                    }
                    x++;
                }
                tileSelector.setSelection( tilesSelected );
                tileSelector.setSelectionMode( MULTI_TILE_SELECTION );
                currentMap.setSelection( tilesSelected );
                currentMap.selectionMode = MULTI_TILE_SELECTION;
            }
            tileSelector.update();
            menuTileset.stopSelection();
            menuTileset.update();
        }
    });
        
    // Update the selector position
    tilesetCanvas.onMouseMove.listen(( MouseEvent e ) {
        int x = ( ( e.client.x + tileElement.scrollLeft ) / TILE_SIZE ).ceil() - 1;
        int y = ( ( e.client.y + tileElement.scrollTop ) / TILE_SIZE ).ceil() - 1;
        menuTileset.updateSelector( x, y );
        menuTileset.update();
    });
}

void drawMapsList() {
    var ul = document.querySelector( '#mapWindow ul.list-group' );
    ul.innerHtml = "";
    int index = 0;
    for ( var m in maps ) {
        String active = "";
        if ( currentMap == m ) {
            active = "active";
        }
        var li = new Element.html( '<a class="list-group-item map-item ' + active + '"><span class="badge">' + m.widthTiles.toString()
                + ' x ' + m.heightTiles.toString() + '</span>' + m.name + '</a>' );
        li.dataset[ 'id' ] = index.toString();
        ul.children.add( li );
        index ++;
    }
}

void drawEventsList() {
    var ul = document.querySelector( '#eventWindow ul.list-group' );
    ul.innerHtml = "";
    int index = 0;
    for ( var e in currentMap.events ) {
        var li = new Element.html('<li class="list-group-item">' + e.name +
            '&nbsp;<span class="label label-warning">'+ e.mapNameRender() + '</span>' +
            '<button class="btn btn-default deleteEvent float-right" href="#">' +
                '<span class="glyphicon glyphicon-remove" style="vertical-align:middle;"></span>' +
            '</button>' +
            '<button class="btn btn-default editEvent float-right" href="#">' +
                '<span class="glyphicon glyphicon-cog" style="vertical-align:middle;"></span>' +
            '</button>' +
        '</li>');
        li.dataset[ 'id' ] = index.toString();
        ul.children.add( li );
        index ++;
    }
}

void bindMapItems() {
    var mapList = document.querySelector( '#mapList' );
    mapList.onClick.listen(( MouseEvent e ) {
        e.preventDefault();
        Element elem = e.target;
        if ( elem.dataset[ 'id' ] != null ) {
            for ( var mapItems in mapList.children ) {
                mapItems.classes.remove( 'active' );
            }
            elem.classes.add( 'active' );
            int mapId = int.parse( elem.dataset[ 'id' ] );
            currentMap.active = false;
            currentMap = maps.elementAt( mapId );
            currentMap.active = true;
            currentMap.canvasReDraw();
            currentMap.update();
        }
    });
}

void cleanInputs() {
    InputElement mapNameInput = document.querySelector( '#mapNameInput' );
    InputElement widthInput = document.querySelector( '#mapWidthInput' );
    InputElement heightInput = document.querySelector( '#mapHeightInput' );
    mapNameInput.text = '';
    widthInput.text = '';
    heightInput.text = '';
}

void bindMapOptions() {
    var addMapButton = document.querySelector( '#addMapButton' );
    addMapButton.onMouseDown.listen(( MouseEvent e ) {
        e.preventDefault();
        InputElement mapNameInput = document.querySelector( '#mapNameInput' );
        InputElement widthInput = document.querySelector( '#mapWidthInput' );
        InputElement heightInput = document.querySelector( '#mapHeightInput' );
        String mapName = mapNameInput.text;
        int width = int.parse( widthInput.text );
        int height = int.parse( heightInput.text );
        EditorMap map = new EditorMap( mapName, width, height );
        map.initContext( document, map2DContext, mapCanvas );
        map.selectionMode = SINGLE_TILE_SELECTION;
        maps.add( map );
        drawMapsList();
        bindMapItems();
        //cleanInputs(); Im getting an error is like stupid dart is passing variables by reference and not by value
        context.callMethod( 'jQuery', [ '#addMapModal' ] ).callMethod( 'modal', [ 'hide' ] );
    });
}

void bindEventOptions() {
    var addEventButton = document.querySelector( '#addEvent' );
    addEventButton.onMouseDown.listen(( MouseEvent e ) {
        e.preventDefault();
        document.querySelector( '#eventAlert' ).classes.remove( 'hidden' );
        document.querySelector( '#addEvent' ).classes.add( 'active' );
        currentMap.addingEvent = true;
    });
    
    var confirmEventButton = document.querySelector( '#addEventButton' );
    confirmEventButton.onMouseDown.listen(( MouseEvent e ) {
        e.preventDefault();
        document.querySelector( '#eventAlert' ).classes.add( 'hidden' );
        document.querySelector( '#addEvent' ).classes.remove( 'active' );
        currentMap.addingEvent = false;
        MapEvent event = currentMap.events.elementAt( currentMap.events.length - 1) ;
        InputElement nameInput = document.querySelector( '#eventNameInput' );
        SelectElement typeSelect = document.querySelector( '#eventTypeSelect' );
        event.name = nameInput.text;
        event.type = int.parse( typeSelect.text );
        currentMap.update();
        drawEventsList();
        context.callMethod( 'jQuery', [ '#addEventModal' ] ).callMethod( 'modal', [ 'hide' ] );
    });
    
    var cancelEventButton = document.querySelector( '#cancelEventButton' );
    cancelEventButton.onMouseDown.listen(( MouseEvent e ) {
        e.preventDefault();
        document.querySelector( '#eventAlert' ).classes.add( 'hidden' );
        document.querySelector( '#addEvent' ).classes.remove( 'active' );
        currentMap.addingEvent = false;
        // Deletes the last event added since is discarded
        currentMap.events.removeLast();
        drawEventsList();
        context.callMethod( 'jQuery', [ '#addEventModal' ] ).callMethod( 'modal', [ 'hide' ] );
    });
    
}

