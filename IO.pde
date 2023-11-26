void outputFileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  }
  else if(validFile(selection.getName())){
    println("User selected " + selection.getAbsolutePath());
    if(!selection.exists()){
      try {
          // Create a new file
          boolean fileCreated = selection.createNewFile();
          if (fileCreated) {
              println("File created: " + selection.getAbsolutePath());
          } else {
              println("Failed to create the file.");
              JOptionPane.showMessageDialog(null, "Failed to create the file", "Error", JOptionPane.ERROR_MESSAGE);
          }
      } catch (IOException e) {
          println("Error creating file: " + e.getMessage());
          JOptionPane.showMessageDialog(null, "Error creating file: " + e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
      }
    }
    if(filteredImg!=null)
      filteredImg.save(selection.getAbsolutePath());
    else{
      println("No image loaded");
      JOptionPane.showMessageDialog(null, "No image loaded", "Warning", JOptionPane.INFORMATION_MESSAGE);
    }
  }else{
      println("Unsupported file format");
      JOptionPane.showMessageDialog(null, "Unsupported file format", "Warning", JOptionPane.INFORMATION_MESSAGE);
  }
}


void inputFileSelected(File selection) {
  if (selection == null) {
    println("No file selected.");
  }else{
    println("User selected " + selection.getAbsolutePath());
    if(validFile(selection.getName())){
      noLoop();
      originalImg = loadImage(selection.getAbsolutePath());
      filteredImg = originalImg.copy();
      resizedImg = resizeImg(filteredImg);
      calculateHistograms(filteredImg);
      updateHistograms();
      imgX = width - padding - maxImgWidth + (maxImgWidth-resizedImg.width)/2;
      imgY = height - padding - maxImgHeight + (maxImgHeight-resizedImg.height)/2;
      loop();
    }else{
      println("Unsupported file format");
      JOptionPane.showMessageDialog(null, "Unsupported file format", "Error", JOptionPane.INFORMATION_MESSAGE);
    }
  }
}


boolean validFile(String fileName) {
return (
   fileName.endsWith(".jpg") ||
   fileName.endsWith(".jpeg") ||
   fileName.endsWith(".png")) ;
}
