/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library graphic;

//Abstract class of a graphical element
abstract class Graphic {
  
  //This init the graphical element
  void loadGraphic(String src);
  
  //Update class for the refresh of the element
  void update();
  
}