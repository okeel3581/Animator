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
    
    //PVector tempPos = pos;
    println(myShape.rotation);
    //if(myShape.rotation != 0){
    //pos.x = tempPos.x + myShape.pos1.x * cos(myShape.rotation) - myShape.pos1.y * sin(myShape.rotation);
    //pos.y = tempPos.y + myShape.pos1.y * sin(myShape.rotation) + myShape.pos1.y * cos(myShape.rotation);
    //}
    //println(myShape.rotation);
    //pushMatrix();
    //pos = new PVector(20, 20);
    //translate(-myShape.pos1.x, -myShape.pos1.y);
    //rotate(myShape.rotation);
    if(!isMovable){
      pushMatrix();
      translate(myShape.pos1.x, myShape.pos1.y);
      rotate(myShape.rotation);
      circle(pos.x - myShape.pos1.x, pos.y - myShape.pos1.y, size);
      popMatrix();
    }
    else{
      circle(pos.x, pos.y, size);
    }
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
    
    myShape.rotation = cornerVector.heading() + PI/4;
    
  }
}
