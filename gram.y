
%{
	
/* === librarys === */
	
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

/* === constants === */

#define LEXICAL_ERROR 	1
#define SYNTAX_ERROR 	2
#define SEMANTIC_ERROR	3 	/* use of non visible name, etc. */
	

/* === function signatures === */

/* error handling functions */
void lexerror(int);
void yyerror(const char *msg);
void semanticerror(void);

/* symbol table maintainance */
symtab_t *symtab_init(void);
symtab_t *symtab_add(symtab_t *tab, char *name, char *ref);
symtab_t *symtab_dup(symtab_t *src, symtab_t *dest);
symtab_t *symtab_merge(symtab_t *tab1, symtab_t *tab2);
symtab_t *symtab_merge_nodupcheck(symtab_t *tab1, symtab_t *tab2);
symtab_t *symtab_subtab(symtab_t *ftab, char *name);
void symtab_checkdup(symtab_t *tab, char *name);
void symtab_isdef(symtab_t *tab, char *name);
void symtab_print(symtab_t *tab);

symtabentry_t *stentry_init(void);
symtabentry_t *stentry_append(symtab_t *tab, symtabentry_t *entry);
symtabentry_t *stentry_dup(symtabentry_t *entry);
symtabentry_t *stentry_find(symtab_t *tab, char *name);

extern int yylex();
extern int yyparse();

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

%start Start

@attributes { char *name; } IDENTIFIER
@attributes { symtab_t *structtab; symtab_t *fieldtab; } 					Program
@attributes { symtab_t *structtab; symtab_t *fieldtab; }					Def
@attributes { symtab_t *structtab; symtab_t *fieldtab; symtab_t *dummy1; }	Structdef
@attributes { symtab_t *structtab; symtab_t *fieldtab; }					Funcdef
@attributes { symtab_t *tab; } 											ParamDef
@attributes { symtab_t *fieldtab; char *structname; }						FieldDef
@attributes { symtab_t *structtab; symtab_t *fieldtab; symtab_t *vartab; }	Stats
@attributes { symtab_t *structtab; symtab_t *fieldtab; symtab_t *vartab; }	Stat
@attributes { symtab_t *structtab; symtab_t *fieldtab; symtab_t *vartab; }	Condlist
@attributes { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; }		LetDef
@attributes { symtab_t *fieldtab; symtab_t *vartab; }						Lexpr
@attributes { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; }						Notexpr
@attributes { symtab_t *fieldtab; symtab_t *vartab;symtab_t *visscope; }						Addexpr
@attributes { symtab_t *fieldtab; symtab_t *vartab;symtab_t *visscope; }						Mulexpr
@attributes { symtab_t *fieldtab; symtab_t *vartab;symtab_t *visscope; }						Orexpr
@attributes { symtab_t *fieldtab; symtab_t *vartab;symtab_t *visscope; }						Expr
@attributes { symtab_t *fieldtab; symtab_t *vartab;symtab_t *visscope; }						ExprList
@attributes { symtab_t *fieldtab; symtab_t *vartab;symtab_t *visscope; }						FinalArg
@attributes { symtab_t *fieldtab; symtab_t *vartab;symtab_t *visscope; }						Term

@traversal @lefttoright @preorder updatescope1
@traversal @lefttoright @preorder updatescope2
@traversal @lefttoright @postorder checkscope


%%
	
Start: Program
	;

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
			@i @Funcdef.0.fieldtab@  = @Def.0.fieldtab@;
		@}
	| Structdef
		@{
			/* propagate the struct and field table to the every struct def */
			@i @Structdef.0.structtab@ = @Def.0.structtab@;
			@i @Structdef.0.fieldtab@  = @Def.0.fieldtab@;
		@}
	;
	
Structdef: STRUCT IDENTIFIER ':' FieldDef END
		@{
			
			@i @Structdef.dummy1@ = symtab_add(@Structdef.0.structtab@, @IDENTIFIER.0.name@, NULL);
			@i @FieldDef.fieldtab@  = @Structdef.fieldtab@;
			@i @FieldDef.structname@ = @IDENTIFIER.0.name@;
		@}
	;
	
