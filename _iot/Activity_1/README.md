
First Activity of IoT course
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

Approaches
-
 To fulfill the activity requirements the following steps have been made:

In the case of motes functioning in a specific frequency, we can compile a unique code for each mote. For instance, we want mote 1 function at 1Hz so we compile e specific code in which the timer has been set to work at 1Hz, afterward we compile another code that works at 3Hz and we upload it to the 2nd mote and so far.

    event void AMControl.startDone(error_t err) 
    {
        if (err == SUCCESS) // constant SUCCESS which equals 0 to check that is there an error starting the radio or not
        {// assign a frequency to send messages based on ID
        	if(TOS_NODE_ID == 1){
        		_frequency = 1000;
        		call MilliTimer.startPeriodic(_frequency);
        	}
        	else{
        		if(TOS_NODE_ID == 2){
        			_frequency = 333;
        			call MilliTimer.startPeriodic(_frequency);
        		}
        		else{
        			if (TOS_NODE_ID == 3){        		
        				_frequency = 200;
        				call MilliTimer.startPeriodic(_frequency);
        			}
        			else 
        				call MilliTimer.startPeriodic(_frequency); // in case if none of above happens, a default frequency would be set
        		}}}
        else 
        {call AMControl.start();}	// if there is an error in starting the radio, this line tries to start it over and over
        }



Another approach is that we can set a variable for Timer component as an argument of the function and an `if` condition determines in which frequency the current mote do its job based on the ID of the mote.

    event void AMControl.startDone(error_t err) 
        {
            if (err == SUCCESS) // constant SUCCESS which equals 0 to check that is there an error starting the radio or not
            {// assign a frequency to send messages based on ID
                call MilliTimer.startPeriodic(200); // in case if none of above happens, a default frequency would be set
            }
            else 
            {call AMControl.start();}	// if there is an error in starting the radio, this line tries to start it over and over
         }
Both approaches have been developed and uploaded in a separate folder. 

It requires sending two different amounts of data over the radio. In this case, we need two variables, one for sending mote ID and second to send counter. To do this, a 16bit unsigned integer variable has been set for sending counter and an 8bit unsigned integer variable has been set for mote ID. So we need to modify the header file to add a `uint8_t` to the payload.
 
    typedef nx_struct radio_count_msg {
    nx_uint8_t IdOfMote;
    nx_uint16_t counter;
    } radio_count_msg_t;


Toggling the LEDs uses the ID of the sender mote. It means that when a mote receives a message, it looks at the ID of the sender which is stored in a received packet, by doing an `if` condition, the corresponding LED will toggle every time a message received from the same mote.

    event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len) {
        if (len != sizeof(radio_count_msg_t)) {return bufPtr;}
        else {
        radio_count_msg_t* msg = (radio_count_msg_t*)payload;
        _localCounter++; // this variable increamented once a true message received to the mote
        // following if conditions Toggles the LEDs based on the ID of the sender mote
        if (msg->IdOfMote == 1) { call Leds.led0Toggle(); }
        if (msg->IdOfMote == 2) { call Leds.led1Toggle(); }
        if (msg->IdOfMote == 3) { call Leds.led2Toggle(); }
        if (msg->counter % 10 == 0)	//if counter mod 10 equals to 0, it makes the LEDs off
        {
            call Leds.led0Off();
            call Leds.led1Off();
            call Leds.led2Off();
        } 	
        return bufPtr;
    }}


Each time a mote receives a true message, the counter variable increments one step. Afterward, an `if` condition determines that the counter is a factor of 10 or not, if yes, it turns off all the LEDs of the receiver mote.
It worth mentioning that the value of counter incremented in a mote is separated from the value of counter received. It means that the turning of the LEDs is based on the counter value received from other motes. 

        if (msg->counter % 10 == 0)	//the value of counter is different from the local counter since its value comes from received message
        {
            call Leds.led0Off();
            call Leds.led1Off();
            call Leds.led2Off();
        }

