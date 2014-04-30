
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
	
	/* if field entry this is the name  of the
	 * struct this field belongs to, NULL else */
	char *ref;  
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
symtab *symtab_add(symtab *tab, char *name, char *ref);
symtab *symtab_dup(symtab *src, symtab *dest);
symtab *symtab_merge(symtab *tab1, symtab *tab2);
symtab *symtab_subtab(symtab *ftab, char *name);
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

@attributes { char *name; } 											IDENTIFIER

@attributes { symtab *structtab; symtab *fieldtab; } 					Program
@attributes { symtab *structtab; symtab *fieldtab; }					Def
@attributes { symtab *vartab; } 										ParamDef
@attributes { symtab *vartab; }											ParamList
@attributes { symtab *fieldtab; char *structname; }						StuctFieldDef
@attributes { symtab *fieldtab; char *structname; }						FieldDef
@attributes { symtab *fieldtab; char *structname; }						FieldList
@attributes { symtab *structtab; symtab *fieldtab; }					Structdef
@attributes { symtab *structtab; symtab *fieldtab; }					Funcdef
@attributes { symtab *structtab; symtab *fieldtab; symtab *vartab; }	Stats
@attributes { symtab *structtab; symtab *fieldtab; symtab *vartab; }	Condlist
@attributes { symtab *fieldtab; symtab *vartab; }						LetDef
@attributes { symtab *fieldtab; symtab *vartab; }						LetParamDef
@attributes { symtab *fieldtab; symtab *vartab; }						LetList
@attributes { symtab *structtab; symtab *fieldtab; symtab *vartab; }	Stat
@attributes { symtab *fieldtab; symtab *vartab; }						Notexpr
@attributes { symtab *fieldtab; symtab *vartab; }						Addexpr
@attributes { symtab *fieldtab; symtab *vartab; }						Mulexpr
@attributes { symtab *fieldtab; symtab *vartab; }						Orexpr
@attributes { symtab *fieldtab; symtab *vartab; }						Expr
@attributes { symtab *fieldtab; symtab *vartab; }						ExprList
@attributes { symtab *fieldtab; symtab *vartab; }						FinalArg
@attributes { symtab *fieldtab; symtab *vartab; }						Term
	
/* this is to fill the symbol tables - maybe this is not even necessary? */
@traversal @lefttoright @preorder pre

%%

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
	
ParamDef:
		@{
			/* empty var symbol table */
			@i @ParamDef.0.vartab@ = symtab_init();
		@}
	| ParamList
		@{
			/* empty var symbol table */
			@i @ParamDef.0.vartab@ = symtab_init();
			
			/* propagate new param symtab down the tree */
			@i @ParamList.0.vartab@ = @ParamDef.0.vartab@;
		@}
	;

/* this one is new - we need the distinction to init a symtab */	
ParamList: IDENTIFIER
		@{
			/* check for duplicate var definiton, add to symtab if not */
			@pre symtab_checkdup( @ParamList.0.vartab@, @IDENTIFIER.name@);
			@pre symtab_add( @ParamList.0.vartab@, @IDENTIFIER.name@);
		@}
	| ParamList IDENTIFIER
		@{
			/* check for duplicate var definiton, add to symtab if not */
			@pre symtab_checkdup( @ParamList.0.vartab@, @IDENTIFIER.name@);
			@pre symtab_add( @ParamList.0.vartab@, @IDENTIFIER.name@);
			
			/* get the var symtab down the tree */
			@i @ParamList.1.vartab@ = @ParamList.0.vartab@;
		@}
	;
	
/* this construct merely exists to be not confused with a ParamDef by the parser */
StuctFieldDef:  ':' FieldDef
		@{
			/* get the fieldtab even further down */
			@i @FieldDef.0.fieldtab@ = @StuctFieldDef.0.fieldtab@;
			@i @FieldDef.0.structname@ = @StuctFieldDef.0.structname@;
		@}
	;

