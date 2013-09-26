/*
  Copyright (C) 2013 Jorge Vargas <vargasjorgeluis@gmail.com>
*/

import 'dart:html';

class Matrix {
  List<List> m;
  
  int rows;
  int cols;
  
  Matrix(int cols, int rows){
    this.rows = rows;
    this.cols = cols;
    this.m = new List<List>(cols);
    for (var i = 0; i < cols; i++) {
      m[i] = new List(rows);
    }
  }
  
  get(int x, int y){
      return m[x][y];
  }
  
  void set(int x, int y, var value){
    m[x][y] = value;
  }
  
}