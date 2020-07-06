/*
Keep your distance project
#IoT course 
#A.Y 2019-2020 
#Plitecnico di Milano 
#Hiva Amiri #Erfan Abbasi zadeh #Mohammad Javad Ebrahimpour
*/


#include "Distance.h"
#include "Timer.h"
#include "printf.h"

module sendAckC
{
    uses
    {
        interface Boot;  
        interface Random;     
        interface SplitControl;
        interface Receive;
        interface Timer<TMilli> as MilliTimer;
        interface AMPacket;
        interface Packet;
        interface AMSend;
    }
}

implementation
{
 
    message_t packet;
 



//#################### Boot Function ####################
    event void Boot.booted()
    {
        call SplitControl.start(); 
    }
//#################### SplitControl, startDone ####################

    event void SplitControl.startDone(error_t _ERRORresult)
    {
        if(_ERRORresult == SUCCESS) // if radio started successfully
        {
            call MilliTimer.startPeriodic(_FREQUENNCY); //start a timer with the the period of _FREQUENNCY second
        }
        else
        {
            dbg("radio", "Turnning on faild, try again ... \n");        
            call SplitControl.start(); // otherwise try to start the radio again
        }
    }
//#################### SplitControl, stopDone ####################
    event void SplitControl.stopDone(error_t _ERRORresult){}
//#################### MilliTimer function ####################
    event void MilliTimer.fired()
    {
        _messageToSend_t* MSG = (_messageToSend_t*)(call Packet.getPayload(&packet,sizeof(_messageToSend_t)));
        MSG -> _MoteID = TOS_NODE_ID; // send mote ID 
        dbg("radio_send", "Sending a response to node 1 ----> execution time %s \n", sim_time_string());
        if(call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(_messageToSend_t))==SUCCESS)// send a broadcast msg containing mote ID
        {
      
        } 
    }
//#################### AMSend, sendDone ####################
    event void AMSend.sendDone(message_t* _rec_buffer, error_t _ERRORresult)
    {
        if(&packet == _rec_buffer && _ERRORresult == SUCCESS) // if packet was sent successfull
        {
            dbg("radio_send", "Message was sent successfully.\n");    
        }
    } 
//#################### Receive.recieve ####################
    event message_t* Receive.receive(message_t* _rec_buffer, void* payload, uint8_t len)
    {
        _messageToSend_t* MSG = (_messageToSend_t*)payload;// make a _messageToSend_t* type variable and put the recived message into it
        dbg_clear("radio_send","\n");
        dbg_clear("radio_pack","\n");
        printf("SomeoneIsApproaching,ID=%u,msgEnd,ID=%u\n", MSG -> _MoteID, TOS_NODE_ID);
        printfflush();
        return _rec_buffer;
    } 
}
