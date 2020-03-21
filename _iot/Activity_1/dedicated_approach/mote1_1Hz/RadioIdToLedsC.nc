#include "Timer.h"
#include "RadioIdToLeds.h"
//#include "printf.h" // to test the code, not useable anymore


module RadioIdToLedsC @safe() 
{
    uses	//general interfaces
    {
        interface Leds;
        interface Boot;
    }
    
    uses	//timer interface
    {
        interface Timer<TMilli> as MilliTimer; 	
    }
    
    uses	//radio interfaces
    {
        interface Receive;
        interface AMSend;
        interface SplitControl as AMControl;
        interface Packet;
    }
}


implementation 
{

    message_t packet;			// make a payload to send over radio
    bool _IsRadioBusy;			// a boolian variable to check the avaiability of radio
    uint16_t _localCounter = 0;	// a 16bit variable to count received message

    event void Boot.booted() 
    {
        call AMControl.start();
    }

    event void AMControl.startDone(error_t err) 
    {
        if (err == SUCCESS) // constant SUCCESS which equals 0 to check that is there an error starting the radio or not
        {
   				call MilliTimer.startPeriodic(1000); // specified for mote 1. 1Hz
        }
        else 
        {
            call AMControl.start();	    // if there is an error in starting the radio, this line tries to start it over and over
        }
    }

    event void AMControl.stopDone(error_t err) 
    {
                                       // do nothing cus we don't want turn the radio off
    }

    event void MilliTimer.fired() 
    {
        if (_IsRadioBusy)            // check if the radio is busy or not
        {
            return;
        }
        else 
        {
            radio_count_msg_t* msg = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t)); // making a packet named "msg" to send over radio
            if (msg == NULL) 
            {
                return;
            }

            msg->counter = (uint16_t)_localCounter;		//put amount of counter to msg->counter
            msg->IdOfMote = TOS_NODE_ID;				//put ID of the sender mote to IdOfMote
            
            if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS) 
            {
                _IsRadioBusy = TRUE;      // make the flag TRUE -> radio is busy
            }
        }
    }

    event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len) 
    {
        if (len != sizeof(radio_count_msg_t)) 
        {
        	call Leds.led0Off();
            call Leds.led1Off();
            call Leds.led2Off();
        	return bufPtr;
        }
        else 
        {
        radio_count_msg_t* msg = (radio_count_msg_t*)payload;
        _localCounter++;                  // this variable increamented once a true message received to the mote
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

        if (msg->counter % 10 == 0)		//the value of counter is different from the local counter since its value comes from received message
        {
            call Leds.led0Off();
            call Leds.led1Off();
            call Leds.led2Off();
        } 	
        return bufPtr;
    }
}

    event void AMSend.sendDone(message_t* bufPtr, error_t error) 
    {
        if (&packet == bufPtr) //packet == bufPtr means that all the has been sent or not, if yes, it makes the radio free
    {
        _IsRadioBusy = FALSE;
    }
    }

}
