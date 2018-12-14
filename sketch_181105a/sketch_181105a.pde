import java.util.Set;
import java.util.HashSet;
import java.util.Arrays;
import gohai.glvideo.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.Process;
import java.lang.reflect.Field;
import gab.opencv.*;
import java.awt.Rectangle;

String kill_pid;
boolean stop = true;
int count = 0;

OpenCV opencv;
ArrayList<Contour> Contours;
PImage img;
GLCapture video;
String initPipan = "/usr/bin/python /home/pi/Documents/ProcessingProject/ART122-master_opencv/sketch_opencv/init_pipan.py";
PImage snapshot;
//PeasyCam cam;


float output_pan = 150;
float output_tilt = 150;

color[] rawColor;
Centroids centroids;
int k = 4;
int numPixel;
int KmeansItr = 3;
int slidingWindowMin = 50;
int slidingWindowMax = 100;
int hueRange = 8;
int range = 200;
float threshold = 0.6;
float[] maxRatio;
int[] prev;
int[] currSum;
int[][] hsv;
Rec[] contours;
boolean p = true;
color[] recCol = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)};
//PrintWriter output;
void setup() {
  //output = createWriter("positions.txt"); 
  frameRate(60);
  size(160, 120, P2D);
  
  // initialize pipan
  runPython(initPipan);
  println(initPipan);
  
  // create new video stream
  String[] devices = GLCapture.list();
  println("Devices:");
  printArray(devices);
  if (0 < devices.length) {
    String[] configs = GLCapture.configs(devices[0]);
    println("Configs:");
    printArray(configs);
  }
  video = new GLCapture(this, devices[0], 160, 120, 25);
  video.start();
  opencv = new OpenCV(this, width, height);
  Contours = new ArrayList<Contour>();
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
  int m1 = millis();
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
  println("time:", (millis() - m1)/1000.0);
  println("k =", k);
  prev = new int[k];
  currSum = new int[k];
  contours = new Rec[k];
  maxRatio = new float[k];
  hsv = new int[k][3];
  for (int i = 0; i < k; i++)
  {
    contours[i] = new Rec();
    hsv[i][0] = int(map(hue(centroids.centroids[i]), 0, 255, 0, 180));
    hsv[i][1] = int(map(saturation(centroids.centroids[i]), 0, 255, 0, 180));
    hsv[i][2] = int(map(brightness(centroids.centroids[i]), 0, 255, 0, 180));
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
  if (video.available()) {
    video.read();
  }
  //visualizeKmeans();
  //image(snapshot, 0, 0);
  //if(millis() % 1 == 0)
  //{
    //video.loadPixels();
    //colorDetection();
  //}
  opencv.loadImage(video);
  // Tell OpenCV to use color information
  opencv.useColor();
  snapshot = opencv.getSnapshot();
  
  opencv.useColor(HSB);
  opencv.setGray(opencv.getH().clone());
  
  opencv.inRange(int(hsv[0][0] - hueRange), int(hsv[0][0] + hueRange));
  Contours = opencv.findContours(true, true);
  translate(width, height);
  rotate(PI);
  image(snapshot, 0, 0);
  if (Contours.size() > 0) {
    // <9> Get the first contour, which will be the largest one
    Contour biggestContour = Contours.get(0);
    
    // <10> Find the bounding box of the largest contour,
    //      and hence our object.
    Rectangle r = biggestContour.getBoundingBox();
    
    // <11> Draw the bounding box of our object
    noFill(); 
    strokeWeight(2); 
    stroke(255, 0, 0);
    rect(r.x, r.y, r.width, r.height);
    
    // rotata camera via pipan
      output_pan = output_pan - (width/2 - (r.x + r.width/2)) * 0.02;
      if(output_pan > 170)
      {
        output_pan = 170;
      }
      else if(output_pan < 110)
      {
        output_pan = 110;
      }
      
      output_tilt = output_tilt + (height/2 - (r.y + r.height/2)) * 0.02;
      if(output_tilt > 180)
      {
        output_tilt = 180;
      }
      else if(output_tilt < 90)
      {
        output_tilt = 90;
      }
      String term = "/usr/bin/python /home/pi/Documents/ProcessingProject/ART122-master_opencv/sketch_opencv/rotate_camera.py " 
                  + Float.toString(output_pan) + " " + Float.toString(output_tilt);
      println(term);
      runPython(term); 
    
  }

  
  //// visualize video stream and result
  //strokeWeight(2);
  //noFill();
  
  ////translate(width, height);
  ////rotate(PI);
  //image(video, 0, 0);
  //for (int i = 0; i < k; i++)
  //{
  //  stroke(recCol[i]);
  //  rect(contours[i].x, contours[i].y, contours[i].w, contours[i].h);
  //  contours[i].printRec();
  //}
  //for (int i = 0; i < k; i++)
  //{
  //  stroke(centroids.centroids[i]);
  //  fill(centroids.centroids[i]);
  //  rect(i * 10 + width/2, 0 + height/2, 10, 10);
  //}
  //print("maxRatio: ");
  //for (int i = 0; i < k; i++)
  //{
  //  print(maxRatio[i] + " ");
  //  // clear up maxRatio and contours for later use
  //  maxRatio[i] = 0;
  //  contours[i].update(0, 0, 0, 0);
  //}
  //println();

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
