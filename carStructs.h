//
// Created by Pablo Rodriguez Quesada on 11/14/15.
//

#ifndef CAR_CARSTRUCTS_H
#define CAR_CARSTRUCTS_H

struct symbol {
    struct symbol* next;
    char* name;
    char* type;
    void* value;
};

typedef enum { typeCon, typeId, typeOpr } nodeEnum;

/* constants */
typedef struct {
    int value;                  /* value of constant */
} conNodeType;

/* identifiers */
typedef struct {
    char* i;                      /* subscript to sym array */
} idNodeType;

/* operators */
typedef struct {
    int oper;                   /* operator */
    int nops;                   /* number of operands */
    struct nodeTypeTag **op;	/* operands */
} oprNodeType;

typedef struct nodeTypeTag {
    nodeEnum type;              /* type of node */

    union {
        conNodeType con;        /* constants */
        idNodeType id;          /* identifiers */
        oprNodeType opr;        /* operators */
    };
} nodeType;


#endif //CAR_CARSTRUCTS_H
