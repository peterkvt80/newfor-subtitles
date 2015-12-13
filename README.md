# newfor-subtitles
Create a Newfor subtitle stream from a SubRib subtitles file.

Newfor is a common protocol for teletext subtitles. It has only four functions, Set page, load subtitle buffer, put buffer on air and finally remove subtitle. This program takes an SRT subtitle file and creates a subtitle stream from it. Because serial ports are mostly obsolete the stream uses a TCP port instead. The Raspberry Pi teletext generator VBIT-Pi-Stream can accept Newfor on port 5570. How to use this code? Install the latest version of Processing. Run Processing and load newfor.pde. Then you can run it from the Processing IDE.
