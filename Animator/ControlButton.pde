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
    //fill(66, 209, 245);
   
    //if(!isMovable){
    //  pushMatrix();
    //  translate(myShape.pos1.x, myShape.pos1.y);
    //  rotate(myShape.rotation);
    //  circle(pos.x - myShape.pos1.x, pos.y - myShape.pos1.y, size);
    //  popMatrix();
    //}
    //else{
    //  circle(pos.x, pos.y, size);
    //}
    

  }

  // mouse pressed: set selected to this control button
  // while mouse pressed (save this value as a variable), the x and y move to the mouse
  // apply these value changes to the other control buttons and shape
  // on mouse release: disable the variable

  // runs when isMovable
  void update() {
    //pos.x = mouseX;
    //pos.y = mouseY;
    
    //PVector cornerVector = PVector.sub(pos, myShape.pos1);
    //float cornerDistance = cornerVector.mag();
    //myShape.size = int((cornerDistance / sqrt(2)) * 2);
    
    //myShape.rotation = cornerVector.heading() + PI/4;    // pi/4 to account for 45 degree difference from center line to corner where you actually click
    
  }
}
