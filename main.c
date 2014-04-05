#include <stdio.h>
#include <stdlib.h>

#define LEXICAL_ERROR 	1
#define SYNTAX_ERROR 	2

extern int yyparse();

extern FILE* yyin;

void lexerror(int);
void yyerror(const char*);
void bailout(const char*, int);

int main(int argc, char **argv)
{
	/* decide whether to to read from file or from input stream */
	if( argc > 1)
	{
		yyin = fopen(argv[1],"r");
	} 
	else 
	{
		yyin = stdin;
	}

	yyparse();

	/* if we reached this, everything went well */
	exit(EXIT_SUCCESS);
}

void yyerror(const char *msg)
{
	fprintf(stderr, "%s\n", msg);
	bailout("exiting...", SYNTAX_ERROR);
}

void lexerror(int line)
{
	fprintf(stderr, "lexical error in line %d.\n", line);
	bailout("exiting...", LEXICAL_ERROR);
}

void bailout(const char *msg, int status)
{
	fprintf(stderr, "%s\n", msg);
	exit(status);
}