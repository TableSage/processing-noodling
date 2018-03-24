PVector targetPoint = new PVector(0,0);
TargetZone TZ;

void setup(){
  size(800,450);
  
  //Create TargetZone
  TZ = new TargetZone(new PVector(0,0), new PVector(width,height));
}

void draw() {
  background(255);
  TZ.drawZone2D();
  drawTarget(targetPoint);
}

void keyPressed(){
  if (keyCode == LEFT) {
    TZ.setBounds("left");
  }
  if (keyCode == UP) {
    TZ.setBounds("up");
  }
  if (keyCode == DOWN) {
    TZ.setBounds("down");
  }
  if (keyCode == RIGHT) {
    TZ.setBounds("right");
  }
  
  //Move Target Around
  if (keyCode == ENTER) {
    targetPoint = randomizeTarget(width,height);
  }
  
  //Reset bounds
  if (key == ' ') {
  TZ.resetBounds();
  }
}

/////////////////////////////////////////////////////////////////////////////////

class TargetZone {
  PVector bound1, bound2;
  float qX,halfY,q3X;
  TargetZone(PVector b1, PVector b2){
    bound1 = b1;
    bound2 = b2;
    calculateSections();
  }//end constructor
    
  void calculateSections() {
    //First quarter X
    qX = bound1.x + (abs(bound1.x-bound2.x) / 4);
    //Halfway Y
    halfY = bound1.y + (abs(bound1.y-bound2.y) / 2);
    //Third Quarter X
    q3X = bound1.x + (3 * abs(bound1.x-bound2.x) / 4);
  }//end calculate sections
    
  void setBounds(String dir) {
    switch (dir) {
         case "left":
           print ("left");
           bound2 = new PVector(qX,bound2.y);
           calculateSections();
           break;
         case "up":
           print ("up");
           bound1 = new PVector(qX,bound1.y);
           bound2 = new PVector(q3X,halfY);
           calculateSections();
           break;
         case "down":
           print ("down");
           bound1 = new PVector(qX,halfY);
           bound2 = new PVector(q3X,bound2.y);
           calculateSections();
           break;
         case "right":
           print ("right");
           bound1 = new PVector(q3X,bound1.y);
           calculateSections();
           break;
    }//end switch
  }//end setBounds
  
  void resetBounds(){
    bound1 = new PVector (0,0);
    bound2 = new PVector (width,height);
    calculateSections();
  }
  
  void drawZone2D() {
    rectMode(CORNERS);
    noFill();
    stroke(255,0,0);
    strokeWeight(5);
    
    //Left rect
    rect(bound1.x,bound1.y,qX,bound2.y);
    //Top rect
    rect(qX,bound1.y,q3X,halfY);
    //Bottom rect
    rect(qX,halfY,q3X,bound2.y);
    //Right rect
    rect(q3X,bound1.y,bound2.x,bound2.y);
  }
}//end TargetZone

/////////////////////////////////////////////////////////////////////

//Randomize the target
PVector randomizeTarget(float xRange,float yRange){
  return new PVector(random(0,xRange),random(0,yRange));
}

void drawTarget(PVector point) {
  fill(0,0,0);
  noStroke();
  ellipse(point.x,point.y,10,10);
}