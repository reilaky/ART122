Centroids Kmeans(){
  // Generate random center
  color[] centroids = new color[k];
  randCenter(k);
  
  float assement = 0;
  boolean converge = false;
  int[] label = new int[numPixel];
  
  // If not converge
  while(!converge)
  {
    // set to old_centroids
    color[] old_centroids = new color[k];
    for(int i = 0; i < k; i++)
    {
      old_centroids[i] = color(centroids[i]);
    }
    
    // calculate new centroids
    for(int i = 0; i < numPixel; i++)
    {
      // label element with the nearst centroid
      float min_dist = Float.MAX_VALUE;

      for(int j = 0; j < k; j++)
      {
        float d = getDistance(rawColor[i], centroids[j]);
        if(d < min_dist)
        {
          min_dist = d;
          label[i] = j;
        }  
      }
      // update the error
      assement += getDistance(rawColor[i], centroids[label[i]]);
    }
    
    // update centroid
    for(int i = 0; i < k; i++)
    {
      // use mean value of rgb as new centroids
      float[] sum = new float[3];
      int cnt = 0;
      for(int j = 0; j < rawColor.length; j++)
      {
        if(label[j] == i){
          sum[0] += red(rawColor[j]);
          sum[1] += green(rawColor[j]);
          sum[2] += blue(rawColor[j]);
          cnt++;
        }
      }
      centroids[i] = color(sum[0]/cnt, sum[1]/cnt, sum[2]/cnt);
    }
    converge = converged(old_centroids, centroids);
  }
  
  Centroids cen = new Centroids(assement, centroids, label);
  return cen;
}

color[] randCenter(int k){
  Set<String> temp = new HashSet<String>();
  while(temp.size() < k){
    temp.add(Float.toString(random(0, 255)) + " " + Float.toString(random(0, 255)) + " " + Float.toString(random(0, 255)));
  }
  int i = 0;
  color[] centroids = new color[k];
  for(String s:temp){
    centroids[i] = convertStr2C(s);
    i++;
  }
  return centroids;
}

boolean converged(color[] centroids1, color[] centroids2)
{
  String[] temp1 = new String[k];
  String[] temp2 = new String[k];
  for(int i = 0; i < k; i++)
  {
    temp1[i] = convertC2Str(centroids1[i]);
    //println("old_centroids[", i, "]", temp1[i]);
    temp2[i] = convertC2Str(centroids2[i]);
    //println("new_centroids[", i, "]", temp2[i]);
  }
  return new HashSet(Arrays.asList(temp1)).equals(new HashSet(Arrays.asList(temp2)));
}


float getDistance(color c1, color c2){
    float d = new Float(Math.sqrt((red(c1) - red(c2)) * (red(c1) - red(c2)) 
    + (blue(c1) - blue(c2)) * (blue(c1) - blue(c2))
    + (green(c1) - green(c2)) * (green(c1) - green(c2))));
    return d;
}

color convertStr2C(String s){
  String[] temp = s.split(" ");
  return color(Float.valueOf(temp[0]), Float.valueOf(temp[1]),  Float.valueOf(temp[2]));
}

String convertC2Str(color c){
  return Float.toString(red(c)) + " " + Float.toString(green(c)) + " " + Float.toString(blue(c));
}
