//red, green, blue, gray avarage
void calculateHistograms(PImage img) {
  histograms = new float[4][256/binWidth];

  for (int i = 0; i < img.pixels.length; i++) {
    if(((img.pixels[i] >> 24) & 0xFF )!= 0){
        histograms[0][((img.pixels[i] >> 16) & 0xFF)/binWidth]++;      // Red channel
        histograms[1][((img.pixels[i] >> 8) & 0xFF)/binWidth]++;       // Green channel
        histograms[2][((img.pixels[i]) & 0xFF)/binWidth]++;            // Blue channel
        histograms[3][(grayAvarage(img.pixels[i]) & 0xFF)/binWidth]++; // Gray scale
      }
    }
}

PImage histogramExpansionFilter(PImage img) {

  int minRed = 0, maxRed = 255, minGreen = 0, maxGreen = 255, minBlue = 0, maxBlue=255;
  while (histograms[0][minRed] == 0 && minRed < 255) {
    minRed++;
  }
  while (histograms[0][maxRed] == 0 && maxRed > 0) {
    maxRed--;
  }
  while (histograms[1][minGreen] == 0 && minGreen < 255) {
    minGreen++;
  }
  while (histograms[1][maxGreen] == 0 && maxGreen > 0) {
    maxGreen--;
  }
  while (histograms[2][minBlue] == 0 && minBlue < 255) {
    minBlue++;
  }
  while (histograms[2][maxBlue] == 0 && maxBlue > 0) {
    maxBlue--;
  }

  PImage returnImg = createImage(img.width, img.height, RGB);

  for (int i = 0; i < img.pixels.length; i++) {
    // Map the pixel value from the original range to the expanded range
    int expandedRed = int(map((img.pixels[i] >> 16) & 0xFF, minRed, maxRed, 0, 255));
    int expandedGreen = int(map((img.pixels[i] >> 8) & 0xFF, minGreen, maxGreen, 0, 255));
    int expandedBlue = int(map(img.pixels[i] & 0xFF, minBlue, maxBlue, 0, 255));
    
    returnImg.pixels[i] = color(expandedRed,expandedGreen,expandedBlue,(img.pixels[i] >> 24) & 0xFF);
  }

  return returnImg;
}

PImage histogramEqualizationFilter(PImage img) {
  int[] redCDF = calculateCDF(histograms[0]);
  int[] greenCDF = calculateCDF(histograms[1]);
  int[] blueCDF = calculateCDF(histograms[2]);
  

  int minRed = 0, maxRed = 255, minGreen = 0, maxGreen = 255, minBlue = 0, maxBlue=255;
  while (histograms[0][minRed] == 0 && minRed < 255) {
    minRed++;
  }
  while (histograms[0][maxRed] == 0 && maxRed > 0) {
    maxRed--;
  }
  while (histograms[1][minGreen] == 0 && minGreen < 255) {
    minGreen++;
  }
  while (histograms[1][maxGreen] == 0 && maxGreen > 0) {
    maxGreen--;
  }
  while (histograms[2][minBlue] == 0 && minBlue < 255) {
    minBlue++;
  }
  while (histograms[2][maxBlue] == 0 && maxBlue > 0) {
    maxBlue--;
  }

  PImage returnImg = createImage(img.width, img.height, RGB);

  for (int i = 0; i < img.pixels.length; i++) {
    int equalizedRed = int(map(redCDF[(img.pixels[i] >> 16) & 0xFF], redCDF[minRed], redCDF[maxRed], 0, 255));
    int equalizedGreen = int(map(greenCDF[(img.pixels[i] >> 8) & 0xFF], greenCDF[minGreen], greenCDF[maxGreen], 0, 255));
    int equalizedBlue = int(map(blueCDF[img.pixels[i] & 0xFF], blueCDF[minBlue], blueCDF[maxBlue], 0, 255));

    returnImg.pixels[i] = color(equalizedRed,equalizedGreen,equalizedBlue,(img.pixels[i] >> 24) & 0xFF);
  }
  return returnImg;
}

int[] calculateCDF(float[] histogram) {
  int[] cdf = new int[256];
  cdf[0] = int(histogram[0]);

  for (int i = 1; i < histogram.length; i++) {
    cdf[i] = cdf[i - 1] + int(histogram[i]);
  }
  return cdf;
}
