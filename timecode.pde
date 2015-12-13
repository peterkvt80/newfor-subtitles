/** Convert from milliseconds to HMSF
 * Use translate to move this to where you want
 */
void drawTimeCode(int tc, String caption, color colour)
{
  int dx=120;
  int dw=dx/9;
  noStroke();
  // Headings
  fill(color(170,0,0));
  for (int i=0;i<4;i++)
  {
    rect(0+i*dx,0,dx-dw,30);
  }
  // Text for units headings
  fill(255);
  int x=10;
  textSize(14);
  text("HOUR",x,20);
  text("MIN",x+=dx,20);
  text("SEC",x+=dx,20);
  text("FRAME",x+=dx,20);
  
  // Group captions
  fill(0);
  rect(dx*1.1,105,dx*1.6,30);
  fill(255);
  textSize(20);
  text(caption,10+dx*1.1,127);
  
  
  // Time panels
  fill(0);
  for (int i=0;i<4;i++)
  {
    rect(0+i*dx,40,dx-dw,60);
  }
  // The actual text
  x=25;
  int y=85;
  textSize(40);
  fill(colour);
  int fr=1+(tc%1000)*25/1000;
  tc/=1000;
  int ss=tc % 60;
  tc/=60;
  int mm=tc % 60;
  tc/=60;
  int hh=tc % 60;
  text(nf(hh,2),x,   y); // h
  text(nf(mm,2),x+dx,  y); // m
  text(nf(ss,2),x+dx*2,y); // s
  text(nf(fr,2),x+dx*3,y); // f
}