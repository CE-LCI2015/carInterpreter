%{
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include "carStructs.h"

#define DINT(NAME,VAL)  void* NAME = malloc(sizeof(int)); *(int*)NAME = VAL;
#define SINT(NAME,VAL)  *(int*)NAME = VAL;
#define GINT(NAME) *(int*) NAME
#define EXECUTE(INDEX) execute(p->opr.op[INDEX])
#define YYDEBUG 0
#define VERBOSE 0
#define verbose(fmt, ...) \
		do { if (VERBOSE) fprintf(stderr, fmt, __VA_ARGS__); } while (0)


void yyerror (char *s);
int yylex();
extern int yylineno;
extern FILE *yyin;



struct symbol * head;
struct symbol * tail;

int defineVariable(char* name, char* type);
int setVariable(char* name, void* value);
void * getVariable(char* name);
char* getType(char* name);

nodeType *opr(int oper, int nops, ...);
nodeType *id(char* i);
nodeType *con(int value);
//void freeNode(nodeType *p);
int execute(nodeType *p);
%}

%union {char* txt ; int number; struct nodeTypeTag* nPtr;} 
%start root
%token DEFINE AS VALUE SET OUT STRAIGHT GO TURN TILL BACK LEFT RIGHT GOING TIMES RIGHTB ON OFF
%token KEEP KEEPEND REST FOR FOREND START STOP SKIP END ADD SUB MUL DIV LEFTP RIGHTP LEFTB
%token WHEN WHENEND THEN EQU NEQU ENDIF IF ELSE LESS BIG WALK
%token PRINT
%token <txt> NAME
%token <number> NUMBER BLOCKS

%type <number>  xdirection ydirection
%type <nPtr> instructionaux instructions define terminalexpression expression setout turn if when for keep go rest
%%
root:
	| instruction 
;
instruction: 
		|instruction instructions END { execute($2);}
;

instructionaux: {$$ = opr(SKIP,0);}
		|instructionaux instructions END {$$ = opr(BLOCKS,2,$1,$2);}
;
instructions : PRINT expression {$$ = opr(PRINT,1,$2);}
		| define {$$=$1;}
		| setout {$$ = $1;}
		| turn {$$ = $1;}
		| if {$$ = $1;}
		| when {$$ = $1;}
		| for {$$ = $1;}
		| keep {$$ = $1;}
		| go {$$ = $1;}
		| rest {$$ = $1;}
		| START {$$ = opr(START,0);}
		| STOP {$$ = opr(STOP,0);}
		| TURN ON {$$ = opr(ON,0);}
		| TURN OFF {$$ = opr(OFF,0);}

;

terminalexpression: 	  NUMBER { $$ = con($1); }
			| NAME { $$ = id($1); }
;

expression: 	  terminalexpression {$$ = $1;}
		| terminalexpression ADD terminalexpression { $$ = opr(ADD, 2, $1, $3); }
		| terminalexpression SUB terminalexpression { $$ = opr(SUB, 2, $1, $3); }
		| terminalexpression MUL terminalexpression { $$ = opr(MUL, 2, $1, $3); }
		| terminalexpression DIV terminalexpression { $$ = opr(DIV, 2, $1, $3); }
		| expression EQU expression { $$ = opr(EQU, 2, $1, $3); }
		| expression NEQU expression { $$ = opr(NEQU, 2, $1, $3); }
		| expression LESS expression { $$ = opr(LESS, 2, $1, $3); }
		| expression BIG expression { $$ = opr(BIG, 2, $1, $3); }
;

define: DEFINE NAME AS BLOCKS { $$ = opr(DEFINE, 1, id($2));}
;
setout: VALUE expression SET OUT FOR NAME {$$ = opr(SET, 2, id($6), $2);}
; 
ydirection: STRAIGHT {$$ = 1;} | BACK {$$ = 0;} ;

xdirection: LEFT {$$ = 0;} | RIGHT{$$ = 1;} ;

go: 	  GO ydirection {$$ = opr(GO,1,con($2));}
	| GO ydirection TILL expression BLOCKS {$$ = opr(GO,2,con($2),$4);}
;

turn: TURN xdirection {$$ = opr(TURN,1,con($2));}
;

if: IF expression THEN instructionaux ENDIF {$$ = opr(IF,2,$2,$4);}
	|IF expression THEN instructionaux ELSE instructionaux ENDIF {$$ = opr(IF,3,$2,$4,$6);}
;

when: WHEN expression THEN instructionaux WHENEND {$$ = opr(WHEN,2,$2,$4);}
;

