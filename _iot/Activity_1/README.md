
First Activity of IoT course
=
- Academic year 2019-2020
- 2nd semester of 1st year
- Politecnico di Milano
________________________
 Group members:
 =
> - Hiva Amiri                       10696153
> - Erfan Abbasi Zadeh Behbahani     10628157
> - MohammadJavad Ebrahimpour        10696374
________________________

Approaches
=
To fulfill the activity requirements the following steps have been made:

In the case of motes functioning in a specific frequency, we can compile a unique code for each mote. For instance, we want mote 1 function at 1Hz so we compile e specific code in which the timer has been set to work at 1Hz, afterward we compile another code that works at 3Hz and we upload it to the 2nd mote and so far.
Another approach is that we can set a variable for Timer component as an argument of the function and an `if` condition determines in which frequency the current mote do its job based on the ID of the mote
Both approaches have been developed and uploaded in a separate folder. 

It requires sending two different amounts of data over the radio. In this case, we need two variables, one for sending mote ID and second to send counter. To do this, a 16bit unsigned integer variable has been set for sending counter and an 8bit unsigned integer variable has been set for mote ID. So we need to modify the header file to add a `uint8_t` to the payload.
 
    typedef nx_struct radio_count_msg {
    nx_uint8_t IdOfMote;
    nx_uint16_t counter;
    } radio_count_msg_t;


Toggling the LEDs uses the ID of the sender mote. It means that when a mote receives a message, it looks at the ID of the sender which is stored in a received packet, by doing an `if` condition, the corresponding LED will toggle every time a message received from the same mote.

        // following if conditions Toggles the LEDs based on the ID of the sender mote
        if (msg->IdOfMote == 1) 
        {
            call Leds.led0Toggle();
        }

        if (msg->IdOfMote == 2) 
        {
            call Leds.led1Toggle();
        }

        if (msg->IdOfMote == 3) 
        {
            call Leds.led2Toggle();
        }



Each time a mote receives a true message, the counter variable increments one step. Afterward an `if` condition determines that the counter is a factor of 10 or not, if yes, it turns off all the LEDs of the receiver mote.

        if (counter % 10 == 0)	//if counter mod 10 equals to 0, it makes the LEDs off
        {
            call Leds.led0Off();
            call Leds.led1Off();
            call Leds.led2Off();
        }

