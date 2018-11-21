import java.util.Set;
import java.util.HashSet;
import java.util.Arrays;
import processing.video.*;
//import peasy.*;

PImage img;
Capture video;
//PImage snapshot;
//PeasyCam cam;
color[] rawColor;
Centroids centroids;
int k = 2;
int numPixel;
int KmeansItr = 3;
int slidingWindowMin = 50;
int slidingWindowMax = 100;
int hueRange = 20;
int range = 100;
float threshold = 0.6;
float[] maxRatio;
int[] prev;
int[] currSum;
float[][] hsv;
Rec[] contours;
boolean p = true;
//PrintWriter output;
void setup() {
  //output = createWriter("positions.txt"); 
  frameRate(10);
  size(320, 240, P3D);
  //cam = new PeasyCam(this, 100);
  //cam.setMinimumDistance(50);
  //cam.setMaximumDistance(5000);
  video = new Capture(this, width, height);
  video.start();
  img = loadImage("1.jpg");
  img.resize(width, height);
  img.loadPixels();
  
  //snapshot = loadImage("1.jpg");
  //snapshot.resize(width, height);
  //snapshot.loadPixels();
  
  rawColor = new color[width * height];
  numPixel = width * height;
  centroids = new Centroids();

  // read img
  for (int i = 0; i < numPixel; i++) {
    float r = red(img.pixels[i]);
    float g = green(img.pixels[i]);
    float b = blue(img.pixels[i]);
    rawColor[i] = color(r, g, b);
  }

  // Kmeans to find centroids
  for (int i = 0; i < KmeansItr; i++)
  {
    Centroids temp = Kmeans();
    if (temp.assement < centroids.assement)
    {
      centroids.update(temp);
    }
  }
  centroids.updateK();
  centroids.printCentroids();
  println("k =", k);
  prev = new int[k];
  currSum = new int[k];
  contours = new Rec[k];
  maxRatio = new float[k];
  hsv = new float[k][3];
  for (int i = 0; i < k; i++)
  {
    contours[i] = new Rec();
    hsv[i][0] = hue(centroids.centroids[i]);
    hsv[i][1] = saturation(centroids.centroids[i]);
    hsv[i][2] = brightness(centroids.centroids[i]);
    println("hsv:", hsv[i][0], hsv[i][1], hsv[i][2]);
  }
  //int m1 = millis();
  ////colorDetection();
  //println("time:", (millis() - m1)/1000.0);
  //print("maxRatio: ");
  //for (int i = 0; i < k; i++)
  //{
  //  print(maxRatio[i] + " ");
  //}
  //println();
}

void draw() {

  background(0);
  //visualizeKmeans();
  //image(snapshot, 0, 0);
  image(video, 0, 0);
  if(millis() % 1 == 0)
  {
    video.loadPixels();
    colorDetection();
  }
  strokeWeight(2);
  noFill();
  for (int i = 0; i < k; i++)
  {
    stroke(centroids.centroids[i]);
    rect(contours[i].x, contours[i].y, contours[i].w, contours[i].h);
    //contours[i].printRec();
  }
  for (int i = 0; i < k; i++)
  {
    stroke(centroids.centroids[i]);
    fill(centroids.centroids[i]);
    rect(i * 10 + width/2, 0 + height/2, 10, 10);
  }
  print("maxRatio: ");
  for (int i = 0; i < k; i++)
  {
    print(maxRatio[i] + " ");
    // clear up maxRatio and contours for later use
    maxRatio[i] = 0;
    contours[i].update(0, 0, 0, 0);
  }
  println();

}

void captureEvent(Capture video)
{
  if (video.available()) {
    video.read();
  }
}

void visualizeKmeans()
{
  for (int i = 0; i < numPixel; i++)
  {
    stroke(rawColor[i]);
    pushMatrix();
    translate(red(rawColor[i]), green(rawColor[i]), blue(rawColor[i]));
    point(0, 0, 0);
    popMatrix();
  }
  noStroke();
  lights();
  for (int i = 0; i < k; i++)
  {
    fill(centroids.centroids[i]);
    pushMatrix();
    translate(red(centroids.centroids[i]), green(centroids.centroids[i]), blue(centroids.centroids[i]));
    sphere(20);
    popMatrix();
  }
}
