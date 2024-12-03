//import g4p_controls.*;

int uiSize;
int sideLength;
int time;
int maxTime;
int leftSide;
int rightSide;
int ySide;
int sizeSide;
float timelineX;

Shape selectedShape;
String selected;
ArrayList<Shape> shapes = new ArrayList<Shape>();

void setup(){
  frameRate(60);
  background(255);
  smooth(2);
  size(1200, 700);
  selected = "NONE";
  selectedShape = null;
  
  uiSize = 200;
  sideLength = 40;
  time = 0;
  maxTime = 500;
  leftSide = uiSize + 20;
  rightSide = width - 20;
  ySide = height - 150;
  sizeSide = 20;
  timelineX = leftSide;
}

void draw(){
  background(255);
  
  
  drawUI();
  drawTimeline();
  drawObjects();
}

void drawObjects(){
  for(Shape shape: shapes){
    shape.checkHover();
  }
  
  for(Shape shape: shapes){
    if(shape.controlButtons != null){
      for(ControlButton controlButton: shape.controlButtons){
        if(shape.isSelected){
          controlButton.drawMe();
        }
        controlButton.update();
      }
    }
  }
}

void drawUI(){
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
    
  // draw shapes
  for(Shape shape: shapes){
    shape.drawMe();
  }
  
  // drawing selected
  if(selected == "SQUARE"){
    fill(255);
    rect(mouseX - 20, mouseY - 20, 40, 40);
  }
  
  if(selected == "TRIANGLE"){
    fill(255);
    triangle(mouseX - sideLength/2, mouseY + sideLength/(2*sqrt(3)), mouseX + sideLength/2, mouseY + sideLength/(2*sqrt(3)), mouseX, mouseY - sideLength/(sqrt(3)));
  }
  
  if(selected == "CIRCLE"){
    fill(255);
    circle(mouseX, mouseY, 40);
  }
  
  if(selected == "TIMELINE"){
   time = constrain(int(map(mouseX, leftSide, rightSide, 0, maxTime)), 0, maxTime);
   timelineX = constrain(mouseX, leftSide, rightSide);
  }
  
  for(Shape shape: shapes){
    if(shape.isMovable){
      if(shape.type == "SQUARE"){
        shape.pos1 = new PVector(mouseX, mouseY);
      }
      else if(shape.type == "TRIANGLE"){
        shape.pos1 = new PVector(mouseX - sideLength/2, mouseY + sideLength/(2*sqrt(3)));
        shape.pos2 = new PVector(mouseX + sideLength/2, mouseY + sideLength/(2*sqrt(3)));
        shape.pos3 = new PVector(mouseX, mouseY - sideLength/(sqrt(3)));
    
      }
      else if(shape.type == "CIRCLE"){
        shape.pos1 = new PVector(mouseX, mouseY);
      }
    }
  }

  // create timeline text
  fill(0);
  textAlign(CENTER);
  textSize(18);
  text(time, timelineX, ySide - 25);
 
  if(timelineX >= leftSide + leftSide*0.1){
    text("0", leftSide, ySide - 25);
  }
  if(timelineX <= rightSide - (rightSide - leftSide)*0.1){
    text(maxTime, rightSide, ySide - 25);
  }

}

void drawTimeline(){
  strokeWeight(2);
  stroke(0);
  
  line(leftSide, ySide, rightSide, ySide);
  line(leftSide, ySide - sizeSide, leftSide, ySide + sizeSide);
  line(rightSide, ySide - sizeSide, rightSide, ySide + sizeSide);
  
  strokeWeight(2);
  rect(timelineX - 5, ySide - 15, 10, 30);
}

void mousePressed(){
  if(selected == "NONE"){
    if(onSquare(uiSize/2, 100, 40, 40)){
      selected = "SQUARE";
    }
    else if(onTriangle(new PVector(uiSize/2 - sideLength/2, 200), new PVector(uiSize/2 + sideLength/2, 200), new PVector(uiSize/2, 200 - (sqrt(3)/2)*sideLength))) {
      selected = "TRIANGLE";
    }
    else if(onCircle(new PVector(uiSize/2, 260), 40)){
      selected = "CIRCLE";
    }
    else if(onSquare(timelineX, ySide, 10, 30)){
      selected = "TIMELINE";
    }
    
  }
  
  for(Shape shape: shapes){
    if(shape.isSelected && shape.isHovered){
      shape.isMovable = true; 
      cursor(MOVE);
    }
  }
}

void mouseReleased(){
  if(selected == "SQUARE"){
    shapes.add(new Shape("SQUARE", new PVector(mouseX, mouseY), 40));
  }
  else if(selected == "TRIANGLE"){
    shapes.add(new Shape("TRIANGLE", new PVector(mouseX - sideLength/2, mouseY + sideLength/(2*sqrt(3))), new PVector(mouseX + sideLength/2, mouseY + sideLength/(2*sqrt(3))), new PVector(mouseX, mouseY - sideLength/sqrt(3)), sideLength));
  }
  else if(selected == "CIRCLE"){
    shapes.add(new Shape("CIRCLE", new PVector(mouseX, mouseY), 40));  
  }
  else if(selected == "TIMELINE"){

  }
  
  for(Shape shape: shapes){
    shape.isSelected = false;
    shape.isMovable = false;
    cursor(ARROW);
    shape.checkSelect();
  }
  
  selected = "NONE";
  selectedShape = null;
}

boolean onSquare(float x, float y, int sizex, int sizey){
  // x, y is center point of square
  return mouseX >= x - sizex/2 && mouseX <= x + sizex/2 && mouseY >= y - sizey/2 && mouseY <= y + sizey/2;
}

boolean onTriangle(PVector p1, PVector p2, PVector p3) {
  PVector point = new PVector(mouseX, mouseY);
  
  boolean s1 = sign(point, p1, p2) < 0;
  boolean s2 = sign(point, p2, p3) < 0;
  boolean s3 = sign(point, p3, p1) < 0;
  
  boolean isInside = (s1 == s2) && (s2 == s3);
  return isInside;
}

float sign(PVector p1, PVector p2, PVector p3) {
  return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
}

boolean onCircle(PVector pos, int size){
  return dist(mouseX, mouseY, pos.x, pos.y) <= size/2;
}
