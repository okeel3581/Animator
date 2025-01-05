//import g4p_controls.*;

int uiSize;
int sideLength;
int time;
int maxTime;
int leftSide;
int rightSide;
int middle;
int ySide;
int sizeSide;
int numFrames;
float timelineX;

Shape selectedShape;
String selected;
String mouseMode;    // click, rotate, resize, etc.
ArrayList<Shape> shapes = new ArrayList<Shape>();

ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<Button> timelineButtons = new ArrayList<Button>();


boolean isPlaying;
boolean lerpTransitions;

void setup() {
  frameRate(60);
  background(255);
  smooth(2);
  size(1200, 700);
  selected = "NONE";
  selectedShape = null;
  mouseMode = "CLICK";

  uiSize = 200;
  sideLength = 40;
  time = 0;
  maxTime = 500;    // NOTE: While the max time is a certain number, the number of actual frames is 1 more (for frame 0)
  numFrames = maxTime + 1;
  leftSide = uiSize + 20;
  rightSide = width - 20;
  middle = (rightSide + leftSide) / 2;
  ySide = height - 125;
  sizeSide = 20;
  timelineX = leftSide;
  isPlaying = false;
  lerpTransitions = true;

  // setup edit buttons
  buttons.add(new Button("CLICK", new PVector(uiSize/3, 400), 40, loadImage("move.png"), false));
  buttons.add(new Button("RESIZE", new PVector(2*uiSize/3, 400), 40, loadImage("resize.png"), false));
  buttons.add(new Button("ROTATE", new PVector(uiSize/3, 460), 40, loadImage("rotate.png"), false));
  buttons.add(new Button("TRANSFORM", new PVector(2*uiSize/3, 460), 40, loadImage("transform.png"), false));
  buttons.add(new Button("DELETE", new PVector(uiSize/3, 520), 40, loadImage("delete.png"), false));

  buttons.get(0).isSelected = true;

  // setup timeline buttons
  timelineButtons.add(new Button("PLAYBACK", new PVector(middle, 660), 50, loadImage("play.png"), true));
  timelineButtons.add(new Button("FORWARD", new PVector(middle + 80, 660), 50, loadImage("forward.png"), true));
  timelineButtons.add(new Button("BACKWARD", new PVector(middle - 80, 660), 50, loadImage("backward.png"), true));
  timelineButtons.add(new Button("NEWKEYFRAME", new PVector(middle - 200, 660), 50, loadImage("keyframeEXTRA.png"), true));

}

void draw() {
  background(255);

  if (isPlaying) {
    adjustTimeline(1);
  }
  
  for(Shape s: shapes){
    int i = 0;
    for(Keyframe k: s.frameData){
      if(k.guidingKeyframe) println(str(i) + ", " + str(time));
      i++;
    }
  }
  
  
  drawUI();
  drawTimeline();
  drawKeyframes();
}

void drawButtons() {
  for (Button button : buttons) {
    button.checkHover();
    button.drawMe();
  }

  for (Button button : timelineButtons) {
    button.checkHover();
    button.drawMe();
  }
}

