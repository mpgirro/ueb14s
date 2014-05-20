
%{
	
/* === librarys === */
	
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h> /* for 64 bit int */
#include "symtab.h"
#include "syntree.h"

/* === constants === */

#define LEXICAL_ERROR 	1
#define SYNTAX_ERROR 	2
#define SEMANTIC_ERROR	3 	/* use of non visible name, etc. */
	

/* === function signatures === */

void lexerror(int);
void yyerror(const char *msg);
void semanticerror(void);

char *next_reg(void);
void reset_regcursor(void);

void burm_label(NODEPTR_TYPE);
void burm_reduce(NODEPTR_TYPE bnode, int goalnt);

extern int yylex();
extern int yyparse();

/* === global variables === */

FILE *output;

extern FILE* yyin;

int regcursor = -1;
char *registers[] = { "rdi", "rsi", "rdx", "rcx", "r8", "r9"};

%}

%union {
	char *sval;
	int64_t nval;
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

@attributes { char *name; }																	IDENTIFIER
@attributes { int64_t val; }																NUMBER
@attributes { symtab_t *structtab; symtab_t *fieldtab; } 									Program
@attributes { symtab_t *structtab; symtab_t *fieldtab; }									Def
@attributes { symtab_t *structtab; symtab_t *fieldtab; symtab_t *dummy1; }					Structdef
@attributes { symtab_t *structtab; symtab_t *fieldtab; }									Funcdef
@attributes { symtab_t *tab; } 																ParamDef
@attributes { symtab_t *fieldtab; char *structname; }										FieldDef
@attributes { symtab_t *structtab; symtab_t *fieldtab; symtab_t *vartab; tnode_t *node; }	Stats
@attributes { symtab_t *structtab; symtab_t *fieldtab; symtab_t *vartab; tnode_t *node; }	Stat
@attributes { symtab_t *structtab; symtab_t *fieldtab; symtab_t *vartab; }					Condlist
@attributes { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; }					LetDef
@attributes { symtab_t *fieldtab; symtab_t *vartab; }										Lexpr
@attributes { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }	Notexpr
@attributes { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }	Addexpr
@attributes { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }	Mulexpr
@attributes { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }	Orexpr
@attributes { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }	Expr
@attributes { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; }					ExprList
@attributes { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; }					FinalArg
@attributes { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }	Term

@traversal @lefttoright @preorder updatescope1
@traversal @lefttoright @preorder updatescope2
@traversal @lefttoright @postorder checkscope
@traversal @lefttoright @postorder reg	
@traversal @lefttoright @postorder codegen


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
			
			@i @Structdef.dummy1@ = symtab_add(@Structdef.0.structtab@, NULL, @IDENTIFIER.0.name@, NULL);
			@i @FieldDef.fieldtab@  = @Structdef.fieldtab@;
			@i @FieldDef.structname@ = @IDENTIFIER.0.name@;
		@}
	;
	
FieldDef:

	| FieldDef IDENTIFIER
		@{
			@i @FieldDef.1.fieldtab@ = symtab_add( @FieldDef.0.fieldtab@, next_reg(), @IDENTIFIER.name@, @FieldDef.0.structname@);
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
			@i @ParamDef.0.tab@ = symtab_add( @ParamDef.1.tab@, next_reg(), @IDENTIFIER.name@, NULL);
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
			
			@codegen burm_label(@Stats.node@); burm_reduce(@Stats.node@,1);
			@codegen reset_regcursor();
		@}
	;

	
