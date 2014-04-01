
%{

extern int yylex();
extern int yyparse();

extern void yyerror(const char*);

%}


%token notequal

%token <nval> number
%token <sval> identifier

%%

Program: { Def ’;’ }
;

Def: 	Funcdef
   		| Structdef
		;

Structdef: 	struct id ’:’ 	/* Strukturname */ 
			{id} 			/* Felddefinition */
			end
			;

Funcdef: func id 		/* Funktionsname */
		’(’ { id } ’)’ 	/* Parameterdefinition */
		Stats end
		;

Stats: { Stat ’;’ }
     	;
	 
Stat: 	return Expr
		| cond { Expr then Stats end ’;’ } end 
		| let { id ’=’ Expr ’;’ } in Stats end
		| with Expr ’:’ id do Stats end
		| Lexpr ’=’ Expr 	/* Zuweisung */ 
		| Term
		;
	
Lexpr: 	id 				/* Schreibender Variablenzugriff */ 
		| Term ’.’ id 	/* Schreibender Feldzugriff */
		;

Expr: 	{ not | ’-’ }  Term
    	| Term { ’+’ Term }
    	| Term { ’*’ Term }
    	| Term { or Term }
    	| Term ( ’>’ | ’<>’ ) Term
    	;
	
Term: 	’(’ Expr ’)’
    	| num
		| Term ’.’ id 	 /* Lesender Feldzugriff */
		| id			 /* Lesender Variablenzugriff */
		| id ’(’ { Expr ’,’ } [ Expr ] ’)’ 	/* Funktionsaufruf */ 
		;

%%