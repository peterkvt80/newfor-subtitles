/** GUI playback transport controls
 */
 
/** 
 * Create all the GUI components
 */
void setupTransport()
{
  textSize(20);
  cp5 = new ControlP5(this);
  int w=150;
  int h=30;
  int g=10;
  ControlFont cf = new ControlFont(createFont("Arial",20));  
    // create a new button with name 'load'
  Button b=cp5.addButton("loadSubs")
     .setValue(0)
     .setPosition(g,h+g*2)
     .setSize(w,h)
     .setCaptionLabel("Load SRT file")
     ;
     b.getCaptionLabel().setFont(cf);
  b=cp5.addButton("Restart")
     .setValue(0)
     .setPosition(g,g)
     .setSize(w,h)
     .setCaptionLabel("Restart")
     ;     
  b.getCaptionLabel().setFont(cf);
  btnPlay=cp5.addButton("play")
     .setValue(0)
     .setPosition(g+(w+g),g)
     .setSize(w,h)
     .setCaptionLabel("Start")
     ;  
  btnPlay.getCaptionLabel().setFont(cf);
  b=cp5.addButton("next")
     .setValue(0)
     .setPosition(g+(w+g)*2,g)
     .setSize(w,h)
     .setCaptionLabel("next")
     ;      
  b.getCaptionLabel().setFont(cf);
  playing=false;
}

/** Handlers for GUI
 */
public void loadSubs(int theValue) {
  println("a button event from buttonB: "+theValue);
 selectInput("Select a subtitle file","subtitleSelected"); 
} 

public void restart(int theValue)
{
  subtitle.SetOffset(millis());
}

public void play(int theValue) {
  println("a button event from buttonB: "+theValue);
   if (playing)
   {
     playing=false;
     btnPlay.setCaptionLabel("Resume");
   }
   else
   {
     playing=true;
     btnPlay.setCaptionLabel("Hold");
     // Resume
     subtitle.SetOffset(millis()-subtitleTime);
   }
} 

public void next(int theValue)
{
  subtitle.SetOffset(millis()-subtitle.startSub());
}
  

/** Handler for file reader
 */
void subtitleSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    subtitle=new Subtitle(selection.getAbsolutePath());
  }
}