void drawUI() {
  // draw shapes
  for (Shape shape : shapes) {
    shape.checkHover();
    shape.drawMe();
    if (shape.isSelected) selectedShape = shape;    // TEMP WORKING FIX TO SELECTED SHAPE NOT SHOWING
  }

  strokeWeight(1);
  stroke(0);

  // ui lines
  fill(230);
  rect(-10, -10, uiSize, height + 10);

  rect(uiSize - 10, height - 225, width, height);

  // ui buttons
  fill(255);
  rect(uiSize/2 - 20, 80, 40, 40);

  fill(255);
  triangle(uiSize/2 - sideLength/2, 200, uiSize/2 + sideLength/2, 200, uiSize/2, 200 - (sqrt(3)/2)*sideLength);


  fill(255);
  circle(uiSize/2, 260, 40);

  drawButtons();

  // drawing selected
  if (selected == "SQUARE") {
    fill(255);
    rect(mouseX - 20, mouseY - 20, 40, 40);
  }

  if (selected == "TRIANGLE") {
    fill(255);
    triangle(mouseX - sideLength/2, mouseY + sideLength/(2*sqrt(3)), mouseX + sideLength/2, mouseY + sideLength/(2*sqrt(3)), mouseX, mouseY - sideLength/(sqrt(3)));
  }

  if (selected == "CIRCLE") {
    fill(255);
    circle(mouseX, mouseY, 40);
  }

  if (selected == "TIMELINE") {
    time = constrain(int(map(mouseX, leftSide, rightSide, 0, maxTime)), 0, maxTime);
    timelineX = constrain(mouseX, leftSide, rightSide);
  }

  for (Shape shape : shapes) {
    if (mouseMode == "CLICK" && shape.isMovable) {
      shape.pos1 = new PVector(mouseX, mouseY);
    } else if (mouseMode == "RESIZE" && shape.isResizable) {
      shape.size = int(dist(mouseX, mouseY, shape.pos1.x, shape.pos1.y)) * 2;
    } else if (mouseMode == "ROTATE" && shape.isRotatable) {
      PVector mouseVector = new PVector(mouseX, mouseY);
      PVector base = mouseVector.sub(shape.pos1);
      shape.rotation = base.heading();
    } else if (mouseMode == "TRANSFORM" && shape.isTransformable) {
      PVector mouseVector = new PVector(mouseX, mouseY);
      PVector base = mouseVector.sub(shape.pos1);
      shape.rotation = base.heading();
      shape.size = int(dist(mouseX, mouseY, shape.pos1.x, shape.pos1.y)) * 2;
    }
  }

  // create timeline text
  fill(0);
  textAlign(CENTER);
  textSize(18);
  text(time, timelineX, ySide - 25);

  if (timelineX >= leftSide + leftSide*0.1) {
    text("0", leftSide, ySide - 25);
  }
  if (timelineX <= rightSide - (rightSide - leftSide)*0.1) {
    text(maxTime, rightSide, ySide - 25);
  }
}

void adjustTimeline(int dTime) {
  time = constrain(time += dTime, 0, maxTime);
  timelineX = map(time, 0, maxTime, leftSide, rightSide);

  // update shapes to match keyframes
  for (Shape shape : shapes) {
    shape.pos1 = shape.frameData.get(time).pos1;
    shape.size = shape.frameData.get(time).size;
    shape.rotation = shape.frameData.get(time).rotation;
  }
}

void drawKeyframes() {
  fill(0);
  stroke(0);
  textAlign(LEFT);
  textSize(20);

  String displayText = (selectedShape == null) ? "NONE" : selectedShape.type + " " + shapes.indexOf(selectedShape);

  text("Selected Shape: " + displayText, uiSize + 50, 665);

  textAlign(CENTER);
  
  textSize(18);
  // draw guiding keyframes
  int tempTime = 0;
  if (selectedShape != null) {
    for (Keyframe keyframe : selectedShape.frameData) {
      if (keyframe.guidingKeyframe) {
        float keyframeX = map(tempTime, 0, maxTime, leftSide, rightSide);
        //square(keyframeX - 5, ySide - 5, 10);
        PImage keyframeIcon = loadImage("keyframe.png");
        image(keyframeIcon, keyframeX - 15, ySide - 15, 30, 30);
        text(tempTime, keyframeX, ySide + 35);
        
        
      }
      tempTime++;
    }
  }
}

void drawTimeline() {
  strokeWeight(2);
  stroke(0);

  line(leftSide, ySide, rightSide, ySide);
  line(leftSide, ySide - sizeSide, leftSide, ySide + sizeSide);
  line(rightSide, ySide - sizeSide, rightSide, ySide + sizeSide);

  strokeWeight(2);
  rect(timelineX - 5, ySide - 15, 10, 30);
}

