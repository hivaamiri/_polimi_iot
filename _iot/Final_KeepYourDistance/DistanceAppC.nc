/*
Keep your distance project
#IoT course 
#A.Y 2019-2020 
#Plitecnico di Milano 
#Hiva Amiri #Erfan Abbasi zadeh #Mohammad Javad Ebrahimpour
*/
#include "Distance.h"
#include "printf.h"

configuration DistanceAppC{}
implementation
{

  components MainC, DistanceC as App;
  components new AMSenderC(AM_MY_MSG);
  components new AMReceiverC(AM_MY_MSG);
  components new TimerMilliC();
  components ActiveMessageC;
  components RandomC;
  components PrintfC;
  components SerialStartC;
  
  App.Boot -> MainC.Boot;
  
  App.Receive       -> AMReceiverC;
  App.AMSend        -> AMSenderC;
  App.SplitControl   -> ActiveMessageC;
  App.MilliTimer     -> TimerMilliC;
  App.Packet        -> AMSenderC;
  App.Random        -> RandomC;
}


