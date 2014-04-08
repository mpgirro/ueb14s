
%{
	
#include <stdio.h>
#include <stdlib.h>

#define LEXICAL_ERROR 	1
#define SYNTAX_ERROR 	2

extern int yylex();
extern int yyparse();

extern FILE* yyin;

void yyerror(const char *msg);
void lexerror(int);


%}

%union {
	char *sval;
	signed long nval;
}

%token STRUCT
%token END
%token FUNC
%token RETURN
%token WITH
%token DO
%token LET
%token IN
%token COND
%token THEN
%token NOT
%token OR

%token NOTEQUAL		/* for <> */

%token <nval> NUMBER
%token <sval> IDENTIFIER

%%
/*
Program: { Def ';' }
	;
*/
Program: /* empty */
	| Program Def ';'
	; 

Def: Funcdef
	| Structdef
	;
	
Idlist:	/* empty */
	| Idlist IDENTIFIER
	;

Structdef: STRUCT IDENTIFIER ':' 	/* Strukturname */ 
	/*{IDENTIFIER}*/ Idlist					/* Felddefinition */
	END
	;

Funcdef: FUNC IDENTIFIER 		/* Funktionsname */
	'(' /*{ IDENTIFIER }*/ Idlist ')' 		/* Parameterdefinition */
	Stats END
	;

/*Stats: { Stat ';' }*/
Stats: /* empty */
	| Stats Stat ';' 
	;
	
/*{ Expr THEN Stats END ';' }*/
Condlist:  /* empty */ 
	| Condlist Expr THEN Stats END ';'
	;

/*{ IDENTIFIER '=' Expr ';' }*/
Letlist:  /* empty */
	| Letlist Assignment
	; 
	 
Stat: RETURN Expr
	| COND /*{ Expr THEN Stats END ';' }*/ Condlist END 
	| LET /*{ IDENTIFIER '=' Expr ';' }*/ Letlist IN Stats END
	| WITH Expr ':' IDENTIFIER DO Stats END
	| Assignment
/*	| Lexpr '=' Expr 	/* Zuweisung */ 
	| Term
	;
	
/* Schreibender Variablenzugriff */ 
Assignment: IDENTIFIER '=' Expr ';'
	
Lexpr: Term '.' IDENTIFIER 	/* Schreibender Feldzugriff */ 
	/*| IDENTIFIER 			/* Schreibender Variablenzugriff */ 
	;
	
Notexpr: '-' Term
	| NOT Term
	| '-' Notexpr
	| NOT Notexpr
	;
	
Addexpr: Term '+' Term
	| Addexpr '+' Term
	;
	
Mulexpr: Term '*' Term
	| Mulexpr '*' Term
	;
	
Orexpr: Term OR Term
	| Orexpr OR Term
	;

Expr: /* Notexpr /*{ NOT | '-' }*/  Notexpr
	| /* Term /* { '+' Term }*/		Addexpr
	| /* Term /* { '*' Term }*/		Mulexpr
	| /* Term /* { OR Term }*/		Orexpr
	| Term '(' '>' | '<>' ')' Term
	| Term
	;
	
Exprlist: /* empty */
	| Exprlist Expr ','
	; 
	
Arg: /* empty */
	| Expr
	; 
		
Term: '(' Expr ')'
	| NUMBER
	| Term '.' IDENTIFIER 	 /* Lesender Feldzugriff */
	| IDENTIFIER			 /* Lesender Variablenzugriff */
/*	| IDENTIFIER '(' ')'	 /* Funktionsaufruf mit leerer Argumentenliste  */
	| IDENTIFIER '(' /*{ Expr ',' }*/ Exprlist Arg ')' 	/* Funktionsaufruf */ 
	;

%%

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

/* we overwrite this yacc/bison function to return the correct exit code */
void yyerror(const char *msg)
{
	(void) fprintf(stderr, "%s\n", msg);
	exit(SYNTAX_ERROR);
}

void lexerror(int line)
{
	(void) fprintf(stderr, "lexical error encountered in line %i\n", line);
	exit(LEXICAL_ERROR);
}
