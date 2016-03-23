%option noyywrap
%{

unsigned int line = 1;

//TODO: Add +/-/*
#include "y.tab.h"
%}
%%

\( {
	printf("Open Bracket \n");
	return OPEN_BRACKET;
}

\) {
        printf("Close Bracket \n");
        return CLOSE_BRACKET;
}

:- {
        printf("Rule Operator \n");
        return RULE_OPERATOR;
}

is {
        printf("IS \n");
        return IS;
}

([1-9][0-9]*)|0 {
	printf("integer number\n");
        yylval.integer=atof(yytext);
        return NUMBER;
}

([1-9][0-9]*|0)\.[0-9]+|0 {
	printf("float number\n");
        yylval.reell=atof(yytext);
        return NUMBER;
}

= {
        printf("EQUAL \n");
        return EQUAL;
}

\\= {
        printf("UNEQUAL \n");
        return UNEQUAL;
}

>= {
        printf("GREATER EQUAL \n");
        return GREATER_EQUAL;
}

=< {
        printf("SMALLER EQUAL \n");
        return SMALLER_EQUAL;
}

\< {
        printf("SMALLER \n");
        return SMALLER;
}

> {
        printf("Greater \n");
        return GREATER;
}


[a-z]+ {
        printf("name \n");
        return NAME;
}

[A-Z]+ {
        printf("variable \n");
        return VARIABLE;
}

\[ {
        printf("open square bracket \n");
        return OPEN_SQUARE_BRACKET;
}

\] {
        printf("close square bracket \n");
        return CLOSE_SQUARE_BRACKET;
}

\, {
        printf("Comma  \n");
        return COMMA;
}

\| {
        printf("Pipe \n");
        return PIPE;
}

\. {
        printf("Dot \n");
        return DOT;
}

<<EOF>> {
	printf("END \n");
	return END;
}

"\n" {
	printf("line: %i \n", line);
	line++;
}

"\r\n" {
	printf("line: %i \n", line);
	line++;
}
"\t" ;

[ ]+ ;

. printf("what? %d\n", (int)*yytext);

%%
