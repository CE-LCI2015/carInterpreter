%{
#include "y.tab.h"
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
blocks			return BLOCKS;
value			return VALUE;
set			return SET;
out			return OUT;
straight		return STRAIGHT;
go			return GO;
turn			return TURN;
till			return TILL;
back			return BACK;
left			return LEFT;
right			return RIGHT;
going			return GOING;
times			return TIMES;
keep			return KEEP;
keepend			return KEEPEND;
rest			return REST;
for			return FOR;
forend			return FOREND;
start			return START;
stop			return STOP;
skip			return SKIP;

/;			return END;

\+			return ADD;
\-			return SUB; 
\*			return MUL;
\/			return DIV;

\(			return LEFTP;
\)			return RIGHTP;
\[			return LEFTB;
\]			return RIGHTB;
{posnum}		{return NUMBER;}
{name}			{return NAME;}


%%

int yywrap() { return 1; }
