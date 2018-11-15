class Centroids{
  float assement;
  color[] centroids;
  //String[] centroidsName = new String[k];
  int[] label;
  
  public Centroids(float a, color[] c, int[] label)
  {
    this.assement = a;
    this.centroids = new color[c.length];
    this.label = new int[label.length];
    for(int i = 0; i < k; i++)
    {
      this.centroids[i] = color(c[i]);
    }
    for(int i = 0; i < numPixel; i++)
    {
      this.label[i] = label[i];
    }    
  }
  public Centroids()
  {
    this.assement = Float.MAX_VALUE;
    this.centroids = new color[k];
    this.label = new int[numPixel];
        
  }  
  public void update(Centroids c)
  {
    this.assement = c.assement;
    for(int i = 0; i < k; i++)
    {
      this.centroids[i] = color(c.centroids[i]);
    }
    for(int i = 0; i < numPixel; i++)
    {
      this.label[i] = c.label[i];
    }     
  }
  
  public void printCentroids()
  {
    println("Centroids: ");
    println("min error: ", this.assement);
    for(int i = 0; i < k; i++)
    {
      println("RGB: ", red(this.centroids[i]), green(this.centroids[i]), blue(this.centroids[i]));
    }
  }
  
  public void updateK()
  {
    int cnt = 0;
    for(int i = 0; i < k; i++)
    {
      if(this.centroids[i] != color(0, 0, 0))
      {
        cnt++;
      }
    }
    k = cnt;
  }
  
  public int inRange(color c)
  {
    int minIndex = -1;
    float minDist = Float.MAX_VALUE;
    for(int i = 0; i < k; i++)
    {
      float dist = sqrt(getDistance(this.centroids[i], c));
      if(p)
      {
        println("dist:", dist);
        print("color: ");
        printColor(this.centroids[i]);
        printColor(c);
        p = false;
      }
      if(dist <= colorRange && dist < minDist)
      {
          minDist = dist;
          minIndex = i;
      }
    }
    return minIndex;
  }
}