FieldDef:

	| FieldDef IDENTIFIER
		@{
			@i @FieldDef.1.fieldtab@ = symtab_add( @FieldDef.0.fieldtab@, @IDENTIFIER.name@, @FieldDef.0.structname@);
			@i @FieldDef.1.structname@ = @FieldDef.0.structname@;
		@}
	;
	
	
ParamDef: 
		@{
			@i @ParamDef.tab@ = symtab_init();
		@}
		
	| ParamDef IDENTIFIER
		@{
			//@i @ParamDef.1.tab@ = symtab_add( @ParamDef.0.tab@, @IDENTIFIER.name@, @ParamDef.0.structname@);
			@i @ParamDef.0.tab@ = symtab_add( @ParamDef.1.tab@, @IDENTIFIER.name@, NULL);
		@}
	;
	
Funcdef: FUNC IDENTIFIER '(' ParamDef ')' Stats END
		@{ 	
			/* the parameters are visible within the function --> 
			 * get the new vartab (by the ParamDef) down the tree */
			@i @Stats.vartab@ = @ParamDef.tab@;
		
			/* these come from the Def, are globally visible and may be 
			 * needed in the Stats as well --> get them down too! */
			@i @Stats.0.structtab@ = @Funcdef.0.structtab@;
			@i @Stats.0.fieldtab@  = @Funcdef.0.fieldtab@;
		@}
	;

	
Stats: /* empty */
		/* there ain't no more to do */
	| Stat ';' Stats		
		@{ 	
			/* just distributing - move along please */
	
			@i @Stat.0.structtab@ = @Stats.0.structtab@;
			@i @Stat.0.fieldtab@  = @Stats.0.fieldtab@;
			@i @Stat.0.vartab@    = @Stats.0.vartab@;
	
			@i @Stats.1.structtab@ = @Stat.0.structtab@;
			@i @Stats.1.fieldtab@  = @Stat.0.fieldtab@;
			@i @Stats.1.vartab@ = @Stat.0.vartab@;
	
			@updatescope2 @Stat.0.vartab@  = @Stats.0.vartab@;
			@updatescope2 @Stats.1.vartab@ = @Stats.0.vartab@;
		@}
	;
	
