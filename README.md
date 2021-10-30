# Mouse-Input-BashTerminal
A function written in both C and x86 Assembly which captures mouse positions on a linux terminal using ansi escape codes

To enable mouse input in C use the ansi escape codes of the following. Make a call to system that enables this on the terminal<br>
&ensp;  system("stty -icanon"); <br>
&ensp;  system("stty -echo"); <br>
&ensp;  system("echo '\e[?1003h\e[?1015h\e[?1006h'"); <br>
  
Then the program returns the mouse string of <br>
&ensp;  \\<[xx;yy;zzM <br>

The xx contains the opcode of the mouse, the useful codes that I've found are: <br>
&ensp;  0 - Mouse Left Click <br>
&ensp;  2 - Mouse Right Click <br>
&ensp;  35 - Mouse Move <br>
&ensp;  64 - Mouse Wheel Down <br>
&ensp;  65 - Mouse Wheel Up <br>

The yy contains the Column of the mouse <br>
The zz contains the Row of the mouse <br>
The string ends either M or m. Upper case M means regular mouse event/mouse down, whereas lower case m means mouse up event

Inspiration and a template I built everything off found here: https://stackoverflow.com/questions/5966903/how-to-get-mousemove-and-mouseclick-in-bash
