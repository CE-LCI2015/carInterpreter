//
// Created by Pablo Rodriguez Quesada on 11/13/15.
//

#ifndef CAR_SYMTABLE_H
#define CAR_SYMTABLE_H


struct symbol {
    struct symbol* next;
    char* name;
    char* type;
    void* value;
}symbol;

struct symbol * head;
struct symbol * tail;

int defineVariable(char* name, char* type);
int setVariable(char* name, void* value);
void * getVariable(char* name);
char* getType(char* name);

#endif //CAR_SYMTABLE_H
