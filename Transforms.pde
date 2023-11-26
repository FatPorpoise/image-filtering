interface Mask {
    color apply(color pixel);
}

interface MaskIntParam {
    color apply(color pixel, int value);
}

color addSub(color c, int value){
  int[] channels = {(c >> 16) & 0xFF,(c >> 8) & 0xFF,c & 0xFF};
  for(int i = 0; i<3; i++){
    if(channels[i] + value>=255)
      channels[i]=255;
    else if(channels[i] + value<=0)
      channels[i]=0;
    else
      channels[i]=channels[i] + value;
  }
  return color(channels[0], channels[1], channels[2], (c >> 24) & 0xFF);
}

color multiply(color c, float value){
  int[] channels = {(c >> 16) & 0xFF,(c >> 8) & 0xFF,c & 0xFF};
  for(int i = 0; i<3; i++){
    if(channels[i] * value>=255)
      channels[i]=255;
    else if(channels[i] * value<=0)
      channels[i]=0;
    else
      channels[i]=round(channels[i] * value);
  }
  return color(channels[0], channels[1], channels[2], (c >> 24) & 0xFF);
}

color brightLvl(color c, int level){
  return addSub(c,51*level);
}

color grayAvarage(color c){
  return color((((c >> 16) & 0xFF) + ((c >> 8) & 0xFF) + (c & 0xFF))/3, (c >> 24) & 0xFF);
}

color grayLuminosity(color c){
  return color(round((((c >> 16) & 0xFF)*0.2126 + ((c >> 8) & 0xFF)*0.7152 + (c & 0xFF)*0.0722)), (c >> 24) & 0xFF);
}

color convolution(color[][] pixelMatrix, float[][] kernel){
  int i,j,len = pixelMatrix.length;
  float r=0,g=0,b=0,a=(pixelMatrix[len/2][len/2] >> 24) & 0xFF;
  for(i = 0; i<len; i++){
    for(j = 0; j<len;j++){
      //a += ((pixelMatrix[i][j] >> 24) & 0xFF) * kernel[i][j];
      r += ((pixelMatrix[i][j] >> 16) & 0xFF) * kernel[i][j];
      g += ((pixelMatrix[i][j] >> 8) & 0xFF) * kernel[i][j];
      b += (pixelMatrix[i][j] & 0xFF) * kernel[i][j];
    }
  }
  return color(int(r),int(g),int(b),int(a));
}

color medianFilter(color[][] pixelMatrix){
  int i,j,len = pixelMatrix.length;
  int[] a = new int[len*len];
  int[] r = new int[len*len];
  int[] g = new int[len*len];
  int[] b = new int[len*len];
  for(i = 0; i<len; i++){
    for(j = 0; j<len;j++){
      a[i*len+j] = ((pixelMatrix[i][j] >> 24) & 0xFF);
      r[i*len+j] = ((pixelMatrix[i][j] >> 16) & 0xFF);
      g[i*len+j] = ((pixelMatrix[i][j] >> 8) & 0xFF);
      b[i*len+j] = (pixelMatrix[i][j] & 0xFF);
    }
  }
  return color(medianOfArray(r),medianOfArray(g),medianOfArray(b),medianOfArray(a));
}
int medianOfArray(int[] intArray){
  Arrays.sort(intArray);
  if (intArray.length % 2 == 0)
      return (intArray[intArray.length/2] + intArray[intArray.length/2 - 1])/2;
  else
      return intArray[intArray.length/2];
}

color binarizationThreshold(color c, int threshold){
    int binaryValue = ((grayAvarage(c)&0xFF) > threshold) ? color(255) : color(0);
    return color(binaryValue);
}

PImage filter(PImage img, Mask mask) {
  PImage result = createImage(img.width, img.height, ARGB);
  for (int i = 0; i < img.pixels.length; i++) {
      result.pixels[i] = mask.apply(img.pixels[i]);
  }
  return result;
}

