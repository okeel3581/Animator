class Shape{
  String type;
  PVector pos1, pos2, pos3;
  int size;
  boolean isHovered = false;
  boolean isSelected = false;
  boolean isMovable = false;
  ArrayList<ControlButton> controlButtons = new ArrayList<ControlButton>();
  int buttonSize = 8;
  
  Shape(String t, PVector p, int s){
    this.type = t;
    this.pos1 = p;
    this.size = s;
    
    // create default control buttons for a square
    if(type == "SQUARE"){
      controlButtons.add(new ControlButton(new PVector(pos1.x - size/2 - buttonSize, pos1.y - size/2 - buttonSize), buttonSize, this));  // top left
      controlButtons.add(new ControlButton(new PVector(pos1.x + size/2 + buttonSize, pos1.y - size/2 - buttonSize), buttonSize, this));  // top right
      controlButtons.add(new ControlButton(new PVector(pos1.x - size/2 - buttonSize, pos1.y + size/2 + buttonSize), buttonSize, this));  // bottom left
      controlButtons.add(new ControlButton(new PVector(pos1.x + size/2 + buttonSize, pos1.y + size/2 + buttonSize), buttonSize, this));  // bottom right

    }
  }
  
  Shape(String t, PVector p1, PVector p2, PVector p3, int s){
    this.type = t;
    this.pos1 = p1;
    this.pos2 = p2;
    this.pos3 = p3;
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
    
    if(isMovable){
      fill(215);
    }
    else{
      fill(255);
    }
    
    if(type == "SQUARE"){
      rect(pos1.x - size/2, pos1.y - size/2, size, size);
    } 
    else if(type == "TRIANGLE"){
      triangle(pos1.x, pos1.y, pos2.x, pos2.y, pos3.x, pos3.y);
    }
    else if (type == "CIRCLE"){
      circle(pos1.x, pos1.y, size);
    }
    strokeWeight(1);
    stroke(0);
  }
  
  void drawControls(){
    if(type == "SQUARE"){
      
    }
  }
  
  void checkHover(){
    if(type == "SQUARE"){
      if(onSquare(pos1.x, pos1.y, size, size)) {    // change sizes for 2 dimnesions
        isHovered = true; 
      }
      else isHovered = false;
    }
    else if(type == "TRIANGLE"){
      if(onTriangle(pos1, pos2, pos3)){
        isHovered = true;
      }
      else isHovered = false;
    }
    else if(type == "CIRCLE"){
      if(onCircle(pos1, size)){
        isHovered = true;
      }
      else isHovered = false;
    }
  }
  
  void checkSelect(){
    if(type == "SQUARE" && isHovered && selected == "NONE"){
      if(onSquare(pos1.x, pos1.y, size, size) && isHovered) {    // change sizes for 2 dimnesions
        isSelected = true;
        selected = "SHAPE";
        selectedShape = this;
      }
    }
    else if(type == "TRIANGLE" && isHovered && selected == "NONE"){
      if(onTriangle(pos1, pos2, pos3)){
        isSelected = true;
        selected = "SHAPE";
        selectedShape = this;
      }
    }
    else if(type == "CIRCLE" && isHovered && selected == "NONE"){
      if(onCircle(pos1, size)){
        isSelected = true;
        selected = "SHAPE";
        selectedShape = this;
      }
    }
  }
}
