//
// Created by Pablo Rodriguez Quesada on 11/13/15.
//
#include <stdlib.h>
#include <stdio.h>
#include <string.h>    //strlen
#include <sys/socket.h>    //socket
#include <arpa/inet.h> //inet_addr

int sock;

int main()
{

    ////////////////////////////7Telnet///////////////////////////

    struct sockaddr_in server;
    char message[1000] , server_reply[2000];

    //Create socket
    sock = socket(AF_INET , SOCK_STREAM , 0);
    if (sock == -1)
    {
        printf("Could not create socket");
    }
    puts("Socket created");

    server.sin_addr.s_addr = inet_addr("192.168.43.147");
    server.sin_family = AF_INET;
    server.sin_port = htons( 23 );

    //Connect to remote server
    if (connect(sock , (struct sockaddr *)&server , sizeof(server)) < 0)
    {
        perror("connect failed. Error");
        return 1;
    }

    puts("Connected\n");




    int i=0;
    //keep communicating with server
    while(1)
    {
        i++;
        if(i==1){
            moveFORWARD(5);
            puts("Server reply :");
            puts(server_reply);
            i=2;
            delay();
        }

        if(i==2){
            moveBACK(25);
            puts("Server reply :");
            puts(server_reply);
            i=3;
            delay();
        }
        if(i==3){
            turnON();
            puts("Server reply :");
            puts(server_reply);
            i=4;
            delay();
        }
        if(i==4){
            turnOFF();
            puts("Server reply :");
            puts(server_reply);
            delay();
        }



       printf("Enter message : ");
       scanf("%s" , message);




        //Send some data
        if( send(sock , message , strlen(message) , 0) < 0)
        {
            puts("Send failed");
            return 1;
        }

        //Receive a reply from the server
        if( recv(sock , server_reply , 2000 , 0) < 0  )
        {
            puts("recv failed");

        }
        puts("Server reply :");
        puts(server_reply);

    }



    //close(sock); // Da error si se deja sin comentar
    return 0;

}


void turnON() {
    send(sock ,"ON",2,0);
}
void turnOFF() {
    send(sock ,"OFF",3,0);
}
void turnRIGHT() {
    send(sock ,"RI",2,0);
}
void turnLEFT() {
    send(sock ,"LE",2,0);
}

void moveFORWARD(int blocks) {
    char output[10]="MF";
    char str[10];
    snprintf(str, 10, "%d", blocks);
    strcat(output,str);
    send(sock ,output ,strlen(output), 0);
}
void moveBACK(int blocks) {
    char output[10]="MB";
    char str[10];
    snprintf(str, 10, "%d", blocks);
    strcat(output,str);
    send(sock ,output,strlen(output),0);
}
 void delay(){
     int c = 1, d = 1;

     for ( c = 1 ; c <= 10000 ; c++ )
         for ( d = 1 ; d <= 10000 ; d++ )
         {}
 }
