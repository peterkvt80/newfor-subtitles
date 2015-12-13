/**
 * Settings are stored in newfor.xml
 * It is created if it does not exist.
 * Settings include last SRT file, IP address of Raspberry pi.
 */
 
 
 
 void loadSettings()
 {
   // Does newfor.xml exist?
   if (!fileExists(dataPath("newfor.xml")))
   {
     // OutputStream os=createOutput("newfor.xml");
   }
   // Load it
   xml=loadXML("newfor.xml");
   pi_ipAddress=xml.getChild("piaddress").getContent().toString();
   pi_port=xml.getChild("piport").getContent().toString();
   subsFile=xml.getChild("filename").getContent().toString();
 }
 
 // Access routines to settings
 
 boolean fileExists(String path) {
  File file=new File(path);
  println(file.getName());
  boolean exists = file.exists();
  if (exists) {
    println("true");
    return true;
  }
  else {
    println("false");
    return false;
  }
} 