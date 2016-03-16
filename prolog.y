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
%token SMALLER_EQUAL
%token SMALLER
%token GREATER
%token NAME
%token VARIABLE
%token FLOAT INT
%token COMMA
%token PIPE 
%token DOT
%token NUMBER

%type <float> NUMBER

%%

S : HEAD DOT END
| HEAD RULE_OPERATOR TAIL END;

HEAD : NAME OPEN_BRACKET PARAMETER_LIST CLOSE_BRACKET;

PARAMETER_LIST : PARAMETER
| PARAMETER COMMA PARAMETER_LIST;

PARAMETER: NAME
| VARIABLE
| NUMBER;

TAIL : DOT;

%%

int main(int argc, char **argv){
	yyparse();
	return 0;
}

void yyerror(char *message) {
	printf("ERROR: ");
	printf("%s\n", message);
}
