![Crystal Rift](https://github.com/foxxor/crystalrift-dart/blob/master/web/assets/web/CrystalRiftLogoTransparent.png?raw=true)

# Crystal Rift - a dart 2D game engine

An HTML5 2D game engine using dart and canvas. Movements and interactions are like Zelda.

[Game live demo here](http://foxxor.github.io/crystalrift-dart/gameengine.html)

[Editor live demo here](http://foxxor.github.io/crystalrift-dart/editor.html)

## What is working?

* Character movement in 4 directions. (W,A,S,D)
* Camera following main character.
* Character collission detection.
* Pushable elements.
* Buildings, characters, items and decorations are loaded dinamically using json files.
* Map tilesets, each tile can have a different graphic and collision rule.
* Character to character interaction. (Enter)
* Actions handling. (On-screen text, framed-animations)
* Particle effects like fire, poison, smoke.
* Text boxes for long texts. (Enter to skip)
* Basic particles and animations.
* Character pathfinding.
* Very basic action battle system.

## Additional Utils in the repository

* Tile selector utility, click on any tile of the tileset to retrieve the x,y coordinates.
* Map editor.

## How to test

#### Dev (runs only on dartium)

To run the dart version of the project (which requires a browser with the Dart VM, such as Dartium), start the web server.

```
node ./server/serve-dev
```

And open the URL, using the absolute path to the file you want to test, such as `http://localhost:8080/gameengine.html`.

#### Build (any browser)

First compile the project to Javascript inside the docs folder.

```
pub build web --output=./docs
```

Then start the node server.

```
node ./server/serve-build
```

And open the URL, using the absolute path to the file you want to test, such as `http://localhost:9099/gameengine.html`.


### TO-DO

* ~~Camera movement with main character~~ Buggy!
* Different maps handling
* Character special actions (Jump, teleport, flip?)
* Lots of things...Dropable items, Battles, Menus.
* Finish the map editor.
* Try to enable multithread processing to improve performance.

### Want to help?

Do you think you can do something better or improve the existing?

Go ahead! Any help is greatly appreciated.