PImage filter(PImage img, MaskIntParam mask, int value) {
  PImage result = createImage(img.width, img.height, ARGB);
  for (int i = 0; i < img.pixels.length; i++) {
      result.pixels[i] = mask.apply(img.pixels[i], value);
  }
  return result;
}

PImage filter(PImage img, float value) {
  PImage result = createImage(img.width, img.height, ARGB);
  for (int i = 0; i < img.pixels.length; i++) {
    result.pixels[i] = multiply(img.pixels[i], value);
  }
  return result;
}

PImage filter(PImage img, float[][] kernel) {
  PImage result = createImage(img.width, img.height, ARGB);
  int x, y, i, j, xChecked, yChecked, halfSide=kernel.length/2;
  color[][] pixelsMatrix = new color[kernel.length][kernel.length];
  for (y = 0; y < img.height; y++) {
    for(x = 0; x< img.width; x++){
      for(i = -halfSide;i<=halfSide;i++){
        for(j = -halfSide;j<=halfSide;j++){
          if(y+i<0 || y+i>=img.height) yChecked = y-i;
          else yChecked = y+i;
          if(x+j<0 || x+j>=img.width) xChecked = x-j;
          else xChecked = x+j;
          if(yChecked*img.width+xChecked>=img.pixels.length)
          println(xChecked,yChecked,img.width,img.height);
          pixelsMatrix[i+halfSide][j+halfSide] = img.pixels[yChecked*img.width+xChecked];
        }
      }
      result.pixels[y*img.width+x] = convolution(pixelsMatrix, kernel);
    }
  }
  return result;
}

PImage filter(PImage img, int MatrixSize) {
  PImage result = createImage(img.width, img.height, ARGB);
  int x, y, i, j, xChecked, yChecked, halfSide=MatrixSize/2;
  color[][] pixelsMatrix = new color[MatrixSize][MatrixSize];
  for (y = 0; y < img.height; y++) {
    for(x = 0; x< img.width; x++){
      for(i = -halfSide;i<=halfSide;i++){
        for(j = -halfSide;j<=halfSide;j++){
          if(y+i<0 || y+i>=img.height) yChecked = y-i;
          else yChecked = y+i;
          if(x+j<0 || x+j>=img.width) xChecked = x-j;
          else xChecked = x+j;
          if(yChecked*img.width+xChecked>=img.pixels.length)
          println(xChecked,yChecked,img.width,img.height);
          pixelsMatrix[i+halfSide][j+halfSide] = img.pixels[yChecked*img.width+xChecked];
        }
      }
      result.pixels[y*img.width+x] = medianFilter(pixelsMatrix);
    }
  }
  return result;
}

PImage percentBlackFilter(PImage img, float percent) {
  int threshold = 255,
  blackPixels = 0;
  while(blackPixels<img.pixels.length*percent || threshold==0){
    blackPixels+=histograms[3][threshold--];
  }
  return filter(img,this::binarizationThreshold,threshold);
}

PImage meanIterativeFilter(PImage img) {
  PImage result = filter(filteredImg, this::grayLuminosity);
  float mean = calculateMean(img.pixels);
  float threshold = mean * 0.8; // Adjust this multiplier as needed
  
  for (int i = 0; i < result.pixels.length; i++) {
    
    // Apply the filter
    if ((result.pixels[i] & 0xFF) > threshold) {
      result.pixels[i] = color(255); // Set pixel to white
    } else {
      result.pixels[i] = color(0);   // Set pixel to black
    }
  }
  return result;
}

float calculateMean(int[] pixels) {
  float sum = 0;
  for (int pixel : pixels) {
    int pixelColor = pixel;
    int red = (pixelColor >> 16) & 0xFF;
    int green = (pixelColor >> 8) & 0xFF;
    int blue = pixelColor & 0xFF;
    sum += (0.299 * red + 0.587 * green + 0.114 * blue);
  }
  return sum / pixels.length;
}