Stat: RETURN Expr
		@{
			/* I could open a distribution business by now... */
			@i @Expr.0.vartab@   = @Stat.0.vartab@;
			@i @Expr.0.visscope@   = @Stat.0.vartab@;
			@i @Expr.0.fieldtab@ = @Stat.0.fieldtab@;
		@}
	| COND Condlist END 
		@{
			/* distribute everything to the condlist */
			@i @Condlist.0.structtab@ = @Stat.0.structtab@;
			@i @Condlist.0.fieldtab@  = @Stat.0.fieldtab@;
			@i @Condlist.0.vartab@ 	  = @Stat.0.vartab@;
		@}
	| LET LetDef IN Stats END
		@{ 
			
			/* to ensure scope in definitions, fork vartab */
			@i @LetDef.0.visscope@ = symtab_dup(@Stat.0.vartab@, symtab_init());
			@i @LetDef.0.fieldtab@ = @Stat.0.fieldtab@;
			
			/* in here new variables may be added - fork the vartab to ensure visibility scope */
			//@i @LetDef.0.vartab@ = symtab_dup( @Stat.0.vartab@, symtab_init());
			@i @Stats.0.vartab@    = symtab_merge( @Stat.0.vartab@, @LetDef.0.vartab@);
			
			@updatescope2 @Stats.0.vartab@  = symtab_merge_nodupcheck( @Stat.0.vartab@, @LetDef.0.vartab@);
			
			//@i @Stats.0.vartab@    = @LetDef.0.vartab@;
			@i @Stats.0.fieldtab@  = @Stat.0.fieldtab@;
			@i @Stats.0.structtab@ = @Stat.0.structtab@;
		@}
	| WITH Expr ':' IDENTIFIER DO Stats END
		@{
			/* and we have to pass things on as well */
			@i @Stats.fieldtab@  = @Stat.fieldtab@;
			@i @Stats.structtab@ = @Stat.structtab@;
		
			@i @Expr.vartab@   = @Stat.vartab@;
			@i @Expr.visscope@ = @Stat.vartab@;
			@i @Expr.fieldtab@ = @Stat.fieldtab@;
			
			/* check if IDENTIFIER is a valid struct */
			@checkscope symtab_isdef( @Stat.0.structtab@, @IDENTIFIER.0.name@);
		
			/* good! now get all fields of the struct into a new symtab
			 * --> these will be added to the varscope of the with-block.  
			 * yet, we will need the already defined variables as well, so
			 * merge these two symtables into one
			 * NOTE: the result will be in arg2 (so the return * of the function 
			 * -- a new symtab_t to ensure scope), and the elements of arg1 will be
			 * appended as copies, so no mixup with the original elements */
			//@i @Stats.vartab@ = symtab_merge( @Stat.vartab@, symtab_subtab( @Stat.fieldtab@, @IDENTIFIER.0.name@));
			@i @Stats.vartab@ = symtab_merge( @Stat.vartab@, symtab_subtab( @Stat.fieldtab@, @IDENTIFIER.0.name@));
			
			/* reassign scope if structs are defined below functions */
			@updatescope1 @Stats.vartab@ = symtab_merge( @Stat.vartab@, symtab_subtab( @Stat.fieldtab@, @IDENTIFIER.0.name@));
		@}
	| Lexpr '=' Expr 	/* Zuweisung */ 
		@{
			/* onwards down the tree! */
			@i @Lexpr.0.vartab@   = @Stat.0.vartab@;
			@i @Lexpr.0.fieldtab@ = @Stat.0.fieldtab@;
		
			@i @Expr.0.vartab@   = @Stat.0.vartab@;	
			@i @Expr.0.visscope@   = @Stat.0.vartab@;	
			@i @Expr.0.fieldtab@ = @Stat.0.fieldtab@;
		@}
	| Term
		@{
			/* down the rabbit hole! */
			@i @Term.0.vartab@   = @Stat.0.vartab@;	
			@i @Term.0.visscope@   = @Stat.0.vartab@;	
			@i @Term.0.fieldtab@ = @Stat.0.vartab@;	
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
			@i @Expr.0.visscope@	  = @Condlist.0.vartab@;
		@}
	;

LetDef: 
		@{
			@i @LetDef.0.vartab@ = symtab_init();
		@}
	| LetDef IDENTIFIER '=' Expr  ';' 
		@{
			@i @Expr.0.vartab@   = @LetDef.0.vartab@;
			@i @Expr.0.fieldtab@ = @LetDef.0.fieldtab@;
			@i @Expr.0.visscope@ = @LetDef.0.visscope@;
			
			//@i @LetDef.1.vartab@   = symtab_add( @LetDef.0.vartab@, @IDENTIFIER.0.name@, NULL);
			@i @LetDef.0.vartab@   = symtab_add( @LetDef.1.vartab@, @IDENTIFIER.0.name@, NULL);

			@i @LetDef.1.fieldtab@ = @LetDef.0.fieldtab@;
			@i @LetDef.1.visscope@ = @LetDef.0.visscope@;
			
		@}
	; 

Lexpr: Term '.' IDENTIFIER 	/* Schreibender Feldzugriff 		*/ 
		@{
			/* check if IDENTIFIER is a defined field */
			@checkscope symtab_isdef( @Lexpr.fieldtab@, @IDENTIFIER.0.name@);
			
			/* and as always there is stuff to get down */
			@i @Term.vartab@ 	= @Lexpr.vartab@;
			@i @Term.visscope@ 	= @Lexpr.vartab@;
			@i @Term.fieldtab@  = @Lexpr.fieldtab@;	
		@}

	| IDENTIFIER  /* Schreibender Variablenzugriff 	*/ 
		@{
			/* check if IDENTIFIER is a visible variable */
			@checkscope symtab_isdef( @Lexpr.vartab@, @IDENTIFIER.0.name@);
		@}
	;

