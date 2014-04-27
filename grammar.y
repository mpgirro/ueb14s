
%{
	
/* === librarys === */
	
#include <stdio.h>
#include <stdlib.h>

/* === constants === */

#define LEXICAL_ERROR 	1
#define SYNTAX_ERROR 	2
#define OTHER_ERROR		3 	/* use of non visible name, etc. */


/* === enums === */

enum nodetype {
	TYPE_PROG
};

/* === structs === */

/*
struct ast_node{
	char *id;
	int val;
	enum nodetype type;
	struct ast_node *left;
	struct ast_node *right;
};*/

struct symboltable_entry{
	char *name;
	int type
	struct symboltable_entry *next;
} symtabentry;

struct symboltable{
	symtabentry *first;
	symtabentry *last;
} symtab;

/* === function signatures === */

extern int yylex();
extern int yyparse();

/* error handling functions */
void lexerror(int);
void yyerror(const char *msg);
void othererror(void);

/* symbol table maintainance */
symtab *symtab_init(void);
symtab *symtab_add(symtab *tab, char *name);
symtab *symtab_dup(symtab *src, symtab *dest);
void symtab_contains(symtab *tab, char *name);

symtabentry *stentry_init(void);
symtabentry *stentry_append(symtab *tab, symtabentry *entry);
symtabentry *stentry_dup(symtabentry *entry);
symtabentry *stentry_find(symtab *tab, char *name);





/* === global variables === */

extern FILE* yyin;



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

%start start

/* attributes for terminals */
@attributes { int val; } 							NUMBER
@attributes { char *name; } 						IDENTIFIER
	
/* attributes for nonterminals */
@attributes { char *name; } 						Funcdef
@attributes { char *name; } 						Structdef
@attributes { char *name; } 						Fielddef
@attributes { char *name; } 						Vardef

@attributes { symtab *stab; } 						Stats
@attributes { symtab *stab; } 						paramdef
@attributes { symtab *stab; } 						paramlist
	
/* this is to fill the symbol tables - maybe this is not even necessary? */
@traversal @lefttoright @preorder pre

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
	
paramdef:
		@{
			/* empty symbol table */
			@i @paramdef.0.stab@ = symtab_init();
		@}
	| paramlist
		@{
			/* propagate param symtab up the tree */
			@i @paramdef.0.stab@ = @paramlist.0.stab@;
		@}
	;

/* this one is new - we need the distinction to init a symtab */	
paramlist: IDENTIFIER
		@{
			/* this is the first param - create new symtab */
			@i @paramlist.0.stab@ = symtab_init();
			@pre symtab_contains( @paramlist.0.stab@, @IDENTIFIER.name@);
			@pre symtab_add( @paramlist.0.stab@, @IDENTIFIER.name@);
		@}
	| paramlist IDENTIFIER
		@{
			/* paramlist.1 hast the symtab from the parameters -> get it up the tree */
			@i @paramlist.0.stab@ = @paramlist.1.stab@;
			@pre symtab_contains( @paramlist.1.stab@, @IDENTIFIER.name@);
			@pre symtab_add( @paramlist.1.stab@, @IDENTIFIER.name@);
		@}
	;
		
Structdef: STRUCT IDENTIFIER ':' paramdef	END
	;

Funcdef: FUNC IDENTIFIER '(' paramdef ')' Stats END
		@{ 
			@i @Stats.stab@ = @paramdef.stab@;
		@}
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
	| Letlist Assignment ';'
	; 
	 
Stat: RETURN Expr
	| COND /*{ Expr THEN Stats END ';' }*/ Condlist END 
	| LET /*{ IDENTIFIER '=' Expr ';' }*/ Letlist IN Stats END
	| WITH Expr ':' IDENTIFIER DO Stats END
	| Assignment 
	| Lexpr '=' Expr 	/* Zuweisung */ 
	| Term
	;
	
/* Schreibender Variablenzugriff */ 
Assignment: IDENTIFIER '=' Expr 
	
Lexpr: Term '.' IDENTIFIER 	/* Schreibender Feldzugriff */ 
/*	| IDENTIFIER 			/* Schreibender Variablenzugriff */ 
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
	| Term '>' Term
	| Term NOTEQUAL Term /* Term <> Term */
	| Term
		@{
			@i @term.0.stab@ = @expr.0.stab@;
		@}
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

symtab *symtab_init(void)
{
	symtable *tab = malloc(sizeof(symtable));
	tab->first = NULL;
	tab->last = NULL;
	return tab;
}

symtab *symtab_add(symtab *tab, char *name)
{
	symtabentry *entry = stentry_init();
	entry->name = strdup(name);
	/*entry->type = type;*/
	entry->next = NULL;
	stentry_append(tab, entry);
	return tab;
}

/* make an exact duplicate (copy) of symbol table src into dest */
symtab *symtab_dup(symtab *src, symtab *dest)
{
	symtabentry *entry;
	symtabentry *copy;
	if(src->first != NULL) {
		entry = src->first;
		while(entry != NULL) {
			copy = stentry_dup(entry);
			if(dest->first == NULL) {
				dest->first = copy;
				dest->last 	= copy;
			} else {
				dest->last->next = copy;
				dest->last = copy;
			}
			entry = entry->next;
		}
	}
	return dest;
}

void void symtab_contains(symtab *tab, char *name)
{
	symtabentry *entry = stentry_find(tab, name);
	if(entry != NULL) {
		(void) fprintf(stderr, "duplicate names found: %s\n", name);
		othererror();
	}
}

symtabentry *stentry_init(void)
{
	symtabentry *entry = malloc(sizeof(symtabentry));
	entry->next = NULL;
	return entry;
}

/* append a entry to the symbol table at the first position */
symtabentry *stentry_append(symtab *tab, symtabentry *entry)
{
	if(tab->first == NULL) {
		tab->first = entry;
		tab->last = entry;
	} else {
		entry->next = tab->first;
		tab->first = entry;
	}
	return entry;
}

/* duplicate a symbol table entry, returns an exact copy */
symtabentry *stentry_dup(symtabentry *entry)
{
	symtabentry *dup = stentry_init();
	dup->type = entry->type;
	dup->name = strdup(entry->name);
	dup->next = NULL;
	return dup;
}

symtabentry *stentry_find(symtab *tab, char *name)
{
	symtabentry *match = NULL;
	symtabentry *cursor = tab->first;
	while(cursor != NULL) {
		if(strcmp(name, cursor->name) == 0) {
			match = cursor;
			break;
		}
		cursor = cursor->next;
	}
	return match;
}


