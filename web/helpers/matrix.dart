/**
 * Matrix data structure
 * A 2-dimensional array that store generic values of each positions
 */

library matrix;

class Matrix {
  //Main matrix object list of lists
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
  
  //Method to serialize a matrix in something dart understands 
  Map toJson() { 
    Map map = new Map();
    for (var i = 0; i < cols; i++) {
      map[i.toString()] = new Map();
      for (var e = 0; e < rows; e++) {
        if(m[i][e] is int){
          map[i.toString()][e.toString()] = m[i][e].toString();
        }else{
          map[i.toString()][e.toString()] = m[i][e].toJson();
        }
      }
    }
    return map;
  }
}