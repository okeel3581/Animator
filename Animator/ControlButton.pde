class ControlButton{
  PVector pos;
  int size;
  boolean isSelected = false;
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

  void update(){
    if(onCircle(pos, size)){
      pos.x = mouseX;
      pos.y = mouseY;
    }
  }

}
