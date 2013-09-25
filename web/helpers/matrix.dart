/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';

class Matrix {
  List<List> m;
  
  Matrix(int rows, int cols){
    this.m = new List<List>(rows);
    for (var i = 0; i < rows; i++) {
      m[i] = new List(cols);
    }
  }
  
  get(int x, int y){
    return m[x][y];
  }
  
  void set(int x, int y, var value){
    m[x][y] = value;
  }
  
}