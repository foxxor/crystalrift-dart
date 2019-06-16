library scene;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'dart:math' as Math;

import 'globals.dart';
import '../helpers/coordinate.dart';
import '../lib/message.dart';
import 'mapset.dart';
import 'actor.dart';
import 'entity.dart';
import 'tile.dart';
import 'action.dart';
import 'projectile.dart';
import 'effects/mapAnimation.dart';
import 'effects/particle.dart';
import 'windowset.dart';
import 'modules/battle_module.dart';
import 'modules/input_module.dart';

class Scene 
{
    //Graphic vars
    HtmlDocument document;
    CanvasRenderingContext2D context;
    CanvasElement canvas;

    // Input module to control the game
    InputModule inputModule;

    // Battle module that controls the battle actions
    BattleModule battleModule;
    
    // The current visible map
    MapSet mapSet;

    // The current character playing
    Actor player;

    // The game dialog
    WindowSet gameDialog;

    // List of current characters
    List<Actor> actors;

    // Entities in the scene
    List<Entity> entities;

    // Currently active events
    List<Action> events;

    // Currently active animation
    List<MapAnimation> activeAnimations;

    // Currently action particle effects
    List<Particle> particles;

    // Current active projectiles
    List<Projectile> projectiles;
    
    //Scene size
    int width;
    int height;
    
    //Camera offset tiles
    int displayX;
    int displayY;
    
    //Camera offset px
    int displayPxX;
    int displayPxY;
    
    Scene( HtmlDocument document, CanvasRenderingContext2D context, CanvasElement canvas ) 
    {
        this.document = document;
        this.context  = context;
        this.canvas   = canvas;

        inputModule  = new InputModule( this );
        battleModule = new BattleModule( this );
        
        mapSet = new MapSet( this, MAP_WIDTH_TILES, MAP_HEIGHT_TILES );
        Coordinate initCoor = new Coordinate( 15, 10 );
        Coordinate initCoor2 = new Coordinate( 12 * TILE_SIZE, 4 * TILE_SIZE );
        MapAnimation animation = new MapAnimation( this, initCoor2, 'fire_001' );
        animation.startAnimation();
        Coordinate partCoor = new Coordinate( 12 * TILE_SIZE, 7 * TILE_SIZE );
        Particle particle = new Particle( this, partCoor, "smoke" );
        particle.start();
        particles = new List<Particle>();
        particles.add(particle);
        activeAnimations = new List<MapAnimation>();
        activeAnimations.add(animation);
        player = new Actor( initCoor, 0, 1, this, "characters.png", 1 ); //Main Player
        player.initializeActor( true, ACTOR_BEHAVIOUR_GOOD, 100, 100 );
        //player.moveTo( 13, 4);
        actors = new List<Actor>();
        entities = new List<Entity>();
        displayX = 0;
        displayY = 0;
        displayPxX = 0 * TILE_SIZE;
        displayPxY = 0 * TILE_SIZE;
        events = new List<Action>();
        projectiles = new List<Projectile>();
        loadProperties();
    }

    void createDialog( window )
    {
        String text = "Hi, welcome to this demo of Crystal Rift! \n Use enter key to interact with characters and close this window. \n Use the A/S/D/W keys to move around. \n Enjoy! ";
        gameDialog = new WindowSet( document, context, canvas, 
            ( ( canvas.width ) / 2 ).floor() - ( ( WINDOW_WIDTH / 2 ).floor() + ( width == window.innerWidth ? 0 : width ) ), 
            height - WINDOW_HEIGHT - 50, 
            WINDOW_WIDTH, WINDOW_HEIGHT, text );
    }
    
    Future update() async
    {
        //The order of rendering here controls the priority of visualization
        if ( isCameraMoving() && player.isMoving() )
        {
            updateCameraMovement();
        } 
        else
        {
            stopCameraMovement();
        }

        await mapSet.update();
        await player.update();

        updateCharacters();
        updateEntities();
        updateParticles();
        updateAnimations();
        updateProjectiles();
        updateEvents();

        if ( gameDialog != null && !gameDialog.endOfLine )
        {
            await gameDialog.update();
        } 
        else if ( gameDialog != null && inputModule.inputLocked )
        {
            inputModule.inputLocked = false;
            gameDialog = null;
        }
    }

    void updateEntities() async
    {
        var entitiesIterator = entities.iterator;
        while( entitiesIterator.moveNext() )
        {
            Entity entity = entitiesIterator.current;
            await entity.update();
        }
    }

    void updateEvents() async
    {
        var eventIterator = events.iterator;
        while( eventIterator.moveNext() )
        {
            Action event = eventIterator.current;
            await event.update();
        }
    }

    void updateCharacters() async
    {
       var characters = actors.iterator;
        while( characters.moveNext() )
        {
            Actor character = characters.current;
            await character.update();
        }
    }

    void updateParticles() async
    {
        var particlesIterator = particles.iterator;
        while(  particlesIterator.moveNext() )
        {
            Particle particle = particlesIterator.current;
            await particle.update();
        }
    }

