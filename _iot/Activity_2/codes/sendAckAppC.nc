
#include "sendAck.h"
configuration sendAckAppC{}
implementation
{
	//components
    components MainC, sendAckC as App;
    components new AMSenderC (AM_MY_MSG);
    components new AMReceiverC(AM_MY_MSG);
    components ActiveMessageC;
    components new TimerMilliC();
    components new FakeSensorC();
	//interface
    App.Boot -> MainC.Boot;

    //Wiring
    App.Receive 	-> AMReceiverC;
    App.AMSend		-> AMSenderC;
    App.SplitControl-> ActiveMessageC;
    App.AMPacket 	-> AMSenderC;
    App.Packet 		-> AMSenderC;
    App.PACKG		->ActiveMessageC;
    App.MilliTimer  -> TimerMilliC;
    App.Read 		-> FakeSensorC;
}