Stats: /* empty */
		@{
			@i @Stats.node@ = NULL;
			@reg reset_regcursor();
		@}
	| Stat ';' Stats		
		@{ 	
			/* just distributing - move along please */
	
			@i @Stat.0.structtab@ = @Stats.0.structtab@;
			@i @Stat.0.fieldtab@  = @Stats.0.fieldtab@;
			@i @Stat.0.vartab@    = @Stats.0.vartab@;
	
			@i @Stats.1.structtab@ = @Stat.0.structtab@;
			@i @Stats.1.fieldtab@  = @Stat.0.fieldtab@;
			@i @Stats.1.vartab@ = @Stat.0.vartab@;
			
			@i @Stats.0.node@ = NULL;
			@codegen @Stats.0.node@ = @Stat.0.node@;
			@codegen @Stats.0.node@->right = @Stats.1.node@;
	
			@updatescope2 @Stat.0.vartab@  = @Stats.0.vartab@;
			@updatescope2 @Stats.1.vartab@ = @Stats.0.vartab@;
		@}
	;
	
Stat: RETURN Expr
		@{
			/* I could open a distribution business by now... */
			@i @Expr.0.vartab@   = @Stat.0.vartab@;
			@i @Expr.0.visscope@ = @Stat.0.vartab@;
			@i @Expr.0.fieldtab@ = @Stat.0.fieldtab@;
			
			@i @Stat.0.node@ = NULL;
			
			@codegen @Stat.0.node@ = new_ret(@Expr.0.node@);
		@}
	| COND Condlist END 
		@{
			/* distribute everything to the condlist */
			@i @Condlist.0.structtab@ = @Stat.0.structtab@;
			@i @Condlist.0.fieldtab@  = @Stat.0.fieldtab@;
			@i @Condlist.0.vartab@ 	  = @Stat.0.vartab@;
			
			@i @Stat.0.node@ = NULL;
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
			
			@i @Stat.0.node@ = NULL;
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
			
			@i @Stat.0.node@ = NULL;
		@}
	| Lexpr '=' Expr 	/* Zuweisung */ 
		@{
			/* onwards down the tree! */
			@i @Lexpr.0.vartab@   = @Stat.0.vartab@;
			@i @Lexpr.0.fieldtab@ = @Stat.0.fieldtab@;
		
			@i @Expr.0.vartab@   = @Stat.0.vartab@;	
			@i @Expr.0.visscope@   = @Stat.0.vartab@;	
			@i @Expr.0.fieldtab@ = @Stat.0.fieldtab@;
			
			@i @Stat.0.node@ = NULL;
		@}
	| Term
		@{
			/* down the rabbit hole! */
			@i @Term.0.vartab@   = @Stat.0.vartab@;	
			@i @Term.0.visscope@   = @Stat.0.vartab@;	
			@i @Term.0.fieldtab@ = @Stat.0.vartab@;	
			
			@i @Stat.0.node@ = NULL;
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
			@i @LetDef.0.vartab@   = symtab_add( @LetDef.1.vartab@, NULL, @IDENTIFIER.0.name@, NULL);

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
			
			@i @Notexpr.0.node@ = NULL;	
			@codegen @Notexpr.0.node@ = new_op(T_NEG, @Term.0.node@, NULL);
		@}
	| NOT Term
		@{
			@i @Term.vartab@   = @Notexpr.vartab@;
			@i @Term.visscope@ = @Notexpr.visscope@;
			@i @Term.fieldtab@ = @Notexpr.fieldtab@;
			
			@i @Notexpr.0.node@ = NULL;	
			@codegen @Notexpr.0.node@ = new_op(T_NOT, @Term.0.node@, NULL);
		@}
	| '-' Notexpr
		@{
			@i @Notexpr.1.vartab@   = @Notexpr.0.vartab@;
			@i @Notexpr.1.visscope@ = @Notexpr.0.visscope@;
			@i @Notexpr.1.fieldtab@ = @Notexpr.0.fieldtab@;
			
			@i @Notexpr.0.node@ = NULL;	
			@codegen @Notexpr.0.node@ = new_op(T_NEG, @Notexpr.1.node@, NULL);
		@}
	| NOT Notexpr 
		@{
			@i @Notexpr.1.vartab@   = @Notexpr.0.vartab@;
			@i @Notexpr.1.visscope@ = @Notexpr.0.visscope@;
			@i @Notexpr.1.fieldtab@ = @Notexpr.0.fieldtab@;
			
			@i @Notexpr.0.node@ = NULL;	
			@codegen @Notexpr.0.node@ = new_op(T_NOT, @Notexpr.1.node@, NULL);
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
			
			@i @Addexpr.0.node@ = NULL;	
			@codegen @Addexpr.0.node@ = new_op(T_ADD, @Term.0.node@, @Term.1.node@);
		@}	
	| Addexpr '+' Term
		@{
			@i @Term.0.vartab@    = @Addexpr.0.vartab@;
			@i @Term.0.visscope@  = @Addexpr.0.visscope@;
			@i @Addexpr.1.vartab@ = @Addexpr.0.vartab@;
			@i @Addexpr.1.visscope@ = @Addexpr.0.visscope@;
	
			@i @Term.0.fieldtab@    = @Addexpr.0.fieldtab@;
			@i @Addexpr.1.fieldtab@ = @Addexpr.0.fieldtab@;
			
			@i @Addexpr.0.node@ = NULL;	
			@codegen @Addexpr.0.node@ = new_op(T_ADD, @Addexpr.1.node@, @Term.0.node@);
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
			
			@i @Mulexpr.0.node@ = NULL;	
			@codegen @Mulexpr.0.node@ = new_op(T_MUL, @Term.0.node@, @Term.1.node@);
		@}	
	| Mulexpr '*' Term
		@{
			@i @Term.0.vartab@    = @Mulexpr.0.vartab@;
			@i @Term.0.visscope@    = @Mulexpr.0.visscope@;
			@i @Mulexpr.1.vartab@ = @Mulexpr.0.vartab@;
			@i @Mulexpr.1.visscope@ = @Mulexpr.0.visscope@;

			@i @Term.0.fieldtab@    = @Mulexpr.0.fieldtab@;
			@i @Mulexpr.1.fieldtab@ = @Mulexpr.0.fieldtab@;
			
			@i @Mulexpr.0.node@ = NULL;	
			@codegen @Mulexpr.0.node@ = new_op(T_MUL, @Mulexpr.1.node@, @Term.0.node@);
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
			
			@i @Orexpr.0.node@ = NULL;	
			@codegen @Orexpr.0.node@ = new_op(T_OR, @Term.0.node@, @Term.1.node@);
		@}	
	| Orexpr OR Term
		@{
			@i @Term.0.vartab@   = @Orexpr.0.vartab@;
			@i @Term.0.visscope@ = @Orexpr.0.visscope@;
			@i @Orexpr.1.vartab@ = @Orexpr.0.vartab@;
			@i @Orexpr.1.visscope@ = @Orexpr.0.visscope@;

			@i @Term.0.fieldtab@   = @Orexpr.0.fieldtab@;
			@i @Orexpr.1.fieldtab@ = @Orexpr.0.fieldtab@;
			
			@i @Orexpr.0.node@ = NULL;	
			@codegen @Orexpr.0.node@ = new_op(T_OR, @Orexpr.1.node@, @Term.0.node@);
		@}	
	;

