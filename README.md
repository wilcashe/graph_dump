# GraphDump

Software that calculates and plots Throughput, Delay, Packet Loss (%) and other metrics from tcpdump traces.

--------------------------------------------------

The data transmission must be configured as: 
   server(sender)---->client(receiver)

A traffic capture in the server node is requiered.
Also is requiered a traffic capture in the client node.
So, we have two traffic capture file (traffic_server and traffic_host)

The traffic captures using tcpdump, must be created following (at least) these commands: -nn -v -tt

Example:
tcpdump -i h1-eth0 -nn -v -tt > /home/graph_dump/created/traffic_host

--------------------------------------------------------------

Throughput is calculated y ploted from the sent traffic (traffic_server file)
Delay and Packet Loss are calculated using both traffic files (server and client traffic capture)

----------------------------------------------

Dependencies (most come installed in Unix): Python, Perl, AWK, Grep, Sed, GNUPlot, Sort, Join, bc, wc.

Python Libraries requiered:
Tkinter, Pmw, sys,  os

pip install Pmw

---------------------------------------------

Run the program with:
python graphdump.py
---------------------------------------------

The program generates a folder called: /output_files
the files "solo_th.txt" "delay.txt" "statistics.txt",
which can be used to generate figures in other software

