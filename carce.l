%{
#include "y.tab.h"
%}



%option nounput yylineno
%option caseless


define 			define
as			as
blocks			blocks
value			value
set			set
out			out
straight		straight
go			go
turn			turn
till			till
blocks			blocks
back			back
left			left
right			right
going			going
times			times
keep			keep
keepend			keepend
rest			rest
for 			for
forend			forend
start 			start
stop			stop
skip			skip
lower			[a-z]
upper			[A-Z]
letter			{upper}|{lower}
lowerdash		_
ws		        [ \t]+
digit			[0-9]
posnum			{digit}+
name 			{letter}({digit}|{lowerdash}|{letter})*

%%

/;		return END;

\+		return ADD;
\-		return SUB; 
\*		return MUL;
\/		return DIV;

\(		return LEFTP;
\)		return RIGHTP;
\[		return LEFTB;
\]		return RIGHTB;

%%

int yywrap() { return 1; }