FieldDef: /* empty */
		/* well, we don't have any field definitions here, so there is nothing to add */
	| FieldList
		@{
			/* and yet even further down */
			@i @FieldList.0.fieldtab@ = @FieldDef.0.fieldtab@;
			@i @FieldList.0.structname@ = @FieldDef.0.structname@;
		@}
	;
	
FieldList: IDENTIFIER
		@{	
			/* add the field name to the field list, but only if field name is unique */
			@pre symtab_checkdup( @FieldList.0.fieldtab@, @IDENTIFIER.name@);
			@pre symtab_add( @FieldList.0.fieldtab@, @IDENTIFIER.name@, @FieldList.0.structname@);
		@}
	| FieldList IDENTIFIER
		@{
			/* add the field name to the field list, but only if field name is unique */
			@pre symtab_checkdup( @FieldList.0.fieldtab@, @IDENTIFIER.name@);
			@pre symtab_add( @FieldList.0.fieldtab@, @IDENTIFIER.name@, @FieldList.0.structname@);
			
			/* we will still need this further down */
			@i @FieldList.1.fieldtab@ = @FieldList.0.fieldtab@;
			@i @FieldList.1.structname@ = @FieldList.0.structname@;
		@}
	;
		
Structdef: STRUCT IDENTIFIER StuctFieldDef END
		@{
			/* check if there already is a struct with this name */
			@pre symtab_checkdup(@Structdef.0.structtab@, @IDENTIFIER.0.name@);
			
			/* add the struct name if all went well */
			@pre symtab_add(@Structdef.0.structtab@, @IDENTIFIER.0.name@);
			
			/* get the fieldtab down to the field definitions */
			@i @StuctFieldDef.0.fieldtab@ = @Structdef.0.fieldtab@;
			
			/* the name of this struct is needed by the field --> get it down */
			@i @StuctFieldDef.0.structname@ = @IDENTIFIER.0.name@;
		@}
	;

