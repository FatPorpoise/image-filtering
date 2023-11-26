PImage originalImg, filteredImg, resizedImg;
int imgX=0, imgY=0, maxImgWidth = 500, maxImgHeight = 500, binWidth = 1;
float[][] histograms;

void setup(){
  size(1200,800);
  surface.setLocation(displayWidth/2 - width/2, displayHeight/2 - height/2);
  //noFill();
  gui();
}

void draw(){
  background(204);
  if(resizedImg!=null)
  image(resizedImg,imgX,imgY);
  //rect(padding, padding,width-padding*2,height-padding*2);
  //rect(width-padding-maxImgWidth,height-padding-maxImgHeight,maxImgWidth,maxImgHeight);
  //rect(padding,padding,width-2*padding,height -padding*2-maxImgHeight);
}

PImage resizeImg(PImage img){
  PImage returnImg = img.copy();
  if(returnImg.width>returnImg.height){
    returnImg.resize(maxImgWidth,0);
    if(returnImg.height>maxImgHeight)
      returnImg.resize(0,maxImgHeight);
  }
  else{
    returnImg.resize(0,maxImgHeight);
    if(returnImg.width>maxImgWidth)
      returnImg.resize(maxImgWidth,0);
  }
  return returnImg;
}
