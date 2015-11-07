%{

#define YYDEBUG 0 // Ojo desactivar

void yyerror (char *s);

%}

%union {char* txt ; char* type;} 
%start 