Funcdef: FUNC IDENTIFIER '(' ParamDef ')' Stats END
		@{ 	
			/* the parameters are visible within the function --> 
			 * get the new vartab (by the ParamList) down the tree */
			@i @Stats.vartab@ = @ParamDef.vartab@;
			
			/* these come from the Def, are globally visible and may be 
			 * needed in the Stats as well --> get them down too! */
			@i @Stats.0.structtab@ = @Funcdef.0.structtab@;
			@i @Stats.0.fieldtab@  = @Funcdef.0.fieldtab@;
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
LetDef: LET LetParamDef
		@{
			@i @LetParamDef.vartab@   = @LetDef.vartab@;
			@i @LetParamDef.fieldtab@ = @LetDef.fieldtab@;
		@}
	;
	
LetParamDef:  
		/* there ain't no more to do */
	| LetList
		@{
			/* propagate Stats vartab down the tree */
			@i @LetList.0.vartab@	= @LetParamDef.0.vartab@;
			@i @LetList.0.fieldtab@ = @LetParamDef.0.fieldtab@;
		@}
	;

LetList: IDENTIFIER '=' Expr 
		@{			
			/* now we define a new variable */
			@pre symtab_checkdup( @LetList.0.vartab@, @IDENTIFIER.0.name@);
			@pre symtab_add( @LetList.0.vartab@, @IDENTIFIER.0.name@);
			
			/* this may be needed further down */
			@i @Expr.0.vartab@   = @LetList.0.vartab@;
			@i @Expr.0.fieldtab@ = @LetList.0.fieldtab@;
		@}
	| LetList IDENTIFIER '=' Expr  ';'
		@{
			/* now we define a new variable */
			@pre symtab_checkdup( @LetList.0.vartab@, @IDENTIFIER.0.name@);
			@pre symtab_add( @LetList.0.vartab@, @IDENTIFIER.0.name@);
			
			/* this may be needed by the Expr further down */
			@i @Expr.0.vartab@   = @LetList.0.vartab@;
			@i @Expr.0.fieldtab@ = @LetList.0.fieldtab@;
			
			/* and of course, the next LetList will need this as well */
			@i @LetList.1.vartab@   = @LetList.0.vartab@;
			@i @LetList.1.fieldtab@ = @LetList.0.fieldtab@;
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
		@}
	| LetDef IN Stats END
		@{ 
			/* in here new variables may be added - fork the vartab to ensure visibility scope */
			@i @LetDef.0.vartab@ = symtab_init();
			@pre symtab_dup( @Stat.0.vartab@, @LetDef.0.vartab@);
			
			/* the new vartab is visible in the following Stats */
			@i @Stats.0.vartab@ = @LetDef.0.vartab@;
			
			/* and the fieldtab may be needed as well */
			@i @LetDef.0.fieldtab@ = @Stat.0.fieldtab@;
			@i @Stats.0.fieldtab@  = @Stat.0.fieldtab@;
			
			/* and the Stats may define a with block even now --> get down the structtab */
			@i @Stats.0.structtab@ = @Stat.0.structtab@;
		@}
	| WITH Expr ':' IDENTIFIER DO Stats END
		@{
			/* check if IDENTIFIER is a valid struct */
			@pre symtab_isdef( @Stat.0.structtab@, @IDENTIFIER.0.name@);
			
			/* good! now get all fields of the struct into a new symtab
			 * --> these will be added to the varscope of the with-block.  
			 * yet, we will need the already defined variables as well, so
			 * merge these two symtables into one
			 * NOTE: the result will be in arg2 (so the return * of the function 
			 * -- a new symtab to ensure scope), and the elements of arg1 will be
			 * appended as copies, so no mixup with the original elements */
			@pre @Stats.vartab@ = symtab_merge( @Stat.vartab@, symtab_subtab( @Stat.fieldtab@, @IDENTIFIER.0.name@));
			
			/* and we have to pass things on as well */
			@i @Stats.fieldtab@  = @Stat.fieldtab@;
			@i @Stats.structtab@ = @Stat.structtab@;
			
			@i @Expr.vartab@   = @Stat.vartab@;
			@i @Expr.fieldtab@ = @Stat.fieldtab@;
		@}
	| Lexpr '=' Expr 	/* Zuweisung */ 
		@{
			/* onwards down the tree! */
			@i @Lexpr.vartab@ = @Stat.vartab@;
			@i @Expr.vartab@  = @Stat.vartab@;	
				
			@i @Lexpr.fieldtab@ = @Stat.fieldtab@;
			@i @Expr.fieldtab@  = @Stat.fieldtab@;
		@}
	| Term
		@{
			/* down the rabbit hole! */
			@i @Term.vartab@ 	= @Stat.vartab@;
			@i @Term.fieldtab@ = @Stat.fieldtab@;	
		@}
	;
	
Lexpr: Term '.' IDENTIFIER 	/* Schreibender Feldzugriff 		*/ 
		@{
			/* check if IDENTIFIER is a defined field */
			@pre symtab_isdef( @Lexpr.0.fieldtab@, @IDENTIFIER.0.name@);
				
			/* and as always there is stuff to get down */
			@i @Term.vartab@ 	= @Lexpr.vartab@;
			@i @Term.fieldtab@ = @Lexpr.fieldtab@;	
		@}
	
	| IDENTIFIER  /* Schreibender Variablenzugriff 	*/ 
		@{
			/* check if IDENTIFIER is a visible variable */
			@pre symtab_isdef( @Lexpr.0.vartab@, @IDENTIFIER.0.name@);
		@}
	;
	
Notexpr: '-' Term
		@{
			@i @Term.vartab@   = @Notexpr.vartab@;
			@i @Term.fieldtab@ = @Notexpr.fieldtab@;
		@}
	| NOT Term
		@{
			@i @Term.vartab@   = @Notexpr.vartab@;
			@i @Term.fieldtab@ = @Notexpr.fieldtab@;
		@}
	| '-' Notexpr
		@{
			@i @Notexpr.1.vartab@   = @Notexpr.0.vartab@;
			@i @Notexpr.1.fieldtab@ = @Notexpr.0.fieldtab@;
		@}
	| NOT Notexpr 
		@{
			@i @Notexpr.1.vartab@   = @Notexpr.0.vartab@;
			@i @Notexpr.1.fieldtab@ = @Notexpr.0.fieldtab@;
		@}
	;
	
Addexpr: Term '+' Term
		@{
			@i @Term.0.vartab@ = @Addexpr.0.vartab@;
			@i @Term.1.vartab@ = @Addexpr.0.vartab@;
			
			@i @Term.0.fieldtab@ = @Addexpr.0.fieldtab@;
			@i @Term.1.fieldtab@ = @Addexpr.0.fieldtab@;
		@}	
	| Addexpr '+' Term
		@{
			@i @Term.0.vartab@    = @Addexpr.0.vartab@;
			@i @Addexpr.1.vartab@ = @Addexpr.0.vartab@;
		
			@i @Term.0.fieldtab@    = @Addexpr.0.fieldtab@;
			@i @Addexpr.1.fieldtab@ = @Addexpr.0.fieldtab@;
		@}	
	;
	
Mulexpr: Term '*' Term
		@{
			@i @Term.0.vartab@ = @Mulexpr.0.vartab@;
			@i @Term.1.vartab@ = @Mulexpr.0.vartab@;
	
			@i @Term.0.fieldtab@ = @Mulexpr.0.fieldtab@;
			@i @Term.1.fieldtab@ = @Mulexpr.0.fieldtab@;
		@}	
	| Mulexpr '*' Term
		@{
			@i @Term.0.vartab@    = @Mulexpr.0.vartab@;
			@i @Mulexpr.1.vartab@ = @Mulexpr.0.vartab@;

			@i @Term.0.fieldtab@    = @Mulexpr.0.fieldtab@;
			@i @Mulexpr.1.fieldtab@ = @Mulexpr.0.fieldtab@;
		@}	
	;
	
Orexpr: Term OR Term
		@{
			@i @Term.0.vartab@ = @Orexpr.0.vartab@;
			@i @Term.1.vartab@ = @Orexpr.0.vartab@;

			@i @Term.0.fieldtab@ = @Orexpr.0.fieldtab@;
			@i @Term.1.fieldtab@ = @Orexpr.0.fieldtab@;
		@}	
	| Orexpr OR Term
		@{
			@i @Term.0.vartab@   = @Orexpr.0.vartab@;
			@i @Orexpr.1.vartab@ = @Orexpr.0.vartab@;

			@i @Term.0.fieldtab@   = @Orexpr.0.fieldtab@;
			@i @Orexpr.1.fieldtab@ = @Orexpr.0.fieldtab@;
		@}	
	;

Expr: Notexpr
		@{
			@i @Notexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Notexpr.0.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Addexpr
		@{
			@i @Addexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Addexpr.0.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Mulexpr
		@{
			@i @Mulexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Mulexpr.0.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Orexpr
		@{
			@i @Orexpr.0.vartab@   = @Expr.0.vartab@;
			@i @Orexpr.0.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Term '>' Term
		@{
			@i @Term.0.vartab@   = @Expr.0.vartab@;
			@i @Term.0.fieldtab@ = @Expr.0.fieldtab@;
			
			@i @Term.1.vartab@   = @Expr.0.vartab@;
			@i @Term.1.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Term NOTEQUAL Term 
		@{
			@i @Term.0.vartab@   = @Expr.0.vartab@;
			@i @Term.0.fieldtab@ = @Expr.0.fieldtab@;
		
			@i @Term.1.vartab@   = @Expr.0.vartab@;
			@i @Term.1.fieldtab@ = @Expr.0.fieldtab@;
		@}
	| Term
		@{
			@i @Term.0.vartab@   = @Expr.0.vartab@;
			@i @Term.0.fieldtab@ = @Expr.0.fieldtab@;
		@}
	;
	
ExprList: /* empty */
		/* there ain't no more to do */
	| ExprList Expr ','
		@{
			/* we didn't have anything to get down for quite a while */
			@i @ExprList.1.vartab@ = @ExprList.0.vartab@;
			@i @Expr.0.vartab@ 	   = @ExprList.0.vartab@;
				
			@i @ExprList.1.fieldtab@ = @ExprList.0.fieldtab@;
			@i @Expr.0.fieldtab@ 	 = @ExprList.0.fieldtab@;
		@}
	; 
	
FinalArg: /* empty */
		/* there ain't no more to do */
	| Expr
		@{
			@i @Expr.vartab@   = @FinalArg.vartab@;
			@i @Expr.fieldtab@ = @FinalArg.fieldtab@;
		@}
	; 
		
Term: '(' Expr ')'
		@{
			@i @Expr.vartab@   = @Term.vartab@;
			@i @Expr.fieldtab@ = @Term.fieldtab@;
		@}
	| NUMBER
		/* we don't care for no numbers */
	| Term '.' IDENTIFIER  /* Lesender Feldzugriff */
		@{
			/* check if IDENTIFIER is a defined field */
			@pre symtab_isdef( @Term.0.fieldtab@, @IDENTIFIER.0.name@);
			
			/* and as always there is stuff to get down */
			@i @Term.1.vartab@   = @Term.0.vartab@;
			@i @Term.1.fieldtab@ = @Term.0.fieldtab@;	
		@}
	| IDENTIFIER  /* Lesender Variablenzugriff */
		@{
			/* check if IDENTIFIER is a defined variable */
			@pre symtab_isdef( @Term.0.vartab@, @IDENTIFIER.0.name@);
		@}
	| IDENTIFIER '(' /*{ Expr ',' }*/ ExprList FinalArg ')' 	/* Funktionsaufruf */ 
		@{
			/* IDENTIFIER is the name of the function --> ignore */
			@i @ExprList.vartab@ = @Term.vartab@;
			@i @FinalArg.vartab@ 	 = @Term.vartab@;
			
			@i @ExprList.fieldtab@ = @Term.fieldtab@;
			@i @FinalArg.fieldtab@	   = @Term.fieldtab@;
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

symtab *symtab_init(void)
{
	symtable *tab = malloc(sizeof(symtable));
	tab->first = NULL;
	tab->last = NULL;
	return tab;
}

symtab *symtab_add(symtab *tab, char *name)
{
	return symtab_add(tab, name, NULL);
}

symtab *symtab_add(symtab *tab, char *name, char *ref)
{
	symtabentry *entry = stentry_init();
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
 * adds every element of 
 */
symtab *symtab_merge(symtab *tab1, symtab *tab2)
{
	symtabentry *cursor = tab1->first;
	while(cursor != NULL) {
		stentry_append(tab2, stentry_dup(cursor)); /* append a copy! */
	}
	return tab2;
}

/* search all entries of a symtab for element having a *ref equal to 'name'
 * returns a new symtab with these elements, all elements are copies of there originals
 */
symtab *symtab_subtab(symtab *ftab, char *name)
{
	symtab *fstab = symtab_init(); /* fields of struct */
	symtabentry *cursor = ftab->first;
	while(cursor != NULL) {
		if(strcmp(name, cursor->ref) == 0) {
			stentry_append(fstab, stentry_dup(cursor)); /* append a copy! */
		}
		cursor = cursor->next;
	}
	return fstab;
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
	dup->name = strdup(entry->name);
	dup->ref  = strdup(entry->ref);
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


