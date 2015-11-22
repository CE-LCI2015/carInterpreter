//
// Created by Pablo Rodriguez Quesada on 11/13/15.
//
#include <stdlib.h>
#include <stdio.h>
#include <string.h>    //strlen
#include <sys/socket.h>    //socket
#include <arpa/inet.h> //inet_addr

int sock;

int receive()
{
    char  server_reply[100];
    if( recv(sock , server_reply , 2000 , 0) < 0  )
    {
        puts("recv failed");
        return -1;

    }
    return strcmp(server_reply,"REC");
}

int init()
{

    ////////////////////////////Telnet///////////////////////////

    struct sockaddr_in server;

    //Create socket
    sock = socket(AF_INET , SOCK_STREAM , 0);
    if (sock == -1)
    {
        printf("Could not create socket");
        return 1;
    }
    puts("Socket created");

    server.sin_addr.s_addr = inet_addr("192.168.43.147");
    server.sin_family = AF_INET;
    server.sin_port = htons( 23 );



    return 0;

}


int turnON() {
    send(sock ,"ON",2,0);
    return receive();
}
int turnOFF() {
    send(sock ,"OFF",3,0);
    return receive();
}
int turnRIGHT() {
    send(sock ,"RI",2,0);
    return receive();
}
int turnLEFT() {
    send(sock ,"LE",2,0);
    return receive();
}

int moveFORWARD(int blocks) {
    char output[10]="MF";
    char str[10];
    snprintf(str, 10, "%d", blocks);
    strcat(output,str);
    send(sock ,output ,strlen(output), 0);
    return receive();
}
int moveBACK(int blocks) {
    char output[10]="MB";
    char str[10];
    snprintf(str, 10, "%d", blocks);
    strcat(output,str);
    send(sock ,output,strlen(output),0);
    return receive();
}




void delay(){
    int c = 1, d = 1;

    for ( c = 1 ; c <= 10000 ; c++ )
        for ( d = 1 ; d <= 10000 ; d++ )
        {}
}

