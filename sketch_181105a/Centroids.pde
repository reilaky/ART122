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
    
    for(int i = 0; i < k; i++)
    {
      if(red(c) >= getRange(red(this.centroids[k]))[0] && red(c) <= getRange(red(this.centroids[k]))[1] && 
         green(c) >= getRange(green(this.centroids[k]))[0] && green(c) <= getRange(green(this.centroids[k]))[1] && 
         blue(c) >= getRange(blue(this.centroids[k]))[0] && blue(c) <= getRange(blue(this.centroids[k]))[1])
      {
        return k;
      }
    }
    return -1;
  }
  
  private float[] getRange(float n)
  {
    float[] range = new float[2];
    if(n - colorRange < 0)
    {
      range[0] = 0;
    }
    else
    {
      range[0] = n - colorRange;
    }
    if(n - colorRange > 255)
    {
      range[1] = 255;
    }
    else
    {
      range[1] = n + colorRange;
    }
    return range;
  }
}