    void updateAnimations() async
    {
        var animationsIterator = activeAnimations.iterator;
        while( animationsIterator.moveNext() )
        {
            MapAnimation animation = animationsIterator.current;
            await animation.update();
        }
    }

    void updateProjectiles() async
    {
        var projectileIterator = projectiles.iterator;
        while( projectileIterator.moveNext() )
        {
            Projectile projectile = projectileIterator.current;
            await projectile.update();
        }
    }

    // Verifies if a coordinate is displayed by the camera
    bool inCamera( Coordinate coord )
    {
        if ( coord.x >= ( displayPxX - TILE_SIZE ) && coord.y >= ( displayPxY - TILE_SIZE ) &&
            coord.x < ( displayPxX + canvas.width + TILE_SIZE ) && coord.y < ( displayPxY + canvas.height + TILE_SIZE ) )
        {
            return true;
        }

        return false;
    } 
    
    void updateCameraMovement()
    {
        var distance = 2 * player.speed;
        if (displayY * TILE_SIZE > displayPxY )
        {
            displayPxY = Math.min( displayPxY + distance, displayY * TILE_SIZE );
        }
        if ( displayX * TILE_SIZE > displayPxX )
        {
            displayPxX = Math.min( displayPxX + distance, displayX * TILE_SIZE );
        }
        if ( displayY * TILE_SIZE < displayPxY )
        {
            displayPxY = Math.max( displayPxY - distance, displayY * TILE_SIZE );
        }
        if ( displayX * TILE_SIZE < displayPxX )
        {
            displayPxX = Math.max( displayPxX - distance, displayX * TILE_SIZE );
        }
    }
    
    bool isCameraMoving()
    {
        return ( displayPxX != displayX * TILE_SIZE || displayPxY != displayY * TILE_SIZE );
    }
    
    void stopCameraMovement()
    {
          if ( displayY * TILE_SIZE > displayPxY )
          {
            num dy = ( displayY + ( TILE_SIZE - ( displayPxY % TILE_SIZE ) ) ) / TILE_SIZE;
            displayY = Math.min( dy.floor(), displayY );
          }
          if ( displayX * TILE_SIZE > displayPxX )
          {
            num dx = ( displayX + ( TILE_SIZE - ( displayPxX % TILE_SIZE ) ) ) / TILE_SIZE;
            displayX = Math.min( dx.floor(), displayX );
          }
          if ( displayY * TILE_SIZE < displayPxY )
          {
            num dy = ( displayPxY + ( TILE_SIZE - ( displayPxY % TILE_SIZE ) ) ) / TILE_SIZE;
            displayY = Math.max( dy.floor(), displayY ) -1;
          }
          if ( displayX * TILE_SIZE < displayPxY )
          {
            num dx = ( displayPxX + ( TILE_SIZE - ( displayPxX % TILE_SIZE ) ) ) / TILE_SIZE;
            displayX = Math.max( dx.floor(), displayX ) -1;
          }
    }
    
    void movePlayer(int direction)
    {
        player.move( direction );

        switch ( direction )
        {
            case UP:
                if ( player.curPos.y > ( canvas.height / ( 2 * TILE_SIZE ) ).floor()
                    && player.curPos.y < ( mapSet.height - displayY )
                    && player.curPos.y < mapSet.height - ( canvas.height / ( 2 * TILE_SIZE ) ).floor() ) 
                {
                    centerCamera( CENTER_TYPE_VERTICAL );
                }
            break;
            case DOWN:
                if ( player.curPos.y > ( canvas.height / ( 2 * TILE_SIZE ) ).floor()
                    && player.curPos.y < ( mapSet.height - displayY )
                    && player.curPos.y < mapSet.height - ( canvas.height / ( 2 * TILE_SIZE ) ).floor() )
                {
                    centerCamera( CENTER_TYPE_VERTICAL );
                }
            break;
            case LEFT:
                if ( player.curPos.x < ( canvas.width - displayX )
                    && player.curPos.x < mapSet.width - ( canvas.width / ( 2 * TILE_SIZE ) ).floor() )
                {
                    centerCamera( CENTER_TYPE_HORIZONTAL );
                }
            break;
            case RIGHT:
                if ( player.curPos.x < ( canvas.width - displayX )
                    && player.curPos.x < mapSet.width - ( canvas.width / ( 2 * TILE_SIZE ) ).floor() )
                {
                    centerCamera( CENTER_TYPE_HORIZONTAL );
                }
            break;  
        }
    }
    
    // This have to be adjusted depending if the window size is odd or even
    void centerCamera( int type )
    {
      if ( type == CENTER_TYPE_HORIZONTAL )
      {
        displayX = Math.max(
            Math.min( player.curPos.x - ( canvas.width / ( 2 * TILE_SIZE ) ).floor(), MAP_WIDTH_TILES ),
            0);
      } 
      else 
      {
        displayY = Math.max(
            Math.min( player.curPos.y - ( canvas.height / ( 2 * TILE_SIZE ) ).floor(), MAP_HEIGHT_TILES ),
            0);
      }
    }
    
    void loadProperties()
    {
        HttpRequest.getString( "data/characters.json" ).then( loadCharacters );
        HttpRequest.getString( "data/structures.json" ).then( loadBuildings );
        HttpRequest.getString( "data/entities.json" ).then( loadEntities );
    }
    
