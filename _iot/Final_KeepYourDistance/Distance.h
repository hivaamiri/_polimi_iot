/*
Keep your distance project
#IoT course 
#A.Y 2019-2020 
#Plitecnico di Milano 
#Hiva Amiri #Erfan Abbasi zadeh #Mohammad Javad Ebrahimpour
*/
#ifndef Distance_H
#define Distance_H

typedef nx_struct _messageToSend {
        nx_uint16_t _MoteID;
        //nx_uint16_t _dataMessage;

}_messageToSend_t;



enum{
    AM_MY_MSG = 6,
    _REDUCE_RANGE = 100,
    _FREQUENNCY = 500,
};

#endif