void mousePressed() {


  if (selected == "NONE") {
    if (onSquare(uiSize/2, 100, 40, 40)) {
      selected = "SQUARE";
    } else if (onTriangle(new PVector(uiSize/2 - sideLength/2, 200), new PVector(uiSize/2 + sideLength/2, 200), new PVector(uiSize/2, 200 - (sqrt(3)/2)*sideLength))) {
      selected = "TRIANGLE";
    } else if (onCircle(new PVector(uiSize/2, 260), 40)) {
      selected = "CIRCLE";
    } else if (onSquare(timelineX, ySide, 10, 30)) {
      selected = "TIMELINE";
    }
  }

  for (Shape shape : shapes) {
    if (shape.isSelected && shape.isHovered && mouseMode == "CLICK") {
      shape.isMovable = true;
      cursor(MOVE);
    } else if (shape.isSelected && shape.isHovered && mouseMode == "RESIZE") {
      shape.isResizable = true;
      cursor(CROSS);
    } else if (shape.isSelected && shape.isHovered && mouseMode == "ROTATE") {
      shape.isRotatable = true;
      cursor(HAND);
    } else if (shape.isSelected && shape.isHovered && mouseMode == "TRANSFORM") {
      shape.isTransformable = true;
      cursor(CROSS);
    }
  }
}

void mouseReleased() {
  if (mouseMode == "DELETE") {
    for (Shape shape : shapes) {
      if (shape.isSelected && shape.isHovered) {
        shapes.remove(shape);
        break;
      }
    }
  }

  if (selected == "SQUARE") {
    shapes.add(new Shape("SQUARE", new PVector(mouseX, mouseY), sideLength));
  } else if (selected == "TRIANGLE") {
    shapes.add(new Shape("TRIANGLE", new PVector(mouseX, mouseY), sideLength));
  } else if (selected == "CIRCLE") {
    shapes.add(new Shape("CIRCLE", new PVector(mouseX, mouseY), sideLength));
  } else if (selected == "TIMELINE") {
    for (Shape shape : shapes) {
      shape.pos1 = shape.frameData.get(time).pos1;
      shape.size = shape.frameData.get(time).size;
      shape.rotation = shape.frameData.get(time).rotation;
    }
  }
  
  for (Shape shape : shapes) {
    //if (shape.isSelected) {  // update keyframes
    //  Keyframe tempFrame = shape.getFrameData();
    //  if(tempFrame.pos1.x != shape.pos1.x || tempFrame.pos1.y != shape.pos1.y || tempFrame.size != shape.size || tempFrame.rotation != shape.rotation){
    //    shape.frameData.set(time, tempFrame);
    //  }
    //}
    
    // make it not unselect in certain cases for more effecient workspace
    if(selected != "TIMELINE" && !timelineButtons.get(3).isHovered && !timelineButtons.get(2).isHovered && !timelineButtons.get(1).isHovered){
      shape.isSelected = false;
    }
    shape.isMovable = false;
    shape.isResizable = false;
    shape.isRotatable = false;
    shape.isTransformable = false;
    cursor(ARROW);
    shape.checkSelect();
  }

  for (Button button : buttons) {
    button.checkSelect();
  }

  for (Button button : timelineButtons) {
    button.checkSelect();
  }

  

  selected = "NONE";
  selectedShape = null;
}

boolean onSquare(float x, float y, float sizex, float sizey) {
  // x, y is center point of square
  return mouseX >= x - sizex/2 && mouseX <= x + sizex/2 && mouseY >= y - sizey/2 && mouseY <= y + sizey/2;
}

boolean onTriangle(PVector p1, PVector p2, PVector p3) {
  PVector point = new PVector(mouseX, mouseY);

  boolean s1 = sign(point, p1, p2) < 0;
  boolean s2 = sign(point, p2, p3) < 0;
  boolean s3 = sign(point, p3, p1) < 0;

  return ((s1 == s2) && (s2 == s3));
}

float sign(PVector p1, PVector p2, PVector p3) {
  return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
}

boolean onCircle(PVector pos, float size) {
  return dist(mouseX, mouseY, pos.x, pos.y) <= size/2;
}
