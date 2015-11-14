%{
#include "y.tab.h"
#include <string.h>
%}



%option nounput yylineno
%option caseless



lower			[a-z]
upper			[A-Z]
letter			{upper}|{lower}
lowerdash		_
ws			[ \t]+
digit			[0-9]
posnum			{digit}+
name			{letter}({digit}|{lowerdash}|{letter})*

%%
define			return DEFINE;
as			return AS;
keep			return KEEP;
going			return GOING;
keepend			return KEEPEND;
rest			return REST;
for			return FOR;
forend			return FOREND;
when			return WHEN;
whenend			return WHENEND;
then			return THEN;
till			return TILL;
if			return IF;

blocks			return BLOCKS;
value			return VALUE;
set			return SET;
out			return OUT;

go			return GO;
turn			return TURN;

straight		return STRAIGHT;
back			return BACK;
left			return LEFT;
right			return RIGHT;

times			return TIMES;

start			return START;
stop			return STOP;
skip			return SKIP;
on			return ON;
off			return OFF;

;			return END;

\=			return EQU;
!\=			return NEQU;
\+			return ADD;
\-			return SUB; 
\*			return MUL;
\/			return DIV;

\(			return LEFTP;
\)			return RIGHTP;
\[			return LEFTB;
\]			return RIGHTB;
{posnum}		{yylval.number=atoi(yytext); return NUMBER;}
{name}			{yylval.txt= malloc(sizeof(char) * strlen(yytext)); strcpy(yylval.txt, yytext); return NAME;}
{ws}			;
\n			;

%%

int yywrap() { return 1; }
