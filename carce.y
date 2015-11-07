%{

#define YYDEBUG 0 // Ojo desactivar

void yyerror (char *s);

%}

%union {char* txt ; int number} 
%start instruction
%token DEFINE AS BLOCKS VALUE SET OUT STRAIGHT GO TURN TILL BACK LEFT RIGHT GOING TIMES RIGHTB
%token KEEP KEEPEND REST FOR FOREND START STOP SKIP END ADD SUB MUL DIV LEFTP RIGHTP LEFTB NUMBER NAME

%%

instruction: define
;

define: DEFINE NAME AS BLOCKS;

%%

int main(){
	yyparse();
	printf("Done!\n");
	return 0;
}
void yyerror(char *s){
	printf("%s around line no %d\n",s, yylineno );
}
