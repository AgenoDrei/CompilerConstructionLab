%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <iostream>
#include "inc/Problem.h"
#include "inc/SubProblem.h"

void yyerror(const char *message);
int yylex(void);
int error = -1;
extern FILE* yyin;
extern int yylineno;

Problem* currentProblem = new Problem();

%}

%error-verbose

%start S

%union {
	float reell;
	int integer;
	char* variable;
	char* name;
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
%type <variable> VARIABLE 
%type <name> NAME

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
| END {if(currentProblem) { delete currentProblem; }};

AFTER_HEAD: RULE_FINISHED S
| RULE RULE_FINISHED S;

RULE_FINISHED: DOT { delete currentProblem; currentProblem = new Problem();}

RULE: RULE_OPERATOR TAIL;

HEAD : FACT { currentProblem->setHeadCompleted();};

FACT : NAME OPEN_BRACKET PARAMETER_LIST CLOSE_BRACKET {
     printf("Name: %s\n", $1);
};

PARAMETER_LIST : PARAMETER
| PARAMETER COMMA PARAMETER_LIST;

PARAMETER: NAME {printf("Name: %s\n", $1);} 
| VARIABLE {
	printf("Variable: %s\n", $1);
	if(currentProblem->getHeadCompleted()) {
		currentProblem->getCurrentSubProblem()->addVariable($1);
	} else {
		currentProblem->addVariable($1);
	}
} 
| NUMBER
| LIST;

// crazyStuff(simon, true).
// crazyStuff(nils, false).
// crazyStuff(NAME, IS_STUPID) :- otherStuff(NAME) = IS_STUPID. // (otherStuff(NAME) AND IS_STUPID) OR (!otherStuff(NAME) AND !IS_STUPID)
//isStupid(nils).
// crazyStuff(NAME) :- otherStuff(NAME), isStupid(NAME). // otherStuff(NAME) AND isStupid(NAME)

TAIL : CHAIN; // a(X,Y), b(X,Z)

START_FACT : %empty {
	printf("Create Subproblem\n");
	currentProblem->newSubProblem();
};

CHAIN : START_FACT FACT
| EXPRESSION
| START_FACT FACT COMMA CHAIN
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

int main(int argc, char **argv) {
	try {
		if(argc == 1) {
			yyparse();
		} else {
			yyin = fopen(argv[1], "r");
			yyparse();
		}
	} catch(std::string message) {
		std::cerr<<message<<std::endl;
		return -1;
	}
	return 0;
}

void yyerror(const char *message) {
	printf("%d: %s \n", yylineno, message);
}
