import processing.net.*;
import controlP5.*;

// Gui
ControlP5 cp5;
Button btnPlay;

// Transport
int subtitleTime;
boolean playing;

// Network
Client client;
String pi_ipAddress;
String pi_port;

// Subtitle
Subtitle subtitle;
int state=0; // 0=Buffer empty 1=subtitle loaded 2=OnAir
String subsFile; /// The full filename of the subtitles file

// Teletext
char HamTab[] = {0x15,0x02,0x49,0x5E,0x64,0x73,0x38,0x2F,0xD0,0xC7,0x8C,0x9B,0xA1,0xB6,0xFD,0xEA}; 

// Settings
XML xml;
XML[] settings;

void setup()
{
  playing=false;
  size(500,700);
  loadSettings();
  client=null;
  connect();
  println("1: set 888 2: Set text 3: On 4: clear");
  subtitle=new Subtitle("Blade-Runner-Final-Cut-1982-BRRip-XviD-SLiCK.srt");
  sendPageNumber(0x888);
  client.write(0x18);  // Subtitle off air  
  state=0;
  setupTransport();
}

void draw()
{
  int et=subtitle.endSub();
  int st=subtitle.startSub();
  String s="";
  background(100);
  response();
  switch (state)
  {
   case 0:  // buffer empty
    subtitle.readRecord();
    int rows=subtitle.getCount();
    client.write(0x0f); // Subtitle data command
    client.write(HamTab[rows]); // Number of rows
    // println("row count="+rows);
    for (int i=0;i<rows;i++)
    {
      // Probably want to encode basic effects here, colour etc.
      String x=subtitle.getLine(i);
      // println("sub="+x);
      sendRow(subtitle.getLine(i),23+(i-rows)*2);
    }
    state=1; // subtitle loaded and ready to go
    break;
  case 1: // buffer loaded

    if (st<subtitleTime)
    {
      client.write(0x10); // Put the page on air
      state=2;
    }
      
    break;
  case 2: // Subtitle is on air
    if (et<subtitleTime)
    {
      client.write(0x18);  // Subtitle off air now
      state=0;
    }
    break;
  }
  fill(255);
  int y=100;
  if (playing)
    subtitleTime=millis()-subtitle.offset();
  //text(nf(subtitle.offset()/100,7),200,y);
  color c;
  if (state==1)
    c=color(255,255,0);
  else
    c=color(0,255,0);
//  text(nf((st)/100,7),10,y+40);
//  text(nf((et)/100,7),200,y+40);
  //text(subtitle.getStartString()+" Start",10,y+40);
  //text(subtitle.getEndString()+" End",10,y+90);
  
  pushMatrix();
  translate(10,100);
  drawTimeCode(subtitle.endSub(),"SUBTITLE ENDS",color(255,0,0));
  translate(0,150);
  drawTimeCode(subtitleTime,"PRESENT TIME",color(0,255,0));
  translate(0,150);
  drawTimeCode(subtitle.startSub(),"SUBTITLE STARTS",c);
  popMatrix();
  drawSubs(state);
}

void drawSubs(int state)
{
  fill(0);
  rect(0,550,500,150);
  textSize(15);
  switch (state)
  {
  case 0:return; // Blanked
  case 1:fill(255,255,0);break; // Prepared
  case 2:fill(255,255,255);break; // Live
  }
  for (int i=0;i<subtitle.getCount();i++)
  {
    String x=subtitle.getLine(i);
    text(subtitle.getLine(i),10,570+i*20);
  }
}


/** Response from VBIT-Pi
 */
void response()
{
  if (client.available()>0)
  {
    println("VBIT>"+client.readString());
  }
}

/**
 * Teletext page number to VBIT-Pi
 */
void sendPageNumber(int page)
{
  client.write(0x0e); // Page Init command 
  client.write(HamTab[0]); // Always 0
  client.write(HamTab[page/0x100]); // H
  client.write(HamTab[(page&0xf0)/0x10]); // T
  client.write(HamTab[page&0x0f]); // U
}

void sendRow(String s,int row)
{
  client.write(HamTab[row/16]); // Row High nybble
  client.write(HamTab[row%16]); // Row Low nybble
  String b="\r\u000b\u000b"; // Start box
  String t=(b+s+"\n                                       ").substring(0,40);
  client.write(t); // MUST BE 40 characters!!!  
}

void keyPressed()
{
  int i;
  int rowcount=3;
  int row=10; 
  if (!connect()) return; // Oh dear
  switch (key)
  {
    case 'y':
      client.write("Y\n");
      break;
    case '1':
      client.write(0x0e); // Page Init command 
      client.write(HamTab[0]); // Always 0
      client.write(HamTab[8]); // H
      client.write(HamTab[8]); // T
      client.write(HamTab[8]); // U     
      break;
    case '2' : // Set subtitle data
      // println("Sending subtitle data");
      client.write(0x0f); // Subtitle data command
      client.write(HamTab[rowcount]); // Number of rows
      client.write(HamTab[row/16]); // Row High nybble
      client.write(HamTab[row%16]); // Row Low nybble
      client.write("First line of data goes here            "); // MUST BE 40 characters!!!
      row+=2;
      client.write(HamTab[row/16]); // Row High nybble
      client.write(HamTab[row%16]); // Row Low nybble
      client.write("Hopefully this will be another line     "); // MUST BE 40 characters!!!
      row+=2;
      client.write(HamTab[row/16]); // Row High nybble
      client.write(HamTab[row%16]); // Row Low nybble
      client.write("And this is the last line which we see  "); // MUST BE 40 characters!!!
      row+=2;

      
      // println("Done sending subtitle data");
      break;
    case '3' : // Subtitle display
      client.write(0x10);
      break;
    case '4' : // Subtitle clear down
      client.write(0x18);
      break;
  }
  
}

boolean connect()
{
  println("Connecting to "+pi_ipAddress+":"+pi_port);
  if (client==null)  
    client=new Client(this,pi_ipAddress, int(pi_port));
  return (client.active());
}