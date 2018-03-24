import processing.video.*;
import java.util.Arrays;

Movie video;
PImage img,og;
int rowSize, colSize;
int threshholdValue = 125;

int[][] bayer8 = new int[][] {
    { 0, 32,  8, 40,  2, 34, 10, 42},   /* 8x8 Bayer ordered dithering  */
    {48, 16, 56, 24, 50, 18, 58, 26},   /* pattern.  Each input pixel   */
    {12, 44,  4, 36, 14, 46,  6, 38},   /* is scaled to the 0..63 range */
    {60, 28, 52, 20, 62, 30, 54, 22},   /* before looking in this table */
    { 3, 35, 11, 43,  1, 33,  9, 41},   /* to determine the action.     */
    {51, 19, 59, 27, 49, 17, 57, 25},
    {15, 47,  7, 39, 13, 45,  5, 37},
    {63, 31, 55, 23, 61, 29, 53, 21} };

void setup() 
{
  size( 1474, 736, P2D);
  frameRate(30);
  imageMode(CORNER);
  img = loadImage("cat.jpg");
  og = loadImage("cat.jpg");

  rowSize = img.width;
  colSize = img.height;
}

void draw() 
{
  background(255);
  image(og,width/2,0);
  getNextFrame();
  image(img,0,0);
}

void getNextFrame(){
  img = loadImage("cat.jpg");
  int[] qPixel = {0,0};
  int[] luminanceArray = new int[img.pixels.length];
  Arrays.fill(luminanceArray,0);
  loadPixels();
  for(int col = 0; col < colSize; col += 1){
    for(int row = 0; row < rowSize; row += 1){
      
      //////Find current pixel in image matrix 1D array
      int i = row + col*colSize;
      
      //////read color of current pixel
      color pixel = img.pixels[i]; 
      
      //////read error from luminanceArray
      int error = luminanceArray[i];
      
      //////Apply dithering algorithm
      //qPixel = floydSteinber( calculateLuminance(pixel) + error );
      qPixel = bayerDither( calculateLuminance(pixel), row, col);
      bayer8 = cycleBayerArray(bayer8);
      
      //////set pixel color to greyscale quantized value
      img.pixels[i] = color(qPixel[0]);                 
      
      //////distribute error
      luminanceArray = distributeError(luminanceArray, colSize, i, qPixel[1]);                      
    }//end row
  }//end col
  img.updatePixels();
}

/////////////////////////////////////////////////////////////////////
int calculateLuminance(color argb) {
      int a = (argb >> 24) & 0xFF;
      int r = (argb >> 16) & 0xFF;
      int g = (argb >> 8) & 0xFF;
      int b = argb & 0xFF;
      return int (sqrt(r*.241 + g*.691 + b*.068)*15);
}

/////////////////////////////////////////////////////////////////////
int[] floydSteinberg(int pixel) {
  int value = pixel > threshholdValue ? 255 : 0;
  int error = pixel > threshholdValue ? pixel - 255 : pixel ;
  int[] qPix = {value,error};
  return qPix;
}

int[] bayerDither(int pixel,int x, int y) {
  int value = map(pixel,0,255,0,64) > bayer8[x%8][y%8] ? 255 : 0 ;
  int error = 0;
  int[] qPix = {value,error};
  return qPix;
}

int[] bayerRGB(int pixel, int x, int y){
  //todo...
  int[] qPix = {0,0};
  return qPix;
}

////////////////////////////////////////////////////////////////////////
int[] distributeError(int[] pix, int w, int i, int error){
    float fError = error*1.0;
    if( i+1 < pix.length ){ pix[i+1] += int(fError*7/16);}
    if( i+w-1 < pix.length ){pix[i+w-1] += int(fError*3/16); }
    if( i+w < pix.length ){pix[i+w] += int(fError*5/16); }
    if( i+w+1 < pix.length ){pix[i+w+1] += int(fError*1/16); }
   return pix;
}
///////////////////////////////////////////////////////////////////////
int[][] cycleBayerArray( int[][] array){
  for (int i=0;i<array.length;i++){
    array[i] = shiftRight(array[i]);
  }
  return array;
}

public int[] shiftRight(int[] list)
{
   if (list.length < 2) { return list; }
   int last = list[list.length - 1];
   for(int i = list.length - 1; i > 0; i--) {
      list[i] = list[i - 1];
   }
   list[0] = last;
   return list;
}

//////////////////////////////////////////////////////////////////////
void movieEvent(Movie m) { m.read(); }