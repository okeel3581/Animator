class Button{
  String type;
  PVector pos;
  int size;
  boolean isHovered = false;
  boolean isSelected = false;

  
  Button(String t, PVector p, int s){
    this.type = t;
    this.pos = p;
    this.size = s;
    
   
  }
  
  void drawMe(){ 
    if(isSelected){
      strokeWeight(4);
      stroke(0, 0, 255);
    }
    else if(isHovered){
      strokeWeight(2);
      stroke(0, 0, 100);
    }
    else{
      strokeWeight(1);
      stroke(0);
    }
  
    fill(255);
  
    square(pos.x - size/2, pos.y - size/2, size);

    strokeWeight(1);
    stroke(0);
  
  }
  
  void checkHover(){
    if(onSquare(pos.x, pos.y, size, size)) {    // change sizes for 2 dimensions
      isHovered = true; 
    }
    else isHovered = false;
    
  }
  
  void checkSelect(){
    if(isHovered && selected == "NONE"){
      if(onSquare(pos.x, pos.y, size, size) && isHovered) {    // change sizes for 2 dimensions
        for(Button button: buttons){
          button.unselect();
        }
        isSelected = true;
        mouseMode = type;
      }
    }
  }
  
  void unselect(){
    isSelected = false;
  }
}
