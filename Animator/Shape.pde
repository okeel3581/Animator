class Shape{
  String type;
  PVector pos1;
  float size;
  boolean isHovered = false;
  boolean isSelected = false;
  boolean isMovable = false;
  boolean isResizable = false;
  boolean isRotatable = false;
  boolean isTransformable = false;
  ArrayList<ControlButton> controlButtons = new ArrayList<ControlButton>();
  int buttonSize = 8;
  float rotation = 0;
  
  ArrayList<Keyframe> frameData = new ArrayList<Keyframe>();

  
  Shape(String t, PVector p, int s){
    this.type = t;
    this.pos1 = p;
    this.size = s;
    
    // create default control buttons for a square
    if(type == "SQUARE"){
      controlButtons.add(new ControlButton(new PVector(pos1.x - size/2, pos1.y - size/2), buttonSize, this));  // top left
      controlButtons.add(new ControlButton(new PVector(pos1.x + size/2, pos1.y - size/2), buttonSize, this));  // top right
      controlButtons.add(new ControlButton(new PVector(pos1.x - size/2, pos1.y + size/2), buttonSize, this));  // bottom left
      controlButtons.add(new ControlButton(new PVector(pos1.x + size/2, pos1.y + size/2), buttonSize, this));  // bottom right

    }
    
    for(int i = 0; i < numFrames; i++){
      frameData.add(new Keyframe(pos1, size, rotation, false));
    }
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
    
    if(isMovable || isResizable || isRotatable){
      fill(215);
    }
    else{
      fill(255);
    }
    
    if(type == "SQUARE"){
      
      // TRANSLATE TO POSITION TO ROTATE AROUND (ITSELF IN THIS CASE)
      // ROTATE BY RADIANS 
      // DRAW RECTANGLE BY SIZE AROUND 0, 0
      //-------------
      
      pushMatrix();
      translate(pos1.x, pos1.y);
      rotate(rotation);
      rect(-size / 2, -size / 2, size, size);
      popMatrix();
      
      
    } 
    else if(type == "TRIANGLE"){
      pushMatrix();
      translate(pos1.x, pos1.y);
      rotate(rotation);
      triangle(-size/2, size/(2*sqrt(3)), size/2, size/(2*sqrt(3)), 0, -size/sqrt(3));
      popMatrix();
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
  
  void updateAllKeyframes(){
    ArrayList<Keyframe> guidingFrameData = new ArrayList<Keyframe>();
    ArrayList<Integer> guidingFrameTimes = new ArrayList<Integer>();
    
    // find and store all guiding keyframes, keyframes do not need to be sorted
    // as they are derived from the original set of frames, which is by definition in order
    int i = 0;
    for(Keyframe keyframe: frameData){
      if(keyframe.guidingKeyframe){
        guidingFrameData.add(keyframe);
        guidingFrameTimes.add(i);
      }
      i++;
    }
    
    
    
    if(guidingFrameData.size() == 1){
      for(Keyframe keyframe: frameData){
        if(keyframe != guidingFrameData.get(0)){
          keyframe.fillThroughSet(guidingFrameData.get(0));    // fill with copies of the guiding frame
        }
      }
    }
    
    else if(guidingFrameData.size() == 0){
      for(Keyframe keyframe: frameData){
        keyframe.fillThroughSet(getFrameData(false));    // fill with copies of current frame
      }
    }
    
    // TODO: SORT ITEMS IN LIST BY THEIR VALUE IN GUIDINGFRAMETIMES
    else{
      // fill all leading to first keyframe
      for(int k = 0; k < guidingFrameTimes.get(0); k++){
        frameData.get(k).fillThroughSet(guidingFrameData.get(0));
      }
      
      // fill all after last keyframe
      for(int k = guidingFrameTimes.get(guidingFrameTimes.size() - 1) + 1; k < numFrames; k++){
        frameData.get(k).fillThroughSet(guidingFrameData.get(guidingFrameData.size() - 1));
      }
      
      // fill in between keyframes: runs n (num guiding keyframes) - 1 times
      for(int k = 0; k < guidingFrameData.size() - 1; k++){
        int firstKeyframeTime = guidingFrameTimes.get(k);
        int secondKeyframeTime = guidingFrameTimes.get(k + 1);    // the index after k
        Keyframe firstKeyframe = guidingFrameData.get(k);
        Keyframe secondKeyframe = guidingFrameData.get(k + 1);
        
        for(int j = firstKeyframeTime + 1; j < secondKeyframeTime; j++){
          float transitionScale = map(j, firstKeyframeTime, secondKeyframeTime, 0, 1);  // NO +1/-1
          
          float newX, newY, newSize, newRotation;
          
          if(lerpTransitions){
            // smoother step transition
            float smoothStep = 6 * pow(transitionScale, 5) - 15 * pow(transitionScale, 4) + 10 * pow(transitionScale, 3);
            
            // smooth step transition
            //float smoothStep = -2 * pow(transitionScale, 3) + 3 * pow(transitionScale, 2);
            newX = map(smoothStep, 0, 1, firstKeyframe.pos1.x, secondKeyframe.pos1.x);
            newY = map(smoothStep, 0, 1, firstKeyframe.pos1.y, secondKeyframe.pos1.y);
            newSize = map(smoothStep, 0, 1, firstKeyframe.size, secondKeyframe.size);
            newRotation = map(smoothStep, 0, 1, firstKeyframe.rotation, secondKeyframe.rotation);
          }
          else{
            newX = map(transitionScale, 0, 1, firstKeyframe.pos1.x, secondKeyframe.pos1.x);
            newY = map(transitionScale, 0, 1, firstKeyframe.pos1.y, secondKeyframe.pos1.y);
            newSize = map(transitionScale, 0, 1, firstKeyframe.size, secondKeyframe.size);
            newRotation = map(transitionScale, 0, 1, firstKeyframe.rotation, secondKeyframe.rotation);
          }
         
          
          Keyframe newKeyframe = new Keyframe(new PVector(newX, newY), newSize, newRotation, false);
          frameData.set(j, newKeyframe);
        }
      }
    }
  }
  
  Keyframe getFrameData(boolean guiding){
    return new Keyframe(pos1, size, rotation, guiding);    // guiding keyframe as it has been directly edited
  }
  
  void checkHover(){
    if(type == "SQUARE" && !onUI()){
      if(onSquare(pos1.x, pos1.y, size, size)) {    // change sizes for 2 dimensions
        isHovered = true; 
      }
      else isHovered = false;
    }
    else if(type == "TRIANGLE" && !onUI()){
      if(onTriangle(new PVector(pos1.x - size/2, pos1.y + size/(2*sqrt(3))), new PVector(pos1.x + size/2, pos1.y + size/(2*sqrt(3))), new PVector(pos1.x, pos1.y - size/sqrt(3)))){
        isHovered = true;
      }
      else isHovered = false;
    }
    else if(type == "CIRCLE" && !onUI()){
      if(onCircle(pos1, size)){
        isHovered = true;
      }
      else isHovered = false;
    }
  }
  
  void checkSelect(){
    if(type == "SQUARE" && isHovered && selected == "NONE"){
      if(onSquare(pos1.x, pos1.y, size, size) && isHovered) {    // change sizes for 2 dimensions
        isSelected = true;
        selected = "SHAPE";
        selectedShape = this;
      }
    }
    else if(type == "TRIANGLE" && isHovered && selected == "NONE"){
      if(onTriangle(new PVector(pos1.x - size/2, pos1.y + size/(2*sqrt(3))), new PVector(pos1.x + size/2, pos1.y + size/(2*sqrt(3))), new PVector(pos1.x, pos1.y - size/sqrt(3)))){
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
