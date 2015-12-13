/** 
 * @brief Class encapsulates a single newfor subtitle event.
 * An event consists of up to 7 rows of subtitles.
 * An on time and an off time/
 */
public class Subtitle
{
  private int index;
  private BufferedReader _in;
  private int _subsCount;
  private String[] _subs;
  // Time start
  private int _startTime; // Time in milliseconds
  private int _endTime;
  private int _offsetTime; // The offset from program time millis()
  private String _sStart;
  private String _sEnd;
  
  // Time end
  
  public Subtitle(String filename)
  {
    _in=createReader(filename);
    _subs=new String[8];
    _offsetTime=millis();  // When we load subs, make them start from now.
    _sStart="00:00:00,000";
    _sEnd="00:00:00,000";
  }
  
  /**
   * @return Record number or 0 if ended or failed.
   */
  public int readRecord()
  {
    // First is the event number
    String s=_nextLine();
    _subsCount=0;
    index=int(s);
    // The event timing
    s=_nextLine();
    // @todo: Decode the timing
    // A sample of timing:
    // Start time and remove time
    // 00:02:17,440 --> 00:02:20,375
    
    int n=s.indexOf("-->");
    _sStart=trim(s.substring(0,n));
    _sEnd=  trim(s.substring(n+3));
    String[] bits=splitTokens(_sStart,",");
    String[] t=splitTokens(bits[0],":");
    _startTime=int(t[0]); // hour
    _startTime=_startTime*60+int(t[1]); // minute
    _startTime=_startTime*60+int(t[2]); // second
    _startTime=_startTime*1000+int(bits[1]);

    bits=splitTokens(_sEnd,",");
    t=splitTokens(bits[0],":");
    _endTime=int(t[0]); // hour
    _endTime=_endTime*60+int(t[1]); // minute
    _endTime=_endTime*60+int(t[2]); // second
    _endTime=_endTime*1000+int(bits[1]);
    println("Start time="+_startTime+" End time="+_endTime);
    
    for (int i=0;i<8;i++)
    {
      s=_nextLine();
      if (s==null) return 0;
      if (s.equals("")) break;
      _subsCount++;
      _subs[i]=s;
    }
    return index;
  }
  
  /**
   * 
   * @param line Line number to load   
   * @return Get a line
   */ 
  public String getLine(int line)
  {
    if (line>=_subsCount)
      return "Line out of range";
    return _subs[line];
  }
  
  /**
   * @return Line count for this subtitle
   */
  public int getCount()
  {
    return _subsCount;
  }
  
  /**
   * \return the next string from the subtitle file
   */
  private String _nextLine()
  {
    String line="?";
    try
    {
      line=_in.readLine();
    }
    catch (IOException e)
    {
      e.printStackTrace();
      line = null;
    }
    if (line == null) {
      // Stop reading because of an error or file is empty
      noLoop();  
    }
    return line;
  }  
  
  public int startSub()
  {
    return _startTime;
  }
  
  public int endSub()
  {
    return _endTime;
  }
  
  public int offset()
  {
    return _offsetTime;
  }
  
  public void SetOffset(int t)
  {
    _offsetTime=t;
  }
  
  public String getStartString()
  {
    return _sStart;
  }
  public String getEndString()
  {
    return _sEnd;
  }
  
  
}