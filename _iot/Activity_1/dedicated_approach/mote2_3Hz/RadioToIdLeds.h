

#ifndef RADIO_ID_TO_LEDS_H
#define RADIO_ID_TO_LEDS_H

typedef nx_struct radio_count_msg {
  nx_uint8_t IdOfMote;
  nx_uint16_t counter;
} radio_count_msg_t;

enum {
  AM_RADIO_COUNT_MSG = 6,
};

#endif