Notexpr: '-' Term
		@{
			@i @Term.vartab@   = @Notexpr.vartab@;
			@i @Term.visscope@ = @Notexpr.visscope@;
			@i @Term.fieldtab@ = @Notexpr.fieldtab@;
		@}
	| NOT Term
		@{
			@i @Term.vartab@   = @Notexpr.vartab@;
			@i @Term.visscope@ = @Notexpr.visscope@;
			@i @Term.fieldtab@ = @Notexpr.fieldtab@;
		@}
	| '-' Notexpr
		@{
			@i @Notexpr.1.vartab@   = @Notexpr.0.vartab@;
			@i @Notexpr.1.visscope@ = @Notexpr.0.visscope@;
			@i @Notexpr.1.fieldtab@ = @Notexpr.0.fieldtab@;
		@}
	| NOT Notexpr 
		@{
			@i @Notexpr.1.vartab@   = @Notexpr.0.vartab@;
			@i @Notexpr.1.visscope@ = @Notexpr.0.visscope@;
			@i @Notexpr.1.fieldtab@ = @Notexpr.0.fieldtab@;
		@}
	;

Addexpr: Term '+' Term
		@{
			@i @Term.0.vartab@   = @Addexpr.0.vartab@;
			@i @Term.0.visscope@ = @Addexpr.0.visscope@;
			@i @Term.1.vartab@   = @Addexpr.0.vartab@;
			@i @Term.1.visscope@ = @Addexpr.0.visscope@;
		
			@i @Term.0.fieldtab@ = @Addexpr.0.fieldtab@;
			@i @Term.1.fieldtab@ = @Addexpr.0.fieldtab@;
		@}	
	| Addexpr '+' Term
		@{
			@i @Term.0.vartab@    = @Addexpr.0.vartab@;
			@i @Term.0.visscope@  = @Addexpr.0.visscope@;
			@i @Addexpr.1.vartab@ = @Addexpr.0.vartab@;
			@i @Addexpr.1.visscope@ = @Addexpr.0.visscope@;
	
			@i @Term.0.fieldtab@    = @Addexpr.0.fieldtab@;
			@i @Addexpr.1.fieldtab@ = @Addexpr.0.fieldtab@;
		@}	
	;

Mulexpr: Term '*' Term
		@{
			@i @Term.0.vartab@ = @Mulexpr.0.vartab@;
			@i @Term.0.visscope@ = @Mulexpr.0.visscope@;
			@i @Term.1.vartab@ = @Mulexpr.0.vartab@;
			@i @Term.1.visscope@ = @Mulexpr.0.visscope@;

			@i @Term.0.fieldtab@ = @Mulexpr.0.fieldtab@;
			@i @Term.1.fieldtab@ = @Mulexpr.0.fieldtab@;
		@}	
	| Mulexpr '*' Term
		@{
			@i @Term.0.vartab@    = @Mulexpr.0.vartab@;
			@i @Term.0.visscope@    = @Mulexpr.0.visscope@;
			@i @Mulexpr.1.vartab@ = @Mulexpr.0.vartab@;
			@i @Mulexpr.1.visscope@ = @Mulexpr.0.visscope@;

			@i @Term.0.fieldtab@    = @Mulexpr.0.fieldtab@;
			@i @Mulexpr.1.fieldtab@ = @Mulexpr.0.fieldtab@;
		@}	
	;

