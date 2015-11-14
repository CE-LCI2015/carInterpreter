%{
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

#define DINT(NAME,VAL)  void* NAME = malloc(sizeof(int)); *(int*)NAME = VAL;
#define SINT(NAME,VAL)  *(int*)NAME = VAL;
#define GINT(NAME) *(int*) NAME
#define YYDEBUG 1 // Ojo desactivar
#define VERBOSE 1
#define verbose(fmt, ...) \
		do { if (VERBOSE) fprintf(stderr, fmt, __VA_ARGS__); } while (0)


void yyerror (char *s);
int yylex();
extern int yylineno;
extern FILE *yyin;

struct symbol {
	struct symbol* next;
	char* name;
	char* type;
	void* value;
};



struct symbol * head;
struct symbol * tail;

int defineVariable(char* name, char* type);
int setVariable(char* name, void* value);
void * getVariable(char* name);
char* getType(char* name);

%}

%union {char* txt ; int number; nodeType *nPtr;} 
%start root
%token DEFINE AS VALUE SET OUT STRAIGHT GO TURN TILL BACK LEFT RIGHT GOING TIMES RIGHTB ON OFF
%token KEEP KEEPEND REST FOR FOREND START STOP SKIP END ADD SUB MUL DIV LEFTP RIGHTP LEFTB
%token WHEN WHENEND THEN EQU NEQU IF
%token <txt> NAME
%token <number> NUMBER BLOCKS

%type <number> terminalexpression expression xdirection ydirection

%%
root:
	| instruction
;
instruction: 
		instruction instructions END
		| instructions END
;

instructions : 	  expression {printf("%d\n",$1);}
/*
		| define
		| setout 
		| go
		| turn
		| keep
		| when
		| rest
		| if
		| START
		| STOP
		| TURN ON
		| TURN OFF
*/
;

terminalexpression: 	  NUMBER {$$ = $1;} 
			| NAME {$$ = *(int*)getVariable($1);}
;

expression: 	  terminalexpression {$$ = $1;}
		| terminalexpression ADD terminalexpression {$$ = $1 + $3;}
		| terminalexpression SUB terminalexpression {$$ = $1 - $3;}
		| terminalexpression MUL terminalexpression {$$ = $1 * $3;}
		| terminalexpression DIV terminalexpression {$$ = $1 / $3;}
		| expression EQU expression {$$ = $1 == $3;}
		| expression NEQU expression {$$ = $1 != $3;}
;

define: DEFINE NAME AS BLOCKS {defineVariable($2,"blocks");verbose("Defining %s as blocks\n",$2);}
;
setout: VALUE expression SET OUT FOR NAME {DINT (exp,$2) setVariable($6, exp);verbose("Set %s with %d\n",$6,$2);}
; 
ydirection: STRAIGHT {$$ = 1;} | BACK {$$ = 0;} ;

xdirection: LEFT {$$ = 0;} | RIGHT{$$ = 1;} ;

go: 	  GO ydirection {verbose("Go %s\n",$2 ? "straight" : "back");}
	| GO ydirection TILL expression BLOCKS {verbose("Go %s for %d blocks\n",$2 ? "straight" : "back",$4);}
;

turn: TURN xdirection {verbose("Turn %s\n",$2 ? "right" : "left");}
;
if: IF expression THEN instruction
;

keep: KEEP GOING instruction IF expression THEN SKIP END instruction KEEPEND
;


when: WHEN expression THEN instruction WHENEND;

rest: REST FOR expression;

%%

int main(){
	yyin=fopen("input_file","r");
	yyparse();
	printf("Done!\n");
	return 0;
}
void yyerror(char *s){
	
	printf("%s around line no %d\n",s, yylineno );
	
}

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

