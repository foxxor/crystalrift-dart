/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/
library globals;

//Engine vars
const int INITIAL_FRAME = 1;
const int MS_PER_FRAME = 240;
const int SELECTED_CHAR = 2; // Tile X for main character
const int TILE_SIZE = 32;
const int INITIAL_FACE = 0; // Initial facing direction for main character
const int SCREEN_HEIGHT = 512;
const int SCREEN_WIDTH = 672;

const int MAP_HEIGHT_TILES = 32;
const int MAP_WIDTH_TILES = 40;

const int CAMERA_HEIGHT_TILES = 16;
const int CAMERA_WIDTH_TILES = 21;

//Directions
const int LEFT = 2;
const int RIGHT = 3;
const int UP = 0;
const int DOWN = 1;

//Tile types
const int TILE_SOIL = 0;
const int TILE_ITEM = 1;
const int TILE_BUILDING_PASSABLE = 2;
const int TILE_BUILDING_UNPASSABLE = 3;

//Event types
const int EVENT_TYPE_MESSAGE = 0;