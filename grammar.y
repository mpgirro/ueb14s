
%{
	
/* === librarys === */
	
#include <stdio.h>
#include <stdlib.h>

/* === constants === */

#define LEXICAL_ERROR 	1
#define SYNTAX_ERROR 	2
#define OTHER_ERROR		3 	/* use of non visible name, etc. */

/* === structs === */

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
void symtab_checkdup(symtab *tab, char *name);
void symtab_isdef(symtab *tab, char *name);

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

@attributes { char *name; } 						IDENTIFIER

@attributes { symtab *structtab, *symtab fieldtab } 	Program
@attributes { symtab *vartab; symtab *structtab } 		Funcdef
@attributes { symtab *vartab; symtab *structtab } 		Stats
@attributes { symtab *vartab; symtab *structtab } 		Stat
	
@attributes { symtab *structtab, *symtab fieldtab; symtab *vartab; } Stats
@attributes { symtab *vartab; } 						paramdef
@attributes { symtab *vartab; } 						paramlist
@attributes { *symtab fieldtab, *symtab *vartab; } 		letdef
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
			/* init empty struct symbol table */
			@i @Program.0.structtab@ = symtab_init();
			
			/* init empty field symbol table */
			@i @Program.0.fieldtab@ = symtab_init();
		@}
	| Program Def ';'
		@{
			/* the structtab and fieldtab got initialised by an empty program nonterminal
			 * --> propagate them to the parent program and the definitions now */
			@i @Program.0.structtab@ = @Program.1.structtab@;
			@i @Program.0.fieldtab@  = @Program.1.fieldtab@;
			
			@i @Def.0.structtab@ = @Program.1.structtab@;
			@i @Def.0.fieldtab@  = @Program.1.fieldtab@;
		@}
	; 

Def: Funcdef
		@{
			/* propagate the struct and field sym table to every function def */
			@i @Funcdef.0.structtab@ = @Def.0.structtab@;
			@i @Funcdef.0.fieldtab@ = @Def.0.fieldtab@;
		@}
	| Structdef
		@{
			/* propagate the struct and field table to the every struct def */
			@i @Structdef.0.structtab@ = @Def.0.structtab@;
			@i @Structdef.0.fieldtab@ = @Def.0.fieldtab@;
		@}
	;
	
paramdef:
		@{
			/* empty var symbol table */
			@i @paramdef.0.vartab@ = symtab_init();
		@}
	| paramlist
		@{
			/* empty var symbol table */
			@i @paramdef.0.vartab@ = symtab_init();
			
			/* propagate new param symtab down the tree */
			@i @paramlist.0.vartab@ = @paramdef.0.vartab@;
		@}
	;

/* this one is new - we need the distinction to init a symtab */	
paramlist: IDENTIFIER
		@{
			/* check for duplicate var definiton, add to symtab if not */
			@pre symtab_checkdup( @paramlist.0.vartab@, @IDENTIFIER.name@);
			@pre symtab_add( @paramlist.0.vartab@, @IDENTIFIER.name@);
		@}
	| paramlist IDENTIFIER
		@{
			/* check for duplicate var definiton, add to symtab if not */
			@pre symtab_checkdup( @paramlist.0.vartab@, @IDENTIFIER.name@);
			@pre symtab_add( @paramlist.0.vartab@, @IDENTIFIER.name@);
			
			/* get the var symtab down the tree */
			@i @paramlist.1.vartab@ = @paramlist.0.vartab@;
		@}
	;
	
/* this construct merely exists to be not confused with a paramdef by the parser */
stuctfielddef:  ':' fielddef
		@{
			/* get the fieldtab even further down */
			@i @fielddef.0.fieldtab@ = @stuctfielddef.0.fieldtab@;
		@}
	;

fielddef: /* empty */
		/* well, we don't have any field definitions here, so there is nothing to add */
	| fieldlist
		@{
			/* and yet even further down */
			@i @fieldlist.0.fieldtab@ = @fielddef.0.fieldtab@;
		@}
	;
	
