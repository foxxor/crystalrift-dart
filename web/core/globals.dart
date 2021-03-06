library globals;

// Engine vars
const int INITIAL_FRAME     = 1;
const int MS_PER_FRAME      = 240;
// Tile X for main character
const int SELECTED_CHAR     = 2;
const int TILE_SIZE         = 32;
// Initial facing direction for main character
const int INITIAL_FACE      = 0; 
const int WINDOW_HEIGHT     = 128;
const int WINDOW_WIDTH      = 680;

const int MAP_HEIGHT_TILES = 34;
const int MAP_WIDTH_TILES = 70;

const int CAMERA_HEIGHT_TILES = 16; //DEPRECATED
const int CAMERA_WIDTH_TILES = 22; //DEPRECATED

// Directions
const int LEFT = 2;
const int RIGHT = 3;
const int UP = 0;
const int DOWN = 1;

// Tile types
const int TILE_SOIL                = 0;
const int TILE_ITEM                = 1;
const int TILE_BUILDING_PASSABLE   = 2;
const int TILE_BUILDING_UNPASSABLE = 3;

// Event types
const int EVENT_TYPE_MESSAGE         = 0;
const int EVENT_TYPE_ANIMATION       = 1;
const int EVENT_TYPE_FIGHT_ANIMATION = 2;

// Animations
const int ANIMATION_FRAME_HEIGHT = 195;
const int ANIMATION_FRAME_WIDTH  = 192;
const int ANIMATION_SPEED        = 4;

// Windowsets
const int WINDOWSET_BORDER_PADDING = 9;
const int WINDOWSET_BG_TILE        = 64;
const int WINDOWSET_FG_TILE        = 64;
const int WINDOWSET_TEXT_PADDING   = 20;

// Centering type
const int CENTER_TYPE_VERTICAL   = 1;
const int CENTER_TYPE_HORIZONTAL = 2;

/* ----- Battle and input ----- */

const bool GAME_START_LOCKED = true;

// Actor behaviours
const int ACTOR_BEHAVIOUR_GOOD    = 1; // Not combatable
const int ACTOR_BEHAVIOUR_NEUTRAL = 2; // Combat only if attacked
const int ACTOR_BEHAVIOUR_FOE     = 3; // Combat if close enough

const int MAX_PATHFINDING_ITERATIONS = 100;

// Actor combat behaviour
const int ACTOR_COMBAT_FLEE      = 1;
const int ACTOR_COMBAR_AGGRESIVE = 2;
const int ACTOR_COMBAT_DEFENSIVE = 3;

/* ----- Editor ----- */

// Selection modes for the editor
const int SINGLE_TILE_SELECTION = 1;
const int MULTI_TILE_SELECTION  = 2;

// Editor map area size in tiles
const int EDITOR_MAP_DEFAULT_TILES_WIDTH  = 32;
const int EDITOR_MAP_DEFAULT_TILES_HEIGHT = 22;

// Type of events
const int EVENT_TYPE_NOT_SPECIFIED  = -1;
const int EVENT_TYPE_STARTING_POINT = 0;
const int EVENT_TYPE_CHARACTER      = 2;
const int EVENT_TYPE_ITEM           = 1;
const int EVENT_TYPE_OBJECT         = 3;
