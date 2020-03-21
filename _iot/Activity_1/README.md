First Activity of IoT course
Academic year 2019-2020
2nd semester of 1st year
Politecnico di Milano
________________________
Group members:
Hiva Amiri                        10696153
Erfan Abbasi Zadeh Behbahani      10628157
MohammadJavad Ebrahimpour         10696374
________________________

To fulfill the activity requirements the following steps has been made:

In case of motes dunctioning in a specific frequency, we can compile a uniqe code for each mote. For instance we want mote 1 function at 1Hz so we compile e specific code which the timer has been set to work at 1Hz, afterwards we compile another code which works at 3Hz and we upload it to the 2nd mote and so far.
Another approach is that we can set a variables for Timer component as an argument of the function and an "if" condotion determines in which frequency the current mote do its job based on the ID of the mote
Both approach has been developed and uploded in separate folder. 

It requires to send two different amount of data over radio. In this case we need two variables, one for sending mote ID and second to send counter. To do this, a 16bit variables has been set for sending counter and an 8bit unsighned integer variable has been set for mote ID. So we need to modify header file to add a uint8_t to the payload.




Toggling the LEDs uses the ID of the sender mote. It means that when a mote receives a message, it looks at the ID of sender which is stored in recived packet, by doing an "if" condition, the corresponting LED will toggle every time a message received from the same mote.

Each time a mote recives a true message, the counter variable incremens one step. Afterward an "if" condition determines that the counter is a factor of 10 or not, if yes, it turns off all the LEDs of the receiver mote.




