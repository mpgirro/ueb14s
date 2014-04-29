
%{
	
/* === librarys === */
	
#include <stdio.h>
#include <stdlib.h>

/* === constants === */

#define LEXICAL_ERROR 	1
#define SYNTAX_ERROR 	2
#define OTHER_ERROR		3 	/* use of non visible name, etc. */


/* === enums === */
/*
enum namespace {
	ns_struct,
	ns_field
};
*/
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
	struct symboltable_entry *next;
	
	/* 1: [vartab] this will be NULL
	 * 2: [fieldtab] it will reference the struct entry it belongs to
	 * 4: [structtab]: NULL as well */
	struct symboltable_entry *ref;
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

@attributes { symtab *structtab } 						Program
@attributes { symtab *vartab; symtab *structtab } 		Funcdef
@attributes { symtab *vartab; symtab *structtab } 		Stats
@attributes { symtab *vartab; symtab *structtab } 		Stat
	
@attributes { symtab *vartab; } 						Stats
@attributes { symtab *vartab; } 						paramdef
@attributes { symtab *vartab; } 						paramlist
@attributes { symtab *vartab; } 						letdef
@attributes { symtab *vartab; } 						letlist
	
/* this is to fill the symbol tables - maybe this is not even necessary? */
@traversal @lefttoright @preorder pre

%%

/*
Program: { Def ';' }
	;
*/
Program: /* empty */
		@{
			/* empty struct symbol table */
			@i @Program.0.structtab@ = symtab_init();
		@}
	| Program Def ';'
		@{
			/* the structtab got initialised by an empty program
			 * propagate it to the parent program and the definitions now */
			@i @Program.0.structtab@ = @Program.1.structtab@;
			@i @Def.0.structtab@ = @Program.1.structtab@;
		@}
	; 

Def: Funcdef
		@{
			/* propagate the struct table to the every function def */
			@i @Funcdef.0.structtab@ = @Def.0.structtab@;
		@}
	| Structdef
		@{
			/* propagate the struct table to the every struct def */
			@i @Structdef.0.structtab@ = @Def.0.structtab@;
		@}
	;
	
paramdef:
		@{
			/* empty symbol table */
			@i @paramdef.0.vartab@ = symtab_init();
		@}
	| paramlist
		@{
			/* propagate param symtab up the tree */
			@i @paramdef.0.vartab@ = @paramlist.0.vartab@;
		@}
	;

/* this one is new - we need the distinction to init a symtab */	
paramlist: IDENTIFIER
		@{
			/* this is the first param - create new symtab */
			@i @paramlist.0.vartab@ = symtab_init();
			@pre symtab_contains( @paramlist.0.vartab@, @IDENTIFIER.name@);
			@pre symtab_add( @paramlist.0.vartab@, @IDENTIFIER.name@);
		@}
	| paramlist IDENTIFIER
		@{
			/* paramlist.1 hast the symtab from the parameters -> get it up the tree */
			@i @paramlist.0.vartab@ = @paramlist.1.vartab@;
			@pre symtab_contains( @paramlist.1.vartab@, @IDENTIFIER.name@);
			@pre symtab_add( @paramlist.1.vartab@, @IDENTIFIER.name@);
		@}
	;
		
Structdef: STRUCT IDENTIFIER ':' paramdef	END
		@{
			/* check if there already is a struct with this name */
			@pre symtab_contains(@Structdef.0.structtab@, @IDENTIFIER.0.name@);
			
			/* add the struct name if all went well */
			@pre symtab_add(@Structdef.0.structtab@, @IDENTIFIER.0.name@);
		@}
	;

Funcdef: FUNC IDENTIFIER '(' paramdef ')' Stats END
		@{ 	
			/* the parameters are visible within the function -> get vartab down the tree */
			@i @Stats.vartab@ = @paramdef.vartab@;
			
			/* the structtab may be needed in the Stats as well --> get it down too! */
			@i @Funcdef.0.structtab@ = @Stats.0.structtab@;
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
	
letdef:  
		@{
			/* symbol table is from the Stats */
			/*@i @letdef.0.vartab@ = symtab_init();*/
		@}
	| letlist
		@{
			/* propagate Stats vartab down the tree */
			@i @letlist.0.vartab@ = @letdef.0.vartab@;
		@}
	;

/*{ IDENTIFIER '=' Expr ';' }*/
letlist: Assignment
		@{
			/* fork the vartab */
			@i 	 @Assignment.0.vartab@ = symtab_init();
			@pre @Assignment.0.vartab@ = symtab_dup( @letlist.0.vartab@, @Assignment.0.vartab@);
			
			/* add the name to the symtab */
			@pre symtab_contains( @letlist.0.vartab@, @Assignment.name@);
			@pre symtab_add( @letlist.0.vartab@, @Assignment.name@);
		@}
	| letlist Assignment ';'
		@{
			/* letlist.1 hast the symtab from the defs --> get it up the tree */
			@i @letlist.0.vartab@ = @letlist.1.vartab@;
			
			/* get symtab down to the assignment */
			@i @Assignment.0.vartab@ = @letlist.0.vartab@;
			
			@pre symtab_contains( @letlist.1.vartab@, @Assignment.0.name@);
			@pre symtab_add( @letlist.1.vartab@, @Assignment.0.name@);
		@}
	; 

/* Schreibender Variablenzugriff */ 
Assignment: IDENTIFIER '=' Expr 
		@{
			@i @Assignment.0.name@ = @IDENTIFIER.0.name@;
		@}
	;
	 
Stat: RETURN Expr
	| COND /*{ Expr THEN Stats END ';' }*/ Condlist END 
	| LET letdef IN Stats END
		@{ 
			/* everything that was defined in the LET block is visible in the IN block */
			@i @letdef.0.vartab@ = @Stat.0.vartab@;
		@}
	| WITH Expr ':' IDENTIFIER DO Stats END
	| Assignment 
	| Lexpr '=' Expr 	/* Zuweisung */ 
	| Term
	;
	
Lexpr: Term '.' IDENTIFIER 	/* Schreibender Feldzugriff 		*/ 
/*	| IDENTIFIER 			/* Schreibender Variablenzugriff 	*/ 
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
			@i @term.0.vartab@ = @expr.0.vartab@;
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
/*	| IDENTIFIER '(' ')'	 /* Funktionsaufruf mit leerer Argumentenliste */
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
	entry->next = NULL;
	entry->ref = NULL;
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


