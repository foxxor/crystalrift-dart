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
const int SCREEN_HEIGHT = 544;
const int SCREEN_WIDTH = 672;

const int MAP_HEIGHT_TILES = 24;
const int MAP_WIDTH_TILES = 30;

const int CAMERA_HEIGHT_TILES = 16;
const int CAMERA_WIDTH_TILES = 22;

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
const int EVENT_TYPE_ANIMATION = 1;

//Animations
const int ANIMATION_FRAME_HEIGHT = 195;
const int ANIMATION_FRAME_WIDTH = 192;

//Windowsets
const int WINDOWSET_BORDER_PADDING = 9;
const int WINDOWSET_BG_TILE = 64;
const int WINDOWSET_FG_TILE = 64;
const int WINDOWSET_TEXT_PADDING = 20;

//Centering type
const int CENTER_TYPE_VERTICAL = 1;
const int CENTER_TYPE_HORIZONTAL = 2;

//Types of actors
const int ACTOR_BEHAVIOUR_GOOD = 1;
const int ACTOR_BEHAVIOUR_NEUTRAL = 2;
const int ACTOR_BEHAVIOUR_FOE = 3;

const int MAX_PATHFINDING_ITERATIONS = 800;



