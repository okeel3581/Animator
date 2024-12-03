class ControlButton{
  PVector pos;
  int size;
  boolean isMovable = false;
  Shape myShape;
  
  ControlButton(PVector p, int s, Shape myS){
    this.pos = p;
    this.size = s;
    this.myShape = myS;
  }

  void drawMe(){
    fill(66, 209, 245);
    circle(pos.x, pos.y, size);
  }

  // mouse pressed: set selected to this control button
  // while mouse pressed (save this value as a variable), the x and y move to the mouse
  // apply these value changes to the other control buttons and shape
  // on mouse release: disable the variable


  void update(){
    pos.x = mouseX;
    pos.y = mouseY;
    myShape.size = int(dist(pos.x, pos.y, myShape.pos1.x, myShape.pos1.y) - sqrt(pow(size, 2) + pow(size, 2)));
  }
}