/* TODO hier muss ich zu den fields noch die zugehörige struct 
 * abspeichern. es wird wohl am bestens sein wenn ich sie in der 
 * structdef mittels eines attributes runterpropagiere */
fieldlist: IDENTIFIER
		@{	
			/* add the field name to the field list, but only if field name is unique */
			@pre symtab_checkdup( @fieldlist.0.fieldtab@, @IDENTIFIER.name@);
			@pre symtab_add( @fieldlist.0.fieldtab@, @IDENTIFIER.name@);
		@}
	| fieldlist IDENTIFIER
		@{
			/* add the field name to the field list, but only if field name is unique */
			@pre symtab_checkdup( @fieldlist.0.fieldtab@, @IDENTIFIER.name@);
			@pre symtab_add( @fieldlist.0.fieldtab@, @IDENTIFIER.name@);
			
			/* we will still need this further down */
			@i @fieldlist.1.fieldtab@ = @fieldlist.0.fieldtab@;
		@}
	;
		
Structdef: STRUCT IDENTIFIER stuctfielddef END
		@{
			/* check if there already is a struct with this name */
			@pre symtab_checkdup(@Structdef.0.structtab@, @IDENTIFIER.0.name@);
			
			/* add the struct name if all went well */
			@pre symtab_add(@Structdef.0.structtab@, @IDENTIFIER.0.name@);
			
			/* get the fieldtab down to the field definitions */
			@i @stuctfielddef.0.fieldtab@ = @Structdef.0.fieldtab@;
		@}
	;

Funcdef: FUNC IDENTIFIER '(' paramdef ')' Stats END
		@{ 	
			/* the parameters are visible within the function --> 
			 * get the new vartab (by the paramlist) down the tree */
			@i @Stats.vartab@ = @paramdef.vartab@;
			
			/* these come from the Def, are globally visible and may be 
			 * needed in the Stats as well --> get them down too! */
			@i @Stats.0.structtab@ = @Funcdef.0.structtab@;
			@i @Stats.0.fieldtab@ = @Funcdef.0.fieldtab@;
		@}
	;

Stats: /* empty */
		/* there ain't no more to do */
	| Stats Stat ';' 		
		@{ 	
			/* just distributing - move along please */
			@i @Stats.1.structtab@ = @Stats.0.structtab@;
			@i @Stat.0.structtab@  = @Stats.0.structtab@;
			
			@i @Stats.1.fieldtab@ = @Stats.0.fieldtab@;
			@i @Stat.0.fieldtab@  = @Stats.0.fieldtab@;
			
			@i @Stats.1.vartab@ = @Stats.0.vartab@;
			@i @Stat.0.vartab@  = @Stats.0.vartab@;
		@}
	;
	
Condlist:  /* empty */ 
		/* there ain't no more to do */
	| Condlist Expr THEN Stats END ';'
		@{
			/* distribute everything to the condlist */
			@i @Condlist.1.structtab@ = @Condlist.0.structtab@;
			@i @Condlist.1.fieldtab@  = @Condlist.0.fieldtab@;
			@i @Condlist.1.vartab@ 	  = @Condlist.0.vartab@;
				
			/* distribute everything to the Stats */
			@i @Stats.0.structtab@ = @Condlist.0.structtab@;
			@i @Stats.0.fieldtab@  = @Condlist.0.fieldtab@;
			@i @Stats.0.vartab@	   = @Condlist.0.vartab@;	
				
			/* the Expr doesn't need to know the structs (at least i hope so) */	
			@i @Expr.0.fieldtab@  = @Condlist.0.fieldtab@;
			@i @Expr.0.vartab@	  = @Condlist.0.vartab@;
		@}
	;
	
/* this construct merely exists to avoid a conflict when trying to destinct 
 * between the LET definitons and a Lexpr=Expt Statement */
letdef: LET letparamdef
		@{
			@i @letparamdef.vartab@   = @letdef.vartab@
			@i @letparamdef.fieldtab@ = @letparamdef.fieldtab@
		@}
	;
	
