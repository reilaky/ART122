class Rec{
  int x = 0;
  int y = 0;
  int w = 0;
  int h = 0;
  
  public Rec(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public Rec()
  {
    this.x = 0;
    this.y = 0;
    this.w = 0;
    this.h = 0;
  }
  
  public void drawRec()
  {
      rect(this.x, this.y, this.w, this.h);
  }
  
  public void update(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

}
