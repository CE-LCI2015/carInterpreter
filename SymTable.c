//
// Created by Pablo Rodriguez Quesada on 11/13/15.
//

#include <stdlib.h>
#include <string.h>
#include "SymTable.h"

int defineVariable(char *name, char * type) {
    struct symbol * tmp = malloc(sizeof(struct symbol ));
    tmp->name = malloc(sizeof(char) * strlen(name));
    strcpy(tmp->name,name);
    if (!head)
    {
        head = tmp;
        tail = tmp;
    }
    else
    {
        tail->next = tmp;
        tail = tmp;
    }
    return 0;
}

int setVariable(char *name, void *value) {
    struct symbol * tmp = head;
    while(tmp)
    {
        if (!strcmp((*tmp).name,name))
        {
            tmp->value = value;
            return 0;
        }
        tmp = tmp->next;
    }
    return -1;
}

void* getVariable(char *name) {
    struct symbol * tmp = head;
    while(tmp)
    {
        if (!strcmp(tmp->name,name))
        {

            return  tmp->value;
        }
        tmp = tmp->next;
    }
    return (void*) 0;
}

char* getType(char *name) {
    struct symbol * tmp = head;
    while(tmp)
    {
        if (!strcmp(tmp->name,name))
        {

            return  tmp->type;
        }
        tmp = tmp->next;
    }
    return "";
}
