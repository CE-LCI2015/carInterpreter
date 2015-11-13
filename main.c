//
// Created by Pablo Rodriguez Quesada on 11/13/15.
//
#include <stdlib.h>
#include <stdio.h>
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

}