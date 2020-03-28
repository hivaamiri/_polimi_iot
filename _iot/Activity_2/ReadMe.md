
2d Activity of IoT course
=
- Academic year 2019-2020
- 2nd semester of 1st year
- Politecnico di Milano

________________________
 Group members:
 -
> - Hiva Amiri                       10696153
> - Erfan Abbasi Zadeh Behbahani     10628157
> - MohammadJavad Ebrahimpour        10696374
________________________

Requirements
-
Implement a project using TinyOS platform to send an acknowledgement request among two nodes. There are two nodes named node 1 and node 2 and node one wants to send an Ack request to the node two. While node two turns on after five seconds of booting node one. When node one gets the first Ack response from node two, transmitting data will stop. On the other hand, node two receive an Ack request from node one, and it response with a message containing a counter which counts the number of requests of both nodes and a data from a fake temperature sensor.

Approach
-
The basic of the TinyOS on starting a radio and sending data was discussed in the first activity. What is new in this project is sending and receiving acknowledgments from nodes and also reading data from a sensor has been focused. The component that is used for acknowledgment is Packageacknolegement which has three main commands of noAck(), requestAck() and wasAcked() to make an acknowledgment between nodes. The component named Read is implemented to read data from a sensor which in this case a fake sensor is provided. Read component has a command of read() to initiate a read of the value and an Event that triggers when the completion of the read occurs.
Motes are booted and it makes the radio on, a timer with the period of one second calls a function named sendReq() to send an Ack request to the second mote. Since the second mote starts to work after five seconds, the first mote doesn’t get any response from it and tries to retransmit its request after one second. Once mote two boots, it receives the message from the first bot using the Receive component. An if statement checks whether the received message is an Ack request or not, if yes, it calls the sendResp() function to initiate response procedure to mote one. Since it is required to put a value of a fake sensor in the response message, sendResp() function calls Read.read() function to return a value from a fake sensor. After getting the value, a packet consists of Ack response, a counter which counts the efforts to send and receive an Ack request and a value of fake sensor would be made and sent to the first mote. Mote one receives a response from the second mote and because of the requirement of the project, the timer stops, and no further transmission occurs.
