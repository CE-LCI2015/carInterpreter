//
// Created by Pablo Rodriguez Quesada on 11/13/15.
//
#include <stdlib.h>
#include <stdio.h>
#include <string.h>    //strlen
#include <sys/socket.h>    //socket
#include <arpa/inet.h> //inet_addr


#include "SymTable.h"
#define DINT(NAME,VAL)  void* NAME = malloc(sizeof(int)); *(int*)NAME = VAL;
#define SINT(NAME,VAL)  *(int*)NAME = VAL;
#define GINT(NAME) *(int*) NAME
int main ()
{
    defineVariable("hola");
    DINT (num, 5)
    setVariable("hola",num);
    SINT (num , 7)
    printf("%d", GINT(getVariable("hola")) );
    defineVariable("hol");
    DINT (nu, 5)
    setVariable("hol",nu);
    printf("%d", GINT(getVariable("hol")) );
    defineVariable("ho");
    DINT (n, 4)
    setVariable("ho",n);
    printf("%d", GINT(getVariable("ho")) );


    ////////////////////////////7Telnet///////////////////////////
    int sock;
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

    //keep communicating with server
    while(1)
    {
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