Expr: Notexpr
		@{
			@i @Notexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Notexpr.0.visscope@ = @Expr.0.visscope@;
			@i @Notexpr.0.fieldtab@ = @Expr.0.fieldtab@;
			
			@i @Expr.node@ = NULL;
			@codegen @Expr.node@ = @Notexpr.node@;
		@}
	| Addexpr
		@{
			@i @Addexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Addexpr.0.visscope@ = @Expr.0.visscope@;
			@i @Addexpr.0.fieldtab@ = @Expr.0.fieldtab@;
			
			@i @Expr.node@ = NULL;
			@codegen @Expr.node@ = @Addexpr.node@;
		@}
	| Mulexpr
		@{
			@i @Mulexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Mulexpr.0.visscope@ = @Expr.0.visscope@;
			@i @Mulexpr.0.fieldtab@ = @Expr.0.fieldtab@;
			
			@i @Expr.node@ = NULL;
			@codegen @Expr.node@ = @Mulexpr.node@;
		@}
	| Orexpr
		@{
			@i @Orexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Orexpr.0.visscope@ = @Expr.0.visscope@;
			@i @Orexpr.0.fieldtab@ = @Expr.0.fieldtab@;
			
			@i @Expr.node@ = NULL;
			@codegen @Expr.node@ = @Orexpr.node@;
		@}
	| Term '>' Term
		@{
			@i @Term.0.vartab@   = @Expr.0.vartab@;
			@i @Term.0.visscope@ = @Expr.0.visscope@;
			@i @Term.0.fieldtab@ = @Expr.0.fieldtab@;
		
			@i @Term.1.vartab@   = @Expr.0.vartab@;
			@i @Term.1.visscope@ = @Expr.0.visscope@;
			@i @Term.1.fieldtab@ = @Expr.0.fieldtab@;
			
			@i @Expr.node@ = NULL;
			@codegen @Expr.0.node@ = new_op(T_GRE, @Term.0.node@, @Term.1.node@);
		@}
	| Term NOTEQUAL Term 
		@{
			@i @Term.0.vartab@   = @Expr.0.vartab@;
			@i @Term.0.visscope@ = @Expr.0.visscope@;
			@i @Term.0.fieldtab@ = @Expr.0.fieldtab@;
	
			@i @Term.1.vartab@   = @Expr.0.vartab@;
			@i @Term.1.visscope@ = @Expr.0.visscope@;
			@i @Term.1.fieldtab@ = @Expr.0.fieldtab@;
			
			@i @Expr.node@ = NULL;
			@codegen @Expr.0.node@ = new_op(T_NEQ, @Term.0.node@, @Term.1.node@);
		@}
	| Term
		@{
			@i @Term.0.vartab@   = @Expr.0.vartab@;
			@i @Term.0.visscope@ = @Expr.0.visscope@;
			@i @Term.0.fieldtab@ = @Expr.0.fieldtab@;
			
			@i @Expr.node@ = NULL;
			@codegen @Expr.node@ = @Term.node@;
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
			
			@i @Term.node@ = NULL;
			@codegen @Term.node@ = @Expr.node@;
		@}
	| NUMBER
		/* we don't care for no numbers */
		@{
			@i @Term.node@ = NULL;
			@codegen @Term.node@ = new_num(@NUMBER.val@);
		@}
	| Term '.' IDENTIFIER  /* Lesender Feldzugriff */
		@{
			/* check if IDENTIFIER is a defined field */
			@checkscope symtab_isdef( @Term.0.fieldtab@, @IDENTIFIER.0.name@);
		
			/* and as always there is stuff to get down */
			@i @Term.1.vartab@   = @Term.0.vartab@;
			@i @Term.1.visscope@ = @Term.0.visscope@;
			@i @Term.1.fieldtab@ = @Term.0.fieldtab@;	
			
			@i @Term.node@ = NULL;
			/*@codegen @Term.node@ = new_num(@NUMBER.val@);*/
		@}
	| IDENTIFIER  /* Lesender Variablenzugriff */
		@{
			@i @Term.node@ = NULL;
			@codegen @Term.node@ = new_var(@IDENTIFIER.name@, stentry_reg(@Term.vartab@, @IDENTIFIER.name@));
			
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
			
			/* there will not be any function calls */
			@i @Term.node@ = NULL;
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
	
	output = stdout;

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

char *next_reg(void)
{
	regcursor += 1;
	if( regcursor < 0 || regcursor > 5 )
	{
		return NULL;
	}
	return registers[regcursor];
}

void reset_regcursor(void)
{
	regcursor = -1;
}




