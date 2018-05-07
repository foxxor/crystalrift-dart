library coordinate;

import 'dart:math' as Math;

import '../core/globals.dart';

class Coordinate {
    num x;
    num y;
    
    Coordinate ( num xi, num yi ) {
        this.x = xi;
        this.y = yi;
    }
    
    /**
     * Check if this coordinate is next and facing the input coordinate
     * 
     * @param int face
     * @param Coordinate coordinate
     * @return bool
     */
    bool nextToThis( int face, Coordinate coordinate ) {
        num deltaX = coordinate.x - x;
        num deltaY = coordinate.y - y;
        
        if ( deltaX == 0 && deltaY.ceil() == 1 && face == UP ) {
            return true;
        } else if ( deltaX == 0 && deltaY.round() == -1 && face == DOWN ) {
            return true;
        } else if ( deltaX.ceil() == 1 && deltaY == 0 && face == LEFT ) {
            return true; 
        } else if ( deltaX.round() == -1 && deltaY == 0 && face == RIGHT ) {
            return true;
        }
        return false;
    }
    
    /**
     * Returns the distance from this coordinate to another coordinate
     * 
     * @param Coordinate coordinate
     * @return num
     */
    num distanceToThis( Coordinate coordinate ) {
        return ( x - coordinate.x ).abs() + ( y - coordinate.y ).abs();
    }
    
    /**
     * Returns the face direction to another coordinate
     * 
     * @param int face
     * @param Coordinate coordinate
     * Return int
     */
    int facingThis( int face, Coordinate coordinate ){
        num deltaX = ( ( coordinate.x - x ) / TILE_SIZE );
        num deltaY = ( ( coordinate.y - y ) / TILE_SIZE );
        
        if ( deltaX == 0 && deltaY.ceil() == 1 && face == UP ) {
            return DOWN;
        } else if ( deltaX == 0 && deltaY.round() == -1 && face == DOWN ) {
            return UP;
        } else if ( deltaX.ceil() == 1 && deltaY == 0 && face == LEFT ) {
            return RIGHT;
        } else if ( deltaX.round() == -1 && deltaY == 0 && face == RIGHT ) {
            return LEFT;
        }
        
        return -1;
    }
    
    /**
     * Checks if this coordinate is the same as another coordinate
     * 
     * @param Coordinate coordinate
     * @return bool
     */
    bool equals( Coordinate coordinate ) {
        if ( coordinate.x == x && coordinate.y == y ) {
            return true;
        }
        return false;
    }
}