    void loadEntities( String responseText )
    {
        Map entitiesData = json.decode( responseText );
        var iteEntities = entitiesData['entities'].iterator;
        while( iteEntities.moveNext() )
        {
            Map i = iteEntities.current;
            Coordinate coords = new Coordinate( i['x'], i['y'] );
            Tile tile = new Tile( i['xTile'], i['yTile'] );
            Entity item = new Entity( document, context, canvas, coords, tile, this, i['pushable'] );
            entities.add(item);
            mapSet.occupyTile( i['x'], i['y'], item );
        }
    }
    
    void loadCharacters( String responseText )
    {
        Map charactersData = json.decode( responseText );
        var characters = charactersData['characters'].iterator;
        while( characters.moveNext() )
        {
            Map m = characters.current;
            Coordinate coords = new Coordinate( m['x'], m['y'] );
            Actor character = new Actor( coords, m['characterId'], m['characterRow'], this, m['imageSource'], m['speed'], m['moveRandom'] );
            character.initializeActor( m['combatable'], m['behaviour'], m['life'], m['energy'], m['message'], m['attack'], m['defense'] );
            actors.add(character);
            mapSet.occupyTile( m['x'], m['y'], character );
        }
    }
    
    void loadBuildings( String responseText )
    {
        mapSet.structuresData = json.decode( responseText );
        mapSet.addBuilding(0, 6,5);
        mapSet.addRandomDetails();
    }
    
    void createMessage( Actor char )
    {
        Message msg = new Message( context, char.message, char.screenPosPx.x, char.screenPosPx.y, 100, 20 );
        const ms = const Duration( milliseconds: 5000 );
        new Timer( ms, removeEvent );
        Action event = new Action( char, msg, EVENT_TYPE_MESSAGE );
        events.add( event );
    }
    
    void createAnimation( Actor char )
    {
        Coordinate coords = new Coordinate( 0,0 );
        MapAnimation animation = new MapAnimation( this, coords, 'fire_001' );
        Action event = new Action( char, animation, EVENT_TYPE_ANIMATION );
        events.add( event );
        animation.startAnimation();
        new Timer( const Duration( milliseconds: 500 ), removeEvent );
    }
    
    void removeEvent() 
    {
        Action event = events.elementAt( 0 );
        if ( event.type == EVENT_TYPE_MESSAGE ) {
            Actor char = event.object;
            char.trigger = false;
        }
        events.removeAt( 0 );
    }

    void removeProjectile( Projectile projectile )
    {
        List<Projectile> newProjectilesList = new List<Projectile>.from( projectiles );
        newProjectilesList.removeWhere( ( value ) => value == projectile );

        // Replaces the projectiles with the new list to avoid errors with the iterator
        projectiles = newProjectilesList;
    }
    
    bool shallPass( int face, var character )
    {
        Coordinate facingCoords;
        if ( face == UP && character.curPos.y >= 1 )
        {
            facingCoords = new Coordinate( character.curPos.x, character.curPos.y - 1 );
        } 
        else if ( face == DOWN && character.curPos.y < mapSet.eventMapset.rows - 1 ) 
        {
            facingCoords = new Coordinate( character.curPos.x, character.curPos.y + 1 );
        } 
        else if ( face == LEFT && character.curPos.x >= 1 ) {
            facingCoords = new Coordinate( character.curPos.x - 1, character.curPos.y );
        } 
        else if ( face == RIGHT && character.curPos.x < mapSet.eventMapset.cols - 1 ) 
        {
            facingCoords = new Coordinate( character.curPos.x + 1, character.curPos.y );
        } 
        else 
        {
            return false;
        }
      
      return objectIsPassable( character, facingCoords, face );
    }
    
    bool objectIsPassable( var character, Coordinate facingCoords, int face )
    {
        var tileObject = mapSet.eventMapset.get( facingCoords.x, facingCoords.y );
        if ( !identical( tileObject, character ) && tileObject != null ) {
            if ( tileObject is Actor && !tileObject.phasable ){
                return false;
            } else if ( tileObject is Tile ) {
                return false;
            } else if ( tileObject is Entity && !tileObject.pushable ) {
                return false;
            } else if( tileObject is Entity && tileObject.pushable ) {
                if ( !tileObject.move( face ) ) {
                    return false;
                }
            }
        }
      
        if ( character != player )
        {
            bool nextTo = player.curPos.equals( facingCoords );
            if ( !player.phasable && nextTo )
            {
                return false;
            }
        }
        return true;
    }
    
    Actor getCharacterInFront( [ var entity = null ] )
    {
        var characters = actors.iterator;
        while( characters.moveNext() )
        {
            Actor char = characters.current;

            if ( entity == null )
            {
                entity = player;
            }
            int charFace = char.curPosPx.facingThis( entity.getCurrentDirection(), entity.curPosPx );
            if ( charFace >= 0 )
            {
                if ( identical( entity, player ) )
                {
                    char.faceDirection( charFace );
            }
            return char;
            }
        }
        return null;
    }
}