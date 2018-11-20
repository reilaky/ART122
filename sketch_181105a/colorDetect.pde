void colorDetection()
{
  //output.println("Color Detection");
  for(int sw = slidingWindowMin; sw <= slidingWindowMax; sw += 80 )
  {
    
    //output.println("sw = " + sw);
    int area = sw * sw;
    // sliding
    for(int i = 0; i < width - sw; i++)
    {
      // initial the first sliding window
      //output.println("-------------------------------------------------------------------------------------------------");
      slidingWindow(sw, i);
      int domainIndex = hasDomainColor(area);
      if(domainIndex != -1 && contours[domainIndex].w * contours[domainIndex].h <= area)
      {
        contours[domainIndex].update(0, 0, sw, sw);
      }
      for(int j = sw; j < height; j++)
      {
        slidingWindow(i, j, sw);
        domainIndex = hasDomainColor(area);
        // always update to the largest area.
        if(domainIndex != -1 && contours[domainIndex].w * contours[domainIndex].h <= area)
        {
          contours[domainIndex].update(i, j, sw, sw);
        }
      }
    }
  }
}

void slidingWindow(int row, int col, int sw)
{
  
  // substract previous column and clear prev for update
  for(int i = 0; i < k; i++)
  {
    currSum[i] -= prev[i];
    prev[i] = 0;
  }
  
  //output.print("subract prev: ");
  //for(int i = 0; i < k; i++)
  //{
  //  output.print(currSum[i] + " ");
  //}
  //output.println();
  //output.print("col pos: ");
  
  // only update the new column
  for(int i = 0; i < sw; i++)
  {
    int loc = row + i + col * width;
    //output.print("(" + (row + i) + "," + col + "): ");
    color c = snapshot.pixels[loc];
    int res = centroids.inRange(c);
    //output.print(res +" ");
    if(res != -1)
    {
      currSum[res] += 1;
    }
  }
  //output.println();
  //output.print("currSum: ");
  //for(int i = 0; i < k; i++)
  //{
  //  output.print(currSum[i] + " ");
  //}
  
  //output.println();
  //output.print("prev pos: ");
  for(int i = 0; i < sw; i++)
  {
    // update the current first row result for later sliding
    int loc = row + i + (col - sw + 1) * width;
    //output.print("(" + (row + i) + "," + (col - sw + 1) + "): ");
    int c = snapshot.pixels[loc];
    int res = centroids.inRange(c);
    //output.print(res + " ");
    if(res != -1)
    {
      prev[res] += 1;
    }
  }
  //output.println();
  //output.print("new prev: ");
  //for(int i = 0; i < k; i++)
  //{
  //  output.print(prev[i] + " ");
  //}
  //output.println("");
}

void slidingWindow(int sw, int row)
{
  //output.println("initialization");
  //output.println("current: ");
  // every new row, clear currSum and prev 
  for(int i = 0; i < k; i++)
  {
    currSum[i] = 0;
    prev[i] = 0;
  }
  for(int i = row; i < sw + row; i++)
  {
    for(int j = 0; j < sw; j++)
    {
      int loc = i + j * width;
      //output.print("(" + i + "," + j + "): ");
      color c = snapshot.pixels[loc];
      int res = centroids.inRange(c);
      //output.print(res + " ");
      if(res != -1)
      {
        currSum[res] += 1;
        // store the first row result for later sliding
        if(j == 0)
        {
          prev[res] += 1;
        }
      }
    }
    //output.println();
  }
  //output.print("domain color: ");
  //for(int i = 0; i < k; i++)
  //{
  //  output.print(currSum[i] + " ");
  //}
  //output.println();
  //output.print("prev: ");
  //for(int i = 0; i < k; i++)
  //{
  //  output.print(prev[i] + " ");
  //}
  //output.println();
  //output.println("-------------------------------------------------------------------------------------------------");
}

int hasDomainColor(int area){
  int domainIndex = -1;
  for(int i = 0; i < k; i++)
  {
    float temp = new Float(currSum[i]);
    float ratio = temp / area;
    if(ratio >= threshold)
    {
      if(ratio > maxRatio[i])
      {
        maxRatio[i] = ratio;
        domainIndex = i;
      }
    }
  }
  return domainIndex;
}
