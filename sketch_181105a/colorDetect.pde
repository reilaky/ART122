void colorDetection()
{
  for(int sw = slidingWindowMin; sw < slidingWindowMax; sw += 5 )
  {
    // initial the first sliding window
    int area = sw * sw;
    slidingWindow(sw);
    int domainIndex = hasDomainColor(sw);
    if(domainIndex != -1 && contours[domainIndex].w * contours[domainIndex].h < area)
    {
      contours[domainIndex].update(0, 0, sw, sw);
    }
    
    // sliding
    for(int i = sw; i < width; i++)
    {
      for(int j = sw; j < height; j++)
      {
        slidingWindow(i, j, sw);
        domainIndex = hasDomainColor(sw);
        // always update to the largest area.
        if(domainIndex != -1 && contours[domainIndex].w * contours[domainIndex].h < sw * sw)
        {
          contours[domainIndex].update(i, j, sw, sw);
        }
      }
    }
  }
}

void slidingWindow(int sw)
{
  // row
  for(int i = 0; i < sw; i++)
  {
    // col
    for(int j = 0; j < sw; j++)
    {
      int loc = i + j * width;
      color c = video.pixels[loc];
      int res = centroids.inRange(c);
      if(res != -1)
      {
        currSum[k] += 1;
        // store the first row result for later sliding
        if(j == 0)
        {
          prev[k] += 1;
        }
      }
    }
  }
}

void slidingWindow(int row, int col, int sw)
{
  // substract previous column and clear prev for update
  for(int i = 0; i < k ; i++)
  {
    currSum[i] -= prev[i];
    prev[i] = 0;
  }
  // only update the new column
  for(int i = 0; i < sw; i++)
  {
    int loc = row + (col + i) * width;
    color c = video.pixels[loc];
    int res = centroids.inRange(c);
    if(res != -1)
    {
      currSum[k] += 1;
    }
    
    // update the current first row result for later sliding
    loc = row - sw + 1 + (col + i) * width;
    c = video.pixels[loc];
    res = centroids.inRange(c);
    if(res != -1)
    {
      prev[k] += 1;
    } 
  }

}

int hasDomainColor(int sw){
  for(int i = 0; i < k; i++)
  {
    float temp = new Float(currSum[i]);
    if(temp / sw > threshold )
    {
      return k;
    }
  }
  return -1;
}