Orexpr: Term OR Term
		@{
			@i @Term.0.vartab@ = @Orexpr.0.vartab@;
			@i @Term.0.visscope@ = @Orexpr.0.visscope@;
			@i @Term.1.vartab@ = @Orexpr.0.vartab@;
			@i @Term.1.visscope@ = @Orexpr.0.visscope@;

			@i @Term.0.fieldtab@ = @Orexpr.0.fieldtab@;
			@i @Term.1.fieldtab@ = @Orexpr.0.fieldtab@;
		@}	
	| Orexpr OR Term
		@{
			@i @Term.0.vartab@   = @Orexpr.0.vartab@;
			@i @Term.0.visscope@ = @Orexpr.0.visscope@;
			@i @Orexpr.1.vartab@ = @Orexpr.0.vartab@;
			@i @Orexpr.1.visscope@ = @Orexpr.0.visscope@;

			@i @Term.0.fieldtab@   = @Orexpr.0.fieldtab@;
			@i @Orexpr.1.fieldtab@ = @Orexpr.0.fieldtab@;
		@}	
	;

Expr: Notexpr
		@{
			@i @Notexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Notexpr.0.visscope@ = @Expr.0.visscope@;
			@i @Notexpr.0.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Addexpr
		@{
			@i @Addexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Addexpr.0.visscope@ = @Expr.0.visscope@;
			@i @Addexpr.0.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Mulexpr
		@{
			@i @Mulexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Mulexpr.0.visscope@ = @Expr.0.visscope@;
			@i @Mulexpr.0.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Orexpr
		@{
			@i @Orexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Orexpr.0.visscope@ = @Expr.0.visscope@;
			@i @Orexpr.0.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Term '>' Term
		@{
			@i @Term.0.vartab@   = @Expr.0.vartab@;
			@i @Term.0.visscope@ = @Expr.0.visscope@;
			@i @Term.0.fieldtab@ = @Expr.0.fieldtab@;
		
			@i @Term.1.vartab@   = @Expr.0.vartab@;
			@i @Term.1.visscope@ = @Expr.0.visscope@;
			@i @Term.1.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Term NOTEQUAL Term 
		@{
			@i @Term.0.vartab@   = @Expr.0.vartab@;
			@i @Term.0.visscope@ = @Expr.0.visscope@;
			@i @Term.0.fieldtab@ = @Expr.0.fieldtab@;
	
			@i @Term.1.vartab@   = @Expr.0.vartab@;
			@i @Term.1.visscope@ = @Expr.0.visscope@;
			@i @Term.1.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Term
		@{
			@i @Term.0.vartab@   = @Expr.0.vartab@;
			@i @Term.0.visscope@ = @Expr.0.visscope@;
			@i @Term.0.fieldtab@ = @Expr.0.fieldtab@;
		@}
	;

ExprList: /* empty */
		/* there ain't no more to do */
	| ExprList Expr ','
		@{
			/* we didn't have anything to get down for quite a while */
			@i @ExprList.1.vartab@  = @ExprList.0.vartab@;
			@i @ExprList.1.visscope@ = @Expr.0.visscope@;
			@i @Expr.0.vartab@ 	    = @ExprList.0.vartab@;
			@i @Expr.0.visscope@    = @ExprList.0.visscope@;
			
			@i @ExprList.1.fieldtab@ = @ExprList.0.fieldtab@;
			@i @Expr.0.fieldtab@ 	 = @ExprList.0.fieldtab@;
		@}
	; 

FinalArg: /* empty */
		/* there ain't no more to do */
	| Expr
		@{
			@i @Expr.vartab@   = @FinalArg.vartab@;
			@i @Expr.visscope@ = @FinalArg.visscope@;
			@i @Expr.fieldtab@ = @FinalArg.fieldtab@;
		@}
	; 
	
Term: '(' Expr ')'
		@{
			@i @Expr.vartab@   = @Term.vartab@;
			@i @Expr.visscope@ = @Term.visscope@;
			@i @Expr.fieldtab@ = @Term.fieldtab@;
		@}
	| NUMBER
		/* we don't care for no numbers */
	| Term '.' IDENTIFIER  /* Lesender Feldzugriff */
		@{
			/* check if IDENTIFIER is a defined field */
			@checkscope symtab_isdef( @Term.0.fieldtab@, @IDENTIFIER.0.name@);
		
			/* and as always there is stuff to get down */
			@i @Term.1.vartab@   = @Term.0.vartab@;
			@i @Term.1.visscope@ = @Term.0.visscope@;
			@i @Term.1.fieldtab@ = @Term.0.fieldtab@;	
		@}
	| IDENTIFIER  /* Lesender Variablenzugriff */
		@{
			/* check if IDENTIFIER is a defined variable */
			//@checkscope symtab_isdef( @Term.0.vartab@, @IDENTIFIER.0.name@);
			@checkscope symtab_isdef( @Term.0.visscope@, @IDENTIFIER.0.name@);
		@}
	| IDENTIFIER '(' /*{ Expr ',' }*/ ExprList FinalArg ')' 	/* Funktionsaufruf */ 
		@{
			/* IDENTIFIER is the name of the function --> ignore */
			@i @ExprList.vartab@ = @Term.vartab@;
			@i @ExprList.visscope@ = @Term.visscope@;
			@i @FinalArg.vartab@ = @Term.vartab@;
			@i @FinalArg.visscope@ = @Term.visscope@;
		
			@i @ExprList.fieldtab@ = @Term.fieldtab@;
			@i @FinalArg.fieldtab@ = @Term.fieldtab@;
		@}
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

void semanticerror(void)
{
	(void) fprintf(stderr, "semantic error\n");
	exit(SEMANTIC_ERROR);
}

symtab_t *symtab_init(void)
{
	symtab_t *tab = malloc(sizeof(symtab));
	tab->first = NULL;
	tab->last = NULL;
	return tab;
}

symtab_t *symtab_add(symtab_t *tab, char *name, char *ref)
{
	/* ok, now lets add the new entry */
	symtabentry_t *entry = stentry_init();
	entry->name = strdup(name);

	/* strdup(NULL) is very undefined and not to be trusted */
	if(ref != NULL)
		entry->ref = strdup(ref);
	else 
		entry->ref = NULL;
	entry->next = NULL;
	stentry_append(tab, entry);
	return tab;
}

/* make an exact duplicate (copy) of symbol table src into dest */
symtab_t *symtab_dup(symtab_t *src, symtab_t *dest)
{
	printf("duplicating tab\n");
	printf("================\n");
	printf("src:\n");
	symtab_print(src);
	symtabentry_t *cursor;
	symtabentry_t *copy;
	if(src->first != NULL) 
	{
		cursor = src->first;
		while(cursor != NULL) 
		{
			copy = stentry_dup(cursor);
			if(dest->first == NULL) 
			{
				dest->first = copy;
				dest->last 	= copy;
			} else {
				dest->last->next = copy;
				dest->last = copy;
			}
			cursor = cursor->next;
		}
	}
	printf("dest:\n");
	symtab_print(dest);
	printf("duplicating complete\n");
	return dest;
}

/*
 * adds every element of 
 */
symtab_t *symtab_merge(symtab_t *tab1, symtab_t *tab2)
{
	printf("merging tabs\n");
	printf("============\n");
	printf("tab1:\n");
	symtab_print(tab1);
	printf("tab2:\n");
	symtab_print(tab2);
	
	symtabentry_t *cursor = tab1->first;
	while(cursor != NULL) 
	{
		stentry_append(tab2, stentry_dup(cursor)); /* append a copy! */
		cursor = cursor->next;
	}
		
	printf("resulttab:\n");
	symtab_print(tab2);
	printf("merging complete\n");
	return tab2;
}

symtab_t *symtab_merge_nodupcheck(symtab_t *tab1, symtab_t *tab2)
{
	printf("merging tabs\n");
	printf("============\n");
	printf("tab1:\n");
	symtab_print(tab1);
	printf("tab2:\n");
	symtab_print(tab2);
	
	symtabentry_t *cursor = tab1->first;
	while(cursor != NULL) 
	{
		symtabentry_t *entry = stentry_find(tab2, cursor->name);
		if(entry == NULL) 
		{
			stentry_append(tab2, stentry_dup(cursor)); 
		}
		cursor = cursor->next;
	}
		
	printf("resulttab:\n");
	symtab_print(tab2);
	printf("merging complete\n");
	return tab2;
}

/* search all entries of a symtab_t for element having a *ref equal to 'name'
 * returns a new symtab_t with these elements, all elements are copies of there originals
 */
symtab_t *symtab_subtab(symtab_t *tab, char *name)
{
	symtab_t *ntab = symtab_init(); /* fields of struct */
	printf("subbing tab\n");
	if(tab == NULL)
		printf("tab is null!\n");
	if(name != NULL)
	{
		if(tab->first != NULL)
		{
			symtabentry_t *cursor = tab->first;
			while(cursor != NULL) 
			{
				if(cursor->ref != NULL)
					printf("cursor->ref is NULL!\n");
				
				if( strcmp(name, cursor->ref) == 0 && cursor->ref != NULL ) 
				{
					if( cursor->name != NULL && cursor->ref != NULL)
						printf("adding %s of %s\n", cursor->name, cursor->ref);
					stentry_append(ntab, stentry_dup(cursor)); /* append a copy! */
				}
				cursor = cursor->next;
			}
		}
	}
	printf("subbing complete\n");
	return ntab;
}

/*
 * checks if a symbol 'name' is already in the symbol table *tab, raises an error if so
 */
void symtab_checkdup(symtab_t *tab, char *name)
{
	symtabentry_t *entry = stentry_find(tab, name);
	if(entry != NULL) 
	{
		(void) fprintf(stderr, "duplicate names found: %s\n", name);
		semanticerror();
	}
}

/*
 * check if a symbol 'name' is defined in *tab, raised an error if not
 */
void symtab_isdef(symtab_t *tab, char *name)
{
	
	printf("checking if %s is defined in:\n",name);
	symtab_print(tab);
	
	symtabentry_t *entry = stentry_find(tab, name);
	if(entry == NULL) 
	{
		(void) fprintf(stderr, "symbol not defined in scope: %s\n", name);
		semanticerror();
	}
}

void symtab_print(symtab_t *tab){
	
	symtabentry_t *cursor = tab->first;
	printf("symtab: ");
	while(cursor != NULL) 
	{
		printf("%s, ", cursor->name);
		cursor = cursor->next;
	}
	printf("\n");
}

symtabentry_t *stentry_init(void)
{
	symtabentry_t *entry = malloc(sizeof(symtabentry_t));
	entry->next = NULL;
	return entry;
}

/* append a entry to the symbol table at the first position */
symtabentry_t *stentry_append(symtab_t *tab, symtabentry_t *entry)
{
	
	/* check if variable is already defined */
	symtab_checkdup(tab, entry->name);
	
	if(tab->first == NULL) 
	{
		tab->first = entry;
		tab->last = entry;
	} else 
	{
		entry->next = tab->first;
		tab->first = entry;
	}
	return entry;
}

/* duplicate a symbol table entry, returns an exact copy */
symtabentry_t *stentry_dup(symtabentry_t *entry)
{
	symtabentry_t *dup = stentry_init();
	dup->name = strdup(entry->name);
	
	/* strdup(NULL) is very undefined and not to be trusted */
	if(dup->ref != NULL)
		dup->ref = strdup(entry->ref);
	else 
		dup->ref = NULL;
	dup->next = NULL;
	return dup;
}

symtabentry_t *stentry_find(symtab_t *tab, char *name)
{
	symtabentry_t *match = NULL;
	symtabentry_t *cursor = tab->first;
	while(cursor != NULL) 
	{
		if(strcmp(name, cursor->name) == 0) 
		{
			match = cursor;
			break;
		}
		cursor = cursor->next;
	}
	return match;
}




