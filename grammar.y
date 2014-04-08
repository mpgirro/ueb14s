
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
Program:
	| Program Def ';'
	; 

Def: Funcdef
	| Structdef
	;
	
Idlist:	
	| IDENTIFIER
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
Stats: 
	| Stats ';' 
	;
	
Condlist:  Expr THEN Stats END ';'
	| Condlist Expr THEN Stats END ';'
	;

Letlist: IDENTIFIER '=' Expr ';'
	| Letlist IDENTIFIER '=' Expr ';'
	; 
	 
Stat: RETURN Expr
	| COND /*{ Expr THEN Stats END ';' }*/ Condlist END 
	| LET /*{ IDENTIFIER '=' Expr ';' }*/ Letlist IN Stats END
	| WITH Expr ':' IDENTIFIER DO Stats END
	| Lexpr '=' Expr 	/* Zuweisung */ 
	| Term
	;
	
Lexpr: IDENTIFIER 			/* Schreibender Variablenzugriff */ 
	Term '.' IDENTIFIER 	/* Schreibender Feldzugriff */
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

Expr: /*{ NOT | '-' }  Term*/	Notexpr
	| /*Term { '+' Term }*/		Addexpr
	| /*Term { '*' Term }*/		Mulexpr
	| /*Term { OR Term }*/		Orexpr
	| Term '(' '>' | '<>' ')' Term
	;
	
Exprlist: Expr
	| Exprlist ',' Expr
	; 
		
Term: '(' Expr ')'
	| NUMBER
	| Term '.' IDENTIFIER 	 /* Lesender Feldzugriff */
/*	| IDENTIFIER			 /* Lesender Variablenzugriff */
	| IDENTIFIER '(' /*{ Expr ',' }*/ Exprlist '[' Expr ']' ')' 	/* Funktionsaufruf */ 
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
