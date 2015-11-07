SQLce: lex.yy.c y.tab.c
	gcc -g lex.yy.c y.tab.c xml.c list.c -o carCE

lex.yy.c: y.tab.c carce.l
	lex carce.l

y.tab.c: carce.y
	yacc -d carce.y

clean: 
	rm -f lex.yy.c y.tab.c y.tab.h carce