letparamdef:  
		/* there ain't no more to do */
	| letlist
		@{
			/* propagate Stats vartab down the tree */
			@i @letlist.0.vartab@	= @letparamdef.0.vartab@;
			@i @letlist.0.fieldtab@ = @letparamdef.0.fieldtab@;
		@}
	;

letlist: IDENTIFIER '=' Expr 
		@{			
			/* now we define a new variable */
			@pre symtab_checkdup( @letlist.0.vartab@, @IDENTIFIER.0.name@);
			@pre symtab_add( @letlist.0.vartab@, @IDENTIFIER.0.name@);
			
			/* this may be needed further down */
			@i @Expr.0.vartab@   = @letlist.0.vartab@;
			@i @expr.0.fieldtab@ = @letlist.0.fieldtab@;
		@}
	| letlist IDENTIFIER '=' Expr  ';'
		@{
			/* now we define a new variable */
			@pre symtab_checkdup( @letlist.0.vartab@, @IDENTIFIER.0.name@);
			@pre symtab_add( @letlist.0.vartab@, @IDENTIFIER.0.name@);
			
			/* this may be needed by the Expr further down */
			@i @Expr.0.vartab@   = @letlist.0.vartab@;
			@i @expr.0.fieldtab@ = @letlist.0.fieldtab@;
			
			/* and of course, the next letlist will need this as well */
			@i @letlist.1.fieldtab@ = @letlist.0.fieldtab@
			@i @letlist.1.fieldtab@ = @letlist.0.fieldtab@
		@}
	; 

	 
Stat: RETURN Expr
		@{
			/* I could open a distribution business by now... */
			@i @Expr.0.vartab@   = @Stat.0.vartab@;
			@i @Expr.0.fieldtab@ = @Stat.0.fieldtab@;
		@}
	| COND Condlist END 
		@{
			/* distribute everything to the condlist */
			@i @Condlist.0.structtab@ = @Stat.0.structtab@;
			@i @Condlist.0.fieldtab@  = @Stat.0.fieldtab@;
			@i @Condlist.0.vartab@ 	  = @Stat.0.vartab@;
		}@
	| letdef IN Stats END
		@{ 
			/* in here new variables may be added - fork the vartab to ensure visibility scope */
			@i @letdef.0.vartab@ = symtab_init();
			@pre symtab_dup( @Stat.0.vartab@, @letdef.0.vartab@);
			
			/* the new vartab is visible in the following Stats */
			@i @Stats.1.vartab@ = @letdef.0.vartab@;
			
			/* and the fieldtab may be needed as well */
			@i @letdef.0.fieldtab@ = @Stat.0.fieldtab@;
			@i @Stats.0.fieldtab@ = @Stat.0.fieldtab@;
			
			/* and the Stats may define a with block even now --> get down the structtab */
			@i @Stats.0.structtab@ = @Stat.0.structtab@
		@}
	| WITH Expr ':' IDENTIFIER DO Stats END
	| Lexpr '=' Expr 	/* Zuweisung */ 
		@{
				
		@}
	| Term
	;
	
Lexpr: Term '.' IDENTIFIER 	/* Schreibender Feldzugriff 		*/ 
	| IDENTIFIER 			/* Schreibender Variablenzugriff 	*/ 
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

/*
 * checks if a symbol 'name' is already in the symbol table *tab, raises an error if so
 */
void symtab_checkdup(symtab *tab, char *name)
{
	symtabentry *entry = stentry_find(tab, name);
	if(entry != NULL) {
		(void) fprintf(stderr, "duplicate names found: %s\n", name);
		othererror();
	}
}

/*
 * check if a symbol 'name' is defined in *tab, raised an error if not
 */
void symtab_isdef(symtab *tab, char *name)
{
	symtabentry *entry = stentry_find(tab, name);
	if(entry == NULL) {
		(void) fprintf(stderr, "symbol not defined in scope: %s\n", name);
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


