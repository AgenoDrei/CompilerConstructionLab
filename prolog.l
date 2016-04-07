%option noyywrap
%option yylineno
%{

unsigned int line = 1;

//TODO: Add +/-/*
#include "y.tab.h"
%}
%%

\( {
#ifdef DEBUG_FLEX
	printf("Open Bracket \n");
#endif
	return OPEN_BRACKET;
}

\) {
#ifdef DEBUG_FLEX
        printf("Close Bracket \n");
#endif
        return CLOSE_BRACKET;
}

:- {
#ifdef DEBUG_FLEX
        printf("Rule Operator \n");
#endif
        return RULE_OPERATOR;
}

\* {
#ifdef DEBUG_FLEX
        printf("Multiplication \n");
#endif
        return TIMES;	
}

\+ {
#ifdef DEBUG_FLEX
	printf("Plus \n");
#endif
        return PLUS;   
}

- {
#ifdef DEBUG_FLEX
	printf("Minus \n");
#endif
        return MINUS;   
}

is {
#ifdef DEBUG_FLEX
        printf("IS \n");
#endif
        return IS;
}

([1-9][0-9]*)|0 {
#ifdef DEBUG_FLEX
	printf("integer number\n");
#endif
        yylval.integer=atof(yytext);
        return NUMBER;
}

([1-9][0-9]*|0)\.[0-9]+|0 {
#ifdef DEBUG_FLEX
	printf("float number\n");
#endif
        yylval.reell=atof(yytext);
        return NUMBER;
}

= {
#ifdef DEBUG_FLEX
        printf("EQUAL \n");
#endif
        return EQUAL;
}

\\= {
#ifdef DEBUG_FLEX
        printf("UNEQUAL \n");
#endif
        return UNEQUAL;
}

>= {
#ifdef DEBUG_FLEX
        printf("GREATER EQUAL \n");
#endif
        return GREATER_EQUAL;
}

=< {
#ifdef DEBUG_FLEX
        printf("SMALLER EQUAL \n");
#endif
        return SMALLER_EQUAL;
}

\< {
#ifdef DEBUG_FLEX
        printf("SMALLER \n");
#endif
        return SMALLER;
}

> {
#ifdef DEBUG_FLEX
        printf("Greater \n");
#endif
        return GREATER;
}


[a-z]+ {
        //printf("name: %s \n", yytext);
	yylval.name= strdup(yytext);
        return NAME;
}

[A-Z][A-Z0-9]* {
        //printf("variable: %s \n", yytext);
        yylval.variable = strdup(yytext);
	return VARIABLE;
}

\[ {
#ifdef DEBUG_FLEX
        printf("open square bracket \n");
#endif
        return OPEN_SQUARE_BRACKET;
}

\] {
#ifdef DEBUG_FLEX
        printf("close square bracket \n");
#endif
        return CLOSE_SQUARE_BRACKET;
}

\, {
#ifdef DEBUG_FLEX
        printf("Comma  \n");
#endif
        return COMMA;
}

\| {
#ifdef DEBUG_FLEX
        printf("Pipe \n");
#endif
        return PIPE;
}

\. {
#ifdef DEBUG_FLEX
        printf("Dot \n");
#endif
        return DOT;
}

<<EOF>> {
	yyterminate();
	return END;
}

"\n" {
#ifdef DEBUG_FLEX
	printf("line: %i \n", line);
#endif
	line++;
}

"\r\n" {
#ifdef DEBUG_FLEX
	printf("line: %i \n", line);
#endif
	line++;
}
"\t" ;

[ ]+ ;

. printf("what? %d\n", (int)*yytext);

%%
