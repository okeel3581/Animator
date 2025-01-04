class Button{
  String type;
  PVector pos;
  int size;
  boolean isHovered = false;
  boolean isSelected = false;
  boolean clickButton;    // if the button should act as a clickable button or a 'switch'
  PImage icon;

  
  Button(String t, PVector p, int s, PImage i, boolean cb){
    this.type = t;
    this.pos = p;
    this.size = s;
    this.icon = i;
    this.clickButton = cb;
    
   
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
    
    if(!clickButton){
      square(pos.x - size/2, pos.y - size/2, size);
    }
    
    float tempSize = 0.8*size;
    
    image(icon, pos.x - tempSize/2, pos.y - tempSize/2, tempSize, tempSize);

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
        if(type == "PLAYBACK"){    // stopping and starting
          if(isPlaying) icon = loadImage("play.png"); else icon = loadImage("pause.png");
          isPlaying = !isPlaying;
        }
        else if(type == "FORWARD"){
          adjustTimeline(1);
        }
        else if(type == "BACKWARD"){
          adjustTimeline(-1);
        }
        else if(type == "NEWKEYFRAME" && selectedShape != null){
          selectedShape.frameData.set(time, selectedShape.getFrameData(true));
          if(selectedShape != null){
            selectedShape.updateAllKeyframes();
          }
        }
        else{
          for(Button button: buttons){
              button.unselect();
            }
            isSelected = true;
            mouseMode = type;
        }
      }
    }
  }
  
  void unselect(){
    isSelected = false;
  }
}
