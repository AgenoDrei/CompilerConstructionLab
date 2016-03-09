%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
void yyerror(char *message);
int error = -1;
%}

%start S

%union {
	float reell;
	int integer;
}
%token END
%token OPEN_BRACKET
%token CLOSE_BRACKET
%token CLOSE_SQUARE_BRACKET
%token OPEN_SQUARE_BRACKET
%token RULE_OPERATOR
%token IS
%token EQUAL
%token UNEQUAL
%token GREATER_EQUAL
%token SMALER_EQUAL
%token SMALLER
%token GREATER
%token NAME
%token VARIABLE
%token FLOAT INT
%token COMMA
%token PIPE 
%token DOT
%token UNKNOWN
%token NUMBER

%type <float> NUMBER

%%

S : 
| S EXPRESSION;

EXPRESSION : END;



%%

int main(int argc, char **argv){
	yyparse();
	return 0;
}

void yyerror(char *message) {
	printf("ERROR: ");
	printf("%s\n", message);
}
