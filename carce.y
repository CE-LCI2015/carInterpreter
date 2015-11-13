%{
#include <stdio.h>
#define YYDEBUG 0 // Ojo desactivar

void yyerror (char *s);
int yylex();
extern int yylineno;
extern FILE *yyin;
%}

%union {char* txt ; int number;} 
%start instruction
%token DEFINE AS BLOCKS VALUE SET OUT STRAIGHT GO TURN TILL BACK LEFT RIGHT GOING TIMES RIGHTB ON OFF
%token KEEP KEEPEND REST FOR FOREND START STOP SKIP END ADD SUB MUL DIV LEFTP RIGHTP LEFTB NUMBER NAME
%token WHEN WHENEND THEN EQU NEQU IF
//%type <number> expression
%%

instruction: 
		| instruction instructions END
;

instructions : 	  define
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
;

terminalexpression: NUMBER | NAME ;

expression: 	  terminalexpression
		| terminalexpression ADD terminalexpression
		| terminalexpression SUB terminalexpression
		| terminalexpression MUL terminalexpression
		| terminalexpression DIV terminalexpression
;

booleanexpression:	  expression EQU expression
			| expression NEQU expression
;

define: DEFINE NAME AS BLOCKS;

setout: VALUE expression SET OUT FOR NAME;

ydirection: STRAIGHT | BACK;

xdirection: LEFT | RIGHT;

go: 	  GO ydirection
	| GO ydirection TILL expression BLOCKS;

turn: TURN xdirection;

if: IF booleanexpression THEN instruction
;

keep: KEEP GOING instruction IF booleanexpression THEN SKIP END instruction KEEPEND
;

when: WHEN booleanexpression THEN instruction WHENEND;
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
