ControlP5 cp5;

int padding = 50;
Chart histogramColor, histogramGray;
Toggle histogramToggle;
Textfield addSubField, multiplyField, brightnessField, thresholdField;

void gui(){
  int switchWidth = 100, switchHeight = 40, 
  histogramWidth = width - 3*padding - maxImgWidth, histogramHeight = maxImgHeight - 150,
  buttonHeight = 60, buttonPadding = 10;
  PFont font = createFont("Arial",10,true);
  String[] tabNames = {"default", "filters", "normalization", "binarization"};
  String[] tabLabels = {"Point transformations", "Filters", "Normalization", "Binarization"};
  String[][] buttonNames = {{"add_sub", "multiply", "brightness_level", "grayscale_avarage", "grayscale_luminosity"},
                            {"smoothing","median","vertical_edges","horizontal_edges","sharpening","blur",/*"custom_mask"*/},
                            {"expansion","equalization"},
                            {"user_threshold","percent_black_selection","mean_iterative_selection"/*,"entropy_selection","minimum_error","fuzzy_minimum_error"*/}};
  
  cp5 = new ControlP5(this);
  
  //tabs
  for(int i = 0; i<tabNames.length;i++){
    cp5.getTab(tabNames[i])
       .setLabel(tabLabels[i])
       ;
       
    //buttons
    int buttonWidth = (width-2*padding)/buttonNames[i].length-2*buttonPadding;
    for(int j = 0; j<buttonNames[i].length;j++){
      cp5.addButton(buttonNames[i][j])
         .setPosition(padding+buttonPadding+j*(buttonWidth+2*buttonPadding),padding)
         .setSize(buttonWidth,buttonHeight)
         .setFont(font)
         .moveTo(tabNames[i])
         ;
    }
  }
  
  cp5.addButton("original_image")
     .setPosition(padding+buttonPadding,padding+2*buttonPadding+buttonHeight)
     .setSize(200,buttonHeight)
     .setFont(font)
     .moveTo("global")
     ;
     
  addSubField = cp5.addTextfield("addValue")
     .setPosition(cp5.getController("add_sub").getPosition())
     .setSize(cp5.getController("add_sub").getWidth(),cp5.getController("add_sub").getHeight())
     .setFont(font)
     .moveTo("default")
     .setVisible(false)
     ;
     
  multiplyField = cp5.addTextfield("multiplyValue")
     .setPosition(cp5.getController("multiply").getPosition())
     .setSize(cp5.getController("multiply").getWidth(),cp5.getController("multiply").getHeight())
     .setFont(font)
     .moveTo("default")
     .setVisible(false)
     ;
     
  brightnessField = cp5.addTextfield("brightnessValue")
     .setPosition(cp5.getController("brightness_level").getPosition())
     .setSize(cp5.getController("brightness_level").getWidth(),cp5.getController("brightness_level").getHeight())
     .setFont(font)
     .moveTo("default")
     .setVisible(false)
     ;
     
  thresholdField = cp5.addTextfield("thresholdValue")
     .setPosition(cp5.getController("user_threshold").getPosition())
     .setSize(cp5.getController("user_threshold").getWidth(),cp5.getController("user_threshold").getHeight())
     .setFont(font)
     .moveTo("binarization")
     .setVisible(false)
     ;
     
    //histograms with color/gray toggle
  histogramToggle = cp5.addToggle("histogramMode")
     .setSize(switchWidth,switchHeight)
     .setPosition((width - maxImgWidth - 2*padding - switchWidth/2)/2,height-padding-histogramHeight-switchHeight-30)
     .setMode(ControlP5.SWITCH)
     .setLabel("Color")
     .moveTo("global")
     ;
     
 histogramColor = cp5.addChart("histogramColor")
     .setPosition(padding,height-padding-histogramHeight)
     .setSize(histogramWidth,histogramHeight)
     .setView(Chart.BAR)
     .addDataSet("red")
     .setColors("red", color(255,0,0),color(255,0,0))
     .addDataSet("green")
     .setColors("green", color(0,255,0),color(0,255,0))
     .addDataSet("blue")
     .setColors("blue", color(0,0,255),color(0,0,255))
     .setColorBackground(color(190))
     .moveTo("global")
     ;
     
 histogramGray = cp5.addChart("histogramGray")
     .setPosition(padding,height-padding-histogramHeight)
     .setSize(histogramWidth,histogramHeight)
     .setView(Chart.BAR)
     .addDataSet("gray")
     .setColors("gray", color(0),color(0))
     .setColorBackground(color(190))
     .setVisible(false)
     .moveTo("global")
     ;
}

void updateHistograms(){
  if(histograms!=null){
    histogramColor.setRange(0,max(max(histograms[0]),max(histograms[1]),max(histograms[2])))
    .setData("red", histograms[0])
    .setData("green", histograms[1])
    .setData("blue", histograms[2]);
    histogramGray.setRange(0,max(histograms[3]))
    .setData("gray", histograms[3]);
  }
}
