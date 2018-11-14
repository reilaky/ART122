import java.util.Set;
import java.util.HashSet;
import java.util.Arrays;
import processing.video.*;
import peasy.*;

PImage img;
Capture video;
PeasyCam cam;
color[] rawColor;
Centroids centroids;
int k = 4;
int numPixel;
int KmeansItr = 5;
int slidingWindowMin = 5;
int slidingWindowMax = 30;
int colorRange = 5;
float threshold = 0.8;
int[] prev;
int[] currSum;
Rec[] contours;
void setup() {
  
  size(320, 240, P3D);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);
  video = new Capture(this, width, height);
  video.start();
  img = loadImage("1.jpg");
  img.resize(width, height);
  img.loadPixels();
  
  rawColor = new color[width * height];
  numPixel = width * height;
  centroids = new Centroids();

  // read img
  for(int i = 0; i < numPixel; i++){
    float r = red(img.pixels[i]);
    float g = green(img.pixels[i]);
    float b = blue(img.pixels[i]);
    rawColor[i] = color(r, g, b);
  }
  
  // Kmeans to find centroids
  for(int i = 0; i < KmeansItr; i++)
  {
    Centroids temp = Kmeans();
    if(temp.assement < centroids.assement)
    {
      centroids.update(temp);
    }
  }
  centroids.updateK();
  centroids.printCentroids();
  
  prev = new int[k];
  currSum = new int[k];
  for(int i = 0; i < k; i++)
  {
    contours[i] = new Rec();
  }
}

void draw() {
  background(0);
  //visualizeKmeans();
  image(video, 0, 0);
  video.loadPixels();
  colorDetection();
}



void captureEvent(Capture video)
{
  if(video.available()){
    video.read();
  }
}

void visualizeKmeans()
{
  for(int i = 0; i < numPixel; i++)
  {
    stroke(rawColor[i]);
    pushMatrix();
    translate(red(rawColor[i]), green(rawColor[i]), blue(rawColor[i]));
    point(0,0,0);
    popMatrix();
  }
  noStroke();
  lights();
  for(int i = 0; i < k; i++)
  {
    fill(centroids.centroids[i]);
    pushMatrix();
    translate(red(centroids.centroids[i]), green(centroids.centroids[i]), blue(centroids.centroids[i]));
    sphere(20);
    popMatrix();

  }
}
