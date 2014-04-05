
%{

extern int yylex();
extern int yyparse();
extern void yyerror(const char*);

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
	 
Stat: RETURN Expr
	| COND { Expr THEN Stats END ';' } END 
	| LET { IDENTIFIER '=' Expr ';' } IN Stats END
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
	| IDENTIFIER			 /* Lesender Variablenzugriff */
	| IDENTIFIER '(' /*{ Expr ',' }*/ Exprlist '[' Expr ']' ')' 	/* Funktionsaufruf */ 
	;

%%