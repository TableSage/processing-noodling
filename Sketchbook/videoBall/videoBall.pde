import processing.video.*;

int cSize;           // Width of the shape
float xpos, ypos;    // Starting position of shape  

float ns = 0.008;    //NoiseScale

float xspeed = 1.8;  // Speed of the shape
float yspeed = 1.2;  // Speed of the shape

int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom

Movie video;
PImage cFrame;
PVector cCenter;
int vWidth;
int vHeight;
float vScaleX,vScaleY;

void setup() 
{
  size(1280, 720,P2D);
  frameRate(120);
  imageMode(CORNER);
  video = new Movie(this, "Noize.mp4");
  video.loop();
  video.jump(0.01);
  video.jump(random(120));
  
  background(0);

  vWidth = video.width;
  vHeight = video.height;
  vScaleX = width/vWidth;
  vScaleY = height/vHeight;
  xpos = width/2;
  ypos = height/2;
  cSize = width/5;
}

void draw() 
{
  noisePos();
  getNextCrop();
  //roundFrame();
  //tint(255,125);
  image(cFrame,(xpos*vScaleX),(ypos*vScaleY),cFrame.width,cFrame.height);
}

void noisePos(){
  xpos = map( noise( (frameCount + 1000) * ns ),0,1,0,vWidth-cSize);
  ypos = map( noise( (frameCount) * ns ),0,1,0,vHeight-cSize);
  cSize = int(map( noise( (frameCount-1000) * ns ),0,1,width/25,width/3));
  
  //xpos = random (0,vWidth-cSize);
  //ypos = random (0,vHeight-cSize);
}

void getNextCrop(){
  
  cFrame = video.get(int(xpos),int(ypos),cSize,cSize);
  cFrame.resize(int(cSize*vScaleX),0);
  
}

void roundFrame() {
  cCenter = new PVector( cFrame.width/2,cFrame.height/2);
  float cRad = cFrame.width/2;
  for(int y=0;y<cFrame.height;y++){
    for(int x=0;x<cFrame.width;x++){
      if (dist(cCenter.x,cCenter.y,x,y) > cRad){
        cFrame.pixels[(cFrame.width*y)+x] = color(255,255,255,0);
      }
    }
  }
}

void movieEvent(Movie m) { m.read(); }