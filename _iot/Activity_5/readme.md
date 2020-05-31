
Objective
=
Generating a random number by TinyOS and sending it by Node-Red via MQTT to Thing speak.
 

Approach
=
The project of Activity 2 is used to develop required objective. Most of the functions are similar to second hands-on activity which its source and documentation is accessible via this link.
On node 2 and 3 a timer is fired every 5 second and consequently a random number is generated and sent to node one. The packet consists of random value and the ID of sender mote.
On node 1 side, instead of having a timer to fire, radio is hearing to the channel to receive packets, after receiving a packet, it parses the packet and send its values in a pre-determined format using print() function. Each value has its source ID and it will be printed to the serial output in format of Mote%u/value,%u,\n. Since there are some unwanted characters in “cooja” simulator while simulating “telosb” motes, the comma symbol is used to a better separation on node-red. 
On the node-red side, it listens to the TCP port number 60001 (which we can change to any other port) and reads the value from cooja, a CSV function converts the value to javascript objets in three two field named “mote and val”.
Now, it is easy to filter values greater than 70, a delay function delays the sending operation to meet the server requirements. A switch function separates the data from Mote 2 and 3 by checking their topic, afterwards to have a pure value of  data ( the random value generated in TinyOS ) a change functions puts the msg.payload.val to the msg.payload and it goes to send to its broker via MQTT.
On MQTT function, values came from mote 2 is sent to field 1 on Thingspeak broker and also, values came from mote 3 is sent to field 2.



