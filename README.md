# newfor-subtitles
Create a Newfor subtitle stream from a SubRib subtitles file.

Newfor is a common protocol for teletext subtitles. It has only four functions, Set page, load subtitle buffer, put buffer on air and finally remove subtitle. This program takes an SRT subtitle file and creates a subtitle stream from it. Because serial ports are mostly obsolete the stream uses a TCP port instead. The Raspberry Pi teletext generator VBIT-Pi-Stream can accept Newfor on port 5570. How to use this code? Install the latest version of Processing. Run Processing and load newfor.pde. Then you can run it from the Processing IDE.

Configuration. Edit newfor.xml and set the piaddress to that of your Raspberry Pi. You can find the address as your pi should print it as the last step of the boot process. Otherwise you can use the ifconfig command. You should leave the port as 5570. The filename is not used at the moment.
<newfor>
	<piaddress>192.168.1.8</piaddress>
	<piport>5570</piport>
	<filename>Blade-Runner-Final-Cut-1982-BRRip-XviD-SLiCK.srt</filename>
</newfor>

The controls are the blue buttons. RESTART is not implemented and will not work. PLAY will start running through the subtitles. After pressing play the button becomes HOLD. HOLD stops the subtitles until you press the button again. LOAD SRT File lets you choose another SubRip Text file. You can get SRT files from many places. NEXT lets you skip to the next subtitle.

The SUBTITLE STARTS time is yellow. When a subtitle is on ait it goes green. Likewise text not on air yet is yellow and it turns white when on air. 
