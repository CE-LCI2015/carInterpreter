carCE: lex.yy.c y.tab.c telnet.c
	gcc -g lex.yy.c y.tab.c telnet.c -o carCE

lex.yy.c: y.tab.c carce.l
	lex carce.l

y.tab.c: carce.y
	yacc -d carce.y

clean: 
	rm -f lex.yy.c y.tab.c y.tab.h carce
