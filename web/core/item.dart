/*
  Copyright (C) 2014 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

library item;

import 'dart:html';
import 'dart:async';
import 'globals.dart';
import 'graphic.dart';
import 'scene.dart';
import '../helpers/coordinate.dart';
import 'dart:math' as Math;

class Item implements Graphic{

	 //Graphic vars
	HtmlDocument doc;
	CanvasRenderingContext2D ctx;
	CanvasElement canvas;
	ImageElement itemImage;

	//Parent scene calling this objetc
	Scene scene;

	// Current position in tiles
	Coordinate curPos;

	// Current position in pixels
	Coordinate curPosPx;
	
	// Current position relative to screen in pixels
	Coordinate screenPosPx;

	Item(Coordinate this.curPos, int selectedChar, int characterRow, Scene this.scene, String imageSource){

	}

	void loadGraphic(String src){
		this.itemImage = new Element.tag('img'); 
		this.itemImage = doc.createElement('img'); 
		this.itemImage.src = src;
	}

	void update(){

	}

}