#include "sendAck.h"
#include "Timer.h"

module sendAckC
{
    uses
    {
        interface Boot;       
        interface SplitControl;
        interface Receive;
        interface Timer<TMilli> as MilliTimer;
        interface Read<uint16_t>;
        interface AMPacket;
        interface Packet;
        interface PacketAcknowledgements as PACKG;
        interface AMSend;
    }
}

implementation
{
    uint8_t _counter = 0;
    message_t packet;
 
//###################functions#######################################    
    void sendReq();
    void sendResp();

//#################### Send Request function ####################
    void sendReq()
    {
        _messageToSend_t* MSG = (_messageToSend_t*)(call Packet.getPayload(&packet, sizeof(_messageToSend_t))); // build a message 
        
        MSG -> _typeMessage 	= REQ; 		 // putting REQ in the packet as a part of message
        MSG -> _counterMessage	= _counter;	 // putting _counter in the packet as a part of message
		MSG -> _dataMessage 	= _RAW;	 // putting _counter in the packet as a part of message
		
        dbg("radio_send", "Message packet was made and delivered to physical layer to send via radio ... ----> execution time %s \n", sim_time_string()); 
        
        call PACKG.requestAck(&packet); 					// send an acknowledgement request containing a packet of message
        if(call AMSend.send(2,&packet,sizeof(_messageToSend_t))==SUCCESS)	// calling AMSend function to send the packet to node 2 and return the result
        {
        																	//if sending message is succesful the following reports will be printed.
            dbg("radio_send", "Try to send a request to node 2 ----> execution time %s \n", sim_time_string());// the exact time of sending message
            dbg("radio_send", "Payload status:\n"); 
            dbg_clear("radio_pack","\t Source         : %hhu \n ", call AMPacket.source(&packet));
            dbg_clear("radio_pack","\t Destination    : %hhu \n ", call AMPacket.destination(&packet));
            dbg_clear("radio_pack","\t Type of Message: %hhu \n ",MSG->_typeMessage);
            dbg_clear("radio_pack","\t Counter valuse : %hhu \n ",MSG->_counterMessage);
            dbg_clear("radio_pack","\t Temperature    : %hhu \n ",MSG->_dataMessage);
            dbg_clear("radio_send","\n");
            dbg_clear("radio_pack","\n");

			
        }
    }
//#################### Send Response function ####################
    void sendResp() // responding an ACK request 
    {
       call Read.read();    	
    }
//#################### Boot Function ####################
    event void Boot.booted()
    {
        dbg("boot", "Node booted. Report from node: %u\n=======================================\n",TOS_NODE_ID);
        call SplitControl.start(); 

    }
//#################### SplitControl, startDone ####################

    event void SplitControl.startDone(error_t _ERRORresult)
    {
        if(_ERRORresult == SUCCESS) // if radio started successfully
        {
        	dbg("radio", "Turnning on radio ... \n");
            dbg("radio", "Radio is on now. \n");
            if(TOS_NODE_ID == 1) // if this code is running on mote with the ID 1
            {
                dbg("role", "Node 1 starts sending ACK request... ----> execution time %s \n", sim_time_string());
                call MilliTimer.startPeriodic(1000); //start a timer with the the period of 1 second
            }   
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
        sendReq();     // it calls sendReq function to send a ACK REQ request
        _counter++; // increaments in each try to send 
    }

//#################### AMSend, sendDone ####################
    event void AMSend.sendDone(message_t* _rec_buffer, error_t _ERRORresult)
    {
        if(&packet == _rec_buffer && _ERRORresult == SUCCESS) // if packet was sent successfull
        {
            dbg("radio_send", "Message was sent successfully.----> execution time %s \n", sim_time_string());    
        }
        if(call PACKG.wasAcked(_rec_buffer))
        {
			// stop timer
			if(TOS_NODE_ID ==1)
			{
				call MilliTimer.stop();	
			} 
            dbg("radio_ack","ACK message received.----> execution time %s \n", sim_time_string());
            dbg("radio_ack","Sending message was stoped.\n");
    	}
    	else
    	{
    		dbg("radio_ack","ACK message was NOT received. ----> execution time %s \n", sim_time_string());
            dbg_clear("radio_ack","Sending new ACK request.\n");		
			if(TOS_NODE_ID == 2)
			{								
				sendResp(); // call Response function to response ACK from node one
			}
    	}

    } 
//#################### Receive.recieve ####################
    event message_t* Receive.receive(message_t* _rec_buffer, void* payload, uint8_t len) // receiving a message
    {
        _messageToSend_t* MSG = (_messageToSend_t*)payload;// make a _messageToSend_t* type variable and put the recived message into it
        
        dbg("radio_rec", "Message received. ----> %s \n", sim_time_string());
        dbg("radio_send", "Payload status:\n"); 
        dbg_clear("radio_pack","\t Source         : %hhu \n ", call AMPacket.source(&packet));
        dbg_clear("radio_pack","\t Destination    : %hhu \n ", call AMPacket.destination(&packet));
        dbg_clear("radio_pack","\t Type of Message: %hhu \n ",MSG->_typeMessage);
        dbg_clear("radio_pack","\t Counter valuse : %hhu \n ",MSG->_counterMessage);
        dbg_clear("radio_pack","\t Temperature    : %hhu \n ",MSG->_dataMessage);
        dbg_clear("radio_send","\n");
        dbg_clear("radio_pack","\n");

        if(MSG->_typeMessage == REQ) // if the received message is a REQ type message, start response procedure by calling its task
        {        	
            sendResp();
            _counter = MSG->_counterMessage;
        }
    return _rec_buffer;
    } 
//#################### Read.readDone ####################
    event void Read.readDone(error_t result, uint16_t data) // this event triggered when a data from sensor was read successfully
    {      
        //we use this function to send back a respose to the request ACK and also sending data from fake sensor
        _messageToSend_t* MSG = (_messageToSend_t*)(call Packet.getPayload(&packet,sizeof(_messageToSend_t)));
        MSG->_typeMessage 	 = RESP; 
        MSG->_counterMessage = _counter;
        MSG->_dataMessage 	 = data;
        dbg("radio_send", "Sending a response to node 1 ----> execution time %s \n", sim_time_string());
        call PACKG.requestAck(&packet);
        if(call AMSend.send(1,&packet, sizeof(_messageToSend_t))==SUCCESS)
        {
            dbg("radio_send", "Try to send a request to node 1 ----> execution time %s \n", sim_time_string());
            dbg("radio_send", "Payload status:\n"); 
            dbg_clear("radio_pack","\t Source         : %hhu \n ", call AMPacket.source(&packet));
            dbg_clear("radio_pack","\t Destination    : %hhu \n ", call AMPacket.destination(&packet));
            dbg_clear("radio_pack","\t Type of Message: %hhu \n ",MSG->_typeMessage);
            dbg_clear("radio_pack","\t Counter valuse : %hhu \n ",MSG->_counterMessage);
            dbg_clear("radio_pack","\t Temperature    : %hhu \n ",MSG->_dataMessage);
            dbg_clear("radio_send","\n");
            dbg_clear("radio_pack","\n");        
        } 
    	
    }
}
