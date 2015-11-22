//
// Created by Pablo Rodriguez Quesada on 11/21/15.
//

#ifndef CAR_TELNET_H
#define CAR_TELNET_H
#include <stdio.h>
#include <time.h>
int receive();
int init();
void delay();
int moveBACK(int blocks);
int moveFORWARD(int blocks);
int turnLEFT();
int turnRIGHT();
int turnOFF();
int turnON();
#endif //CAR_TELNET_H