keep: KEEP GOING instructionaux IF expression THEN SKIP END ENDIF END instructionaux KEEPEND {$$ = opr(KEEP,3,$3,$5,$11);}
	| KEEP GOING instructionaux SKIP END instructionaux KEEPEND {$$ = opr(KEEP,2,$3,$6);}
;

for:  FOR expression TIMES LEFTB WALK expression NAME RIGHTB instructionaux FOREND {$$ = opr(FOR,4,$2,$6,id($7),$9);}
; 

rest: REST FOR expression {$$ = opr(REST, 1, $3);}
;
%%

int main(){
	#if YYDEBUG
		yydebug = 1;
	#endif
	yyin=fopen("input_file","r");
	yyparse();
	printf("Done!\n");
	return 0;
}
void yyerror(char *s){
	
	printf("%s around line no %d\n",s, yylineno );
	
}


nodeType *con(int value) {
	nodeType *p;

	/* allocate node */
	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory");

	/* copy information */
	p->type = typeCon;
	p->con.value = value;

	return p;
}

nodeType *id(char* i) {
	nodeType *p;
	/* allocate node */
	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory");

	/* copy information */
	p->type = typeId;
	p->id.i = i;

	return p;
}

nodeType *opr(int oper, int nops, ...) {
	va_list args;
	nodeType *p;
	int i;

	/* allocate node */
	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory");
	if ((p->opr.op = malloc(nops * sizeof(nodeType *))) == NULL)
		yyerror("out of memory");

	/* copy information */
	p->type = typeOpr;
	p->opr.oper = oper;
	p->opr.nops = nops;
	va_start(args, nops);
	for (i = 0; i < nops; i++)
		p->opr.op[i] = va_arg(args, nodeType*);
	va_end(args);
	return p;
}
int defineVariable(char *name, char * type) {
	verbose("Defining %s\n",name);
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
	verbose("Seting %s with %d\n",name,GINT(value));
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



int execute(nodeType *p) {
	if (!p) return 0;
	switch(p->type) {
	case typeCon:		return p->con.value;
	case typeId:		return * (int*)getVariable(p->id.i);
	case typeOpr:
		switch(p->opr.oper) {
			//case SKIP : return 0;
			case BLOCKS: {EXECUTE(0); EXECUTE(1); return 0;}
			case PRINT: return printf("Printing...\t%d\n",EXECUTE(0));
			case DEFINE: return defineVariable(p->opr.op[0]->id.i,"");
			case SET: 
			{
				void* val = malloc(sizeof(int)); 
				*(int*)val = EXECUTE(1);
				return setVariable(p->opr.op[0]->id.i,val);
			}
			case ADD: return EXECUTE(0) + EXECUTE(1);
			case SUB: return EXECUTE(0) - EXECUTE(1);
			case MUL: return EXECUTE(0) * EXECUTE(1);
			case DIV: return EXECUTE(0) / EXECUTE(1);
			case NEQU: return EXECUTE(0) != EXECUTE(1);
			case EQU: return EXECUTE(0) == EXECUTE(1);
			case LESS: return EXECUTE(0) < EXECUTE(1);
			case BIG: return EXECUTE(0) > EXECUTE(1);
			case TURN: {verbose("Turn %s\n",EXECUTE(0) ? "right" : "left"); return 0;}
			case GO:  {
				if (p->opr.nops > 1)
					verbose("Go %s\n",EXECUTE(0) ? "straight" : "back");
				else verbose("Go %s %d blocks\n",EXECUTE(0) ? "straight" : "back",EXECUTE(1));
				return 0;
			}
			
			
			case IF:
			{
				if (EXECUTE(0))
					EXECUTE(1);
				else if (p->opr.nops > 2)
					EXECUTE(2);
			return 0;
			}
			case WHEN:     while(EXECUTE(0)) EXECUTE(1); return 0;
			
			case FOR:
			{
				defineVariable(p->opr.op[2]->id.i,"");
				
				void* val = malloc(sizeof(int)); 
				*(int*)val = EXECUTE(1);
				setVariable(p->opr.op[2]->id.i,val);
				
				for (int i = 0; i<EXECUTE(0);i++)
				{
					execute(p->opr.op[3]);
				}
				return 0;
			}
			
			case KEEP:
			{	if (p->opr.nops== 2) return EXECUTE(0);
				while(1)
				{
					EXECUTE(0);
					if (EXECUTE(1)) break;
					EXECUTE(2);
				}
			}
			
		}
	}
	return 0;
}

