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
    println(myShape.pos1);
    // rotate around the shape
    //pushMatrix();
    //translate(pos.x, pos.y);
    //rotate(myShape.rotation);
    //translate(-pos.x, -pos.y);

    circle(pos.x, pos.y, size);
    //popMatrix();

  }

  // mouse pressed: set selected to this control button
  // while mouse pressed (save this value as a variable), the x and y move to the mouse
  // apply these value changes to the other control buttons and shape
  // on mouse release: disable the variable

  // runs when isMovable
  void update() {
    pos.x = mouseX;
    pos.y = mouseY;
    
    PVector cornerVector = PVector.sub(pos, myShape.pos1);
    float cornerDistance = cornerVector.mag();
    myShape.size = int((cornerDistance / sqrt(2)) * 2);
    
    myShape.rotation = cornerVector.heading();
    
  }
}
