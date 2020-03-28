#ifndef SENDACK_H
#define SENDACK_H

typedef nx_struct _messageToSend {
        nx_uint8_t _typeMessage;
        nx_uint16_t _counterMessage;
        nx_uint16_t _dataMessage;

}_messageToSend_t;

#define REQ 1
#define RESP 2

enum{
    AM_MY_MSG = 6,
    _RAW = 0 
};

#endif
