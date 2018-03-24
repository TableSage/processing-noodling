import processing.video.*;

Movie video;
PImage  cFrame;
float   vFrameRate = 30.0;
int     cRow = 0;
int     rowSize = 30;
float   playHead = 0.0;
int     vWidth;
int     vHeight;
float   vScaleX,vScaleY;

void setup() 
{
  size( 1280, 720, P2D);
  frameRate(1);
  imageMode(CORNER);
  video = new Movie( this, "Noize.mp4");
  video.play();
  video.jump(0);
  video.pause();
  
  vWidth  = video.width;
  vHeight = video.height;
  vScaleX = width/vWidth;
  vScaleY = height/vHeight;
}

void draw() 
{
  fill(0);
  getNextFrame();
}

void getNextFrame(){
  playHead = frameCount; 

  for(int row = 0; row < rowSize*20; row += rowSize){
    cFrame = video.get( 0, row, width, rowSize);
    //cFrame.resize(int(vWidth*vScaleX),0);
    image( cFrame, 0, row, width, rowSize);
    
    playHead += 1;
    video.play();
    video.jump(playHead);
    video.pause();
    
  }//end row
}

void movieEvent(Movie m) { m.read(); }