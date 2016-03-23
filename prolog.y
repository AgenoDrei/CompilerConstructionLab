%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *message);
int error = -1;
FILE* yyin;
int yylineno;
%}

%error-verbose

%start S

%union {
	float reell;
	int integer;
}
 
%token END 0 
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
%token TIMES
%token PLUS
%token MINUS
%token NAME
%token VARIABLE
%token FLOAT INT // NOT USED?!
%token COMMA
%token PIPE 
%token DOT
%token NUMBER

%type <float> NUMBER

%left MINUS
%left PLUS
%left TIMES
%left GREATER
%left SMALLER
%left GREATER_EQUAL
%left SMALLER_EQUAL
%left EQUAL
%left UNEQUAL
%left IS

%%

S : HEAD AFTER_HEAD
| END;

AFTER_HEAD: DOT S
| RULE DOT S

RULE: RULE_OPERATOR TAIL;

HEAD : FACT;

FACT : NAME OPEN_BRACKET PARAMETER_LIST CLOSE_BRACKET;

PARAMETER_LIST : PARAMETER
| PARAMETER COMMA PARAMETER_LIST;

PARAMETER: NAME
| VARIABLE
| NUMBER
| LIST;

// crazyStuff(simon, true).
// crazyStuff(nils, false).
// crazyStuff(NAME, IS_STUPID) :- otherStuff(NAME) = IS_STUPID. // (otherStuff(NAME) AND IS_STUPID) OR (!otherStuff(NAME) AND !IS_STUPID)
//isStupid(nils).
// crazyStuff(NAME) :- otherStuff(NAME), isStupid(NAME). // otherStuff(NAME) AND isStupid(NAME)

TAIL : CHAIN; // a(X,Y), b(X,Z)

CHAIN : FACT
| EXPRESSION
| FACT COMMA CHAIN
| EXPRESSION COMMA CHAIN;

EXPRESSION : NUMBER
| VARIABLE
| EXPRESSION GREATER EXPRESSION
| EXPRESSION SMALLER EXPRESSION
| EXPRESSION GREATER_EQUAL EXPRESSION
| EXPRESSION SMALLER_EQUAL EXPRESSION
| EXPRESSION EQUAL EXPRESSION
| EXPRESSION MINUS EXPRESSION
| EXPRESSION PLUS EXPRESSION
| EXPRESSION TIMES EXPRESSION
| MINUS EXPRESSION
| EXPRESSION UNEQUAL EXPRESSION 
| OPEN_BRACKET EXPRESSION CLOSE_BRACKET
| EXPRESSION IS EXPRESSION; 

// LISTS
LIST : OPEN_SQUARE_BRACKET LIST_BODY CLOSE_SQUARE_BRACKET;

LIST_BODY : LIST_HEAD PIPE LIST_TAIL
| LIST_HEAD
|%empty; //Empty list []

LIST_HEAD : PARAMETER_LIST;

LIST_TAIL : PARAMETER;

%%

int main(int argc, char **argv){
	if(argc == 1) {
		yyparse();
	} else {
		yyin = fopen(argv[1], "r");
		yyparse();
	}
	return 0;
}

void yyerror(const char *message) {
	printf("%d: %s \n", yylineno, message);
}
