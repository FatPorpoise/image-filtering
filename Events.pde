void keyPressed() {
  if (keyCode == 113) 
    selectOutput("Select a file to write to:", "outputFileSelected");
  
  else if (keyCode == 112) 
    selectInput("Select a file to read from:", "inputFileSelected");
}

void histogramMode(boolean ifGray) {
  if(ifGray==true) {
    histogramToggle.setLabel("Grayscale");
    histogramColor.setVisible(false);
    histogramGray.setVisible(true);
  } else {
    histogramToggle.setLabel("Color");
    histogramGray.setVisible(false);
    histogramColor.setVisible(true);
  }
}

//buttons

void original_image(){
  if(originalImg!=null){
    filteredImg = originalImg.copy();
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

void add_sub(){
  addSubField.setVisible(true);
  addSubField.setFocus(true);
}

void multiply(){
  multiplyField.setVisible(true);
  multiplyField.setFocus(true);
}

void brightness_level(){
  brightnessField.setVisible(true);
  brightnessField.setFocus(true);
}

void grayscale_avarage(){
  if(filteredImg!=null){
    filteredImg = filter(filteredImg, this::grayAvarage);
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

void grayscale_luminosity(){
  if(filteredImg!=null){
    filteredImg = filter(filteredImg, this::grayLuminosity);
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

void smoothing(){
  if(filteredImg!=null){
    filteredImg = filter(filteredImg, new float[][]{{1f/9,1f/9,1f/9},{1f/9,1f/9,1f/9},{1f/9,1f/9,1f/9}});
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

void median(){
  if(filteredImg!=null){
    filteredImg = filter(filteredImg,5);
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

void vertical_edges(){
  if(filteredImg!=null){
    filteredImg = filter(filteredImg, new float[][]{{-1f,0f,1f},{-2f,0f,2f},{-1f,0f,1f}});
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}
void horizontal_edges(){
  if(filteredImg!=null){
    filteredImg = filter(filteredImg, new float[][]{{-1f,-2f,-1f},{0f,0f,0f},{1f,2f,1f}});
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

void sharpening(){
  if(filteredImg!=null){
    filteredImg = filter(filteredImg, new float[][]{{-1f,-1f,-1f},{-1f,9f,-1f},{-1f,-1f,-1f}});
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

void blur(){
  if(filteredImg!=null){
    filteredImg = filter(filteredImg, new float[][]{{1f/16,2f/16,1f/16},{2f/16,4f/16,2f/16},{1f/16,2f/16,1f/16}});
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

void expansion(){
  if(filteredImg!=null){
    filteredImg = histogramExpansionFilter(filteredImg);
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

void equalization(){
  if(filteredImg!=null){
    filteredImg = histogramEqualizationFilter(filteredImg);
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

void user_threshold(){
  if(filteredImg!=null){
    thresholdField.setVisible(true);
    thresholdField.setFocus(true);
  }
}

void percent_black_selection(){
  if(filteredImg!=null){
    filteredImg = percentBlackFilter(filteredImg,0.5);
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

void mean_iterative_selection(){
  if(filteredImg!=null){
    filteredImg = meanIterativeFilter(filteredImg);
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
}

//input fields

void addValue(String value){
  if(isInteger(value) && filteredImg!=null){
    filteredImg = filter(filteredImg, this::addSub, int(value));
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
  addSubField.setFocus(false);
  addSubField.setVisible(false);
}

void multiplyValue(String value){
  if(isPosFloat(value) && filteredImg!=null){
    filteredImg = filter(filteredImg, float(value));
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
  multiplyField.setFocus(false);
  multiplyField.setVisible(false);
}


void brightnessValue(String value){
  if(isInteger(value) && filteredImg!=null){
    filteredImg = filter(filteredImg, this::brightLvl, int(value));
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
  brightnessField.setFocus(false);
  brightnessField.setVisible(false);
}

void thresholdValue(String value){
  if(isInteger(value) && filteredImg!=null){
    filteredImg = filter(filteredImg, this::binarizationThreshold, constrain(int(value),0,255));
    resizedImg = resizeImg(filteredImg);
    calculateHistograms(filteredImg);
    updateHistograms();
  }
  thresholdField.setFocus(false);
  thresholdField.setVisible(false);
}

boolean isInteger(String s) {
  try {
    Integer.parseInt(s);
    return true;
  } catch (NumberFormatException e) {
    return false;
  }
}

boolean isPosFloat(String s) {
  try {
    if(Float.parseFloat(s)>=0)
      return true;
    else
      return false;
  } catch (NumberFormatException e) {
    return false;
  }
}
