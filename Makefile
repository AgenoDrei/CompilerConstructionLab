# A Makefile for simple lex and yacc examples

# Comment out the proper lines below according to the scanner and
# parser generators available in your system

LEX = flex
# = bison -d
YACC = bison -d -b y -Wall

# We assume that your C-compiler is called cc

CC = gcc

# calc is the final object that we will generate, it is produced by
# the C compiler from the y.tab.o and from the lex.yy.o

cc1ab: y.tab.c lex.yy.c
		$(CC) y.tab.c lex.yy.c -lfl -lm -o cc1ab

# These dependency rules indicate that (1) lex.yy.o depends on
# lex.yy.c and y.tab.h and (2) lex.yy.o and y.tab.o depend on calc.h.
# Make uses the dependencies to figure out what rules must be run when
# a file has changed.

lex.yy.o: lex.yy.c y.tab.h
lex.yy.o y.tab.o: y.tab.h

## This rule will use yacc to generate the files y.tab.c and y.tab.h
## from our file cc1ab.y

y.tab.c y.tab.h: prolog.y
	$(YACC) -v prolog.y

## this is the make rule to use lex to generate the file lex.yy.c from
## our file calc.l

lex.yy.c: prolog.l
	$(LEX) prolog.l

## Make clean will delete all of the generated files so we can start
## from scratch

clean:
	-rm -f *.o lex.yy.c *.tab.*  cc1ab *.output
