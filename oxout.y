/* output from Ox version G1.04 */
%{
%}

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

%start yyyAugNonterm

																	
																
 									
									
					
									
 																
										
	
	
					
					
										
	
	
	
	
	
					
					
	




	




%{


struct yyyT1 { char *name; }; 
typedef struct yyyT1 *yyyP1; 


struct yyyT2 { int64_t val; }; 
typedef struct yyyT2 *yyyP2; 


struct yyyT3 { symtab_t *structtab; symtab_t *fieldtab; }; 
typedef struct yyyT3 *yyyP3; 


struct yyyT4 { symtab_t *structtab; symtab_t *fieldtab; }; 
typedef struct yyyT4 *yyyP4; 


struct yyyT5 { symtab_t *structtab; symtab_t *fieldtab; symtab_t *dummy1; }; 
typedef struct yyyT5 *yyyP5; 


struct yyyT6 { symtab_t *structtab; symtab_t *fieldtab; }; 
typedef struct yyyT6 *yyyP6; 


struct yyyT7 { symtab_t *tab; }; 
typedef struct yyyT7 *yyyP7; 


struct yyyT8 { symtab_t *fieldtab; char *structname; }; 
typedef struct yyyT8 *yyyP8; 


struct yyyT9 { symtab_t *structtab; symtab_t *fieldtab; symtab_t *vartab; tnode_t *node; }; 
typedef struct yyyT9 *yyyP9; 


struct yyyT10 { symtab_t *structtab; symtab_t *fieldtab; symtab_t *vartab; tnode_t *node; }; 
typedef struct yyyT10 *yyyP10; 


struct yyyT11 { symtab_t *structtab; symtab_t *fieldtab; symtab_t *vartab; }; 
typedef struct yyyT11 *yyyP11; 


struct yyyT12 { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; }; 
typedef struct yyyT12 *yyyP12; 


struct yyyT13 { symtab_t *fieldtab; symtab_t *vartab; }; 
typedef struct yyyT13 *yyyP13; 


struct yyyT14 { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }; 
typedef struct yyyT14 *yyyP14; 


struct yyyT15 { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }; 
typedef struct yyyT15 *yyyP15; 


struct yyyT16 { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }; 
typedef struct yyyT16 *yyyP16; 


struct yyyT17 { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }; 
typedef struct yyyT17 *yyyP17; 


struct yyyT18 { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }; 
typedef struct yyyT18 *yyyP18; 


struct yyyT19 { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; }; 
typedef struct yyyT19 *yyyP19; 


struct yyyT20 { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; }; 
typedef struct yyyT20 *yyyP20; 


struct yyyT21 { symtab_t *fieldtab; symtab_t *vartab; symtab_t *visscope; tnode_t *node; }; 
typedef struct yyyT21 *yyyP21; 
                                                      /*custom*/  
typedef unsigned char yyyWAT; 
typedef unsigned char yyyRCT; 
typedef unsigned short yyyPNT; 
typedef unsigned char yyyWST; 

#include <limits.h>
#define yyyR UCHAR_MAX  

 /* funny type; as wide as the widest of yyyWAT,yyyWST,yyyRCT  */ 
typedef unsigned short yyyFT;

                                                      /*stock*/  




struct yyyGenNode {void *parent;  
                   struct yyyGenNode **cL; /* child list */ 
                   yyyRCT *refCountList; 
                   yyyPNT prodNum;                      
                   yyyWST whichSym; /* which child of parent? */ 
                  }; 

typedef struct yyyGenNode yyyGNT; 



struct yyyTB {int isEmpty; 
              int typeNum; 
              int nAttrbs; 
              char *snBufPtr; 
              yyyWAT *startP,*stopP; 
             };  




extern struct yyyTB yyyTermBuffer; 
extern yyyWAT yyyLRCIL[]; 
extern void yyyGenLeaf(); 


%}

%{
#include <stdio.h>

int yyyYok = 1;
int yyyInitDone = 0;
char *yyySTsn;
yyyGNT *yyySTN;
int yyyGNSz = sizeof(yyyGNT);
int yyyProdNum,yyyRHSlength,yyyNattrbs,yyyTypeNum; 

extern yyyFT yyyRCIL[];

void yyyExecuteRRsection();
void yyyYoxInit();
void yyyYoxReset();
void yyyDecorate();
void yyyGenIntNode();
void yyyAdjustINRC();
void yyyPrune();
void yyyUnsolvedInstSearchTrav();
void yyyUnsolvedInstSearchTravAux();
void yyyerror();
void yyyShift();



#define yyyRSU(NUM1,NUM2,NUM3,NUM4) \
   yyyProdNum=NUM1;yyyRHSlength=NUM2;yyyNattrbs=NUM3;yyyTypeNum=NUM4;\
   if ((yychar <= 0) && (!yyyTermBuffer.isEmpty)) yyyShift(); 
%}


%%
	
yyyAugNonterm 
	:	{if (!yyyInitDone) 
		    {yyyYoxInit(); 
		     yyyInitDone = 1;
		    }
		 yyyYoxReset();
		}
		Start
		{
		 yyyDecorate(); yyyExecuteRRsection();
		}
	;
Start: Program
	{if(yyyYok){
yyyRSU(1,1,0,0);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+0,yyyRCIL+0);/*yyyPrune(1);*/}};

Program: /* empty */
		{if(yyyYok){
yyyRSU(2,0,2,3);
yyyGenIntNode();
/* init empty struct symbol table */ (((yyyP3)yyySTsn)->structtab) = symtab_init();
			
			/* init empty field symbol table */
			 (((yyyP3)yyySTsn)->fieldtab) = symtab_init();
		yyyAdjustINRC(yyyRCIL+0,yyyRCIL+6);}}
	| Program Def ';'
		{if(yyyYok){
yyyRSU(3,3,2,3);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+6,yyyRCIL+18);/*yyyPrune(3);*/}}
	; 

Def: Funcdef
		{if(yyyYok){
yyyRSU(4,1,2,4);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+18,yyyRCIL+24);}}
	| Structdef
		{if(yyyYok){
yyyRSU(5,1,2,4);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+24,yyyRCIL+30);}}
	;
	
Structdef: STRUCT IDENTIFIER ':' FieldDef END
		{if(yyyYok){
yyyRSU(6,5,3,5);
yyyGenIntNode();
 (((yyyP8)(((char *)((yyySTN->cL)[3]))+yyyGNSz))->structname) = (((yyyP1)(((char *)((yyySTN->cL)[1]))+yyyGNSz))->name);
		yyyAdjustINRC(yyyRCIL+30,yyyRCIL+39);}}
	;
	
FieldDef:

	{if(yyyYok){
yyyRSU(7,0,2,8);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+39,yyyRCIL+39);}}| FieldDef IDENTIFIER
		{if(yyyYok){
yyyRSU(8,2,2,8);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+39,yyyRCIL+45);}}
	;
	
	
ParamDef: 
		{if(yyyYok){
yyyRSU(9,0,1,7);
yyyGenIntNode();
 (((yyyP7)yyySTsn)->tab) = symtab_init();
		yyyAdjustINRC(yyyRCIL+45,yyyRCIL+48);}}
		
	| ParamDef IDENTIFIER
		{if(yyyYok){
yyyRSU(10,2,1,7);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+48,yyyRCIL+51);/*yyyPrune(10);*/}}
	;
	
Funcdef: FUNC IDENTIFIER '(' ParamDef ')' Stats END
		{if(yyyYok){
yyyRSU(11,7,2,6);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+51,yyyRCIL+60);}}
	;

	
Stats: /* empty */
		{if(yyyYok){
yyyRSU(12,0,4,9);
yyyGenIntNode();
 (((yyyP9)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+60,yyyRCIL+63);}}
	| Stat ';' Stats		
		{if(yyyYok){
yyyRSU(13,3,4,9);
yyyGenIntNode();
 (((yyyP9)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+63,yyyRCIL+84);}}
	;
	
Stat: RETURN Expr
		{if(yyyYok){
yyyRSU(14,2,4,10);
yyyGenIntNode();
 (((yyyP10)yyySTsn)->node) = NULL;
			
			yyyAdjustINRC(yyyRCIL+84,yyyRCIL+96);}}
	| COND Condlist END 
		{if(yyyYok){
yyyRSU(15,3,4,10);
yyyGenIntNode();
 (((yyyP10)yyySTsn)->node) = NULL;
		yyyAdjustINRC(yyyRCIL+96,yyyRCIL+108);}}
	| LET LetDef IN Stats END
		{if(yyyYok){
yyyRSU(16,5,4,10);
yyyGenIntNode();
 (((yyyP10)yyySTsn)->node) = NULL;
		yyyAdjustINRC(yyyRCIL+108,yyyRCIL+126);}}
	| WITH Expr ':' IDENTIFIER DO Stats END
		{if(yyyYok){
yyyRSU(17,7,4,10);
yyyGenIntNode();
 (((yyyP10)yyySTsn)->node) = NULL;
		yyyAdjustINRC(yyyRCIL+126,yyyRCIL+147);}}
	| Lexpr '=' Expr 	/* Zuweisung */ 
		{if(yyyYok){
yyyRSU(18,3,4,10);
yyyGenIntNode();
 (((yyyP10)yyySTsn)->node) = NULL;
		yyyAdjustINRC(yyyRCIL+147,yyyRCIL+165);}}
	| Term
		{if(yyyYok){
yyyRSU(19,1,4,10);
yyyGenIntNode();
 (((yyyP10)yyySTsn)->node) = NULL;
		yyyAdjustINRC(yyyRCIL+165,yyyRCIL+177);}}
	;

Condlist:  /* empty */ 
		/* there ain't no more to do */
	{if(yyyYok){
yyyRSU(20,0,3,11);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+177,yyyRCIL+177);}}| Condlist Expr THEN Stats END ';'
		{if(yyyYok){
yyyRSU(21,6,3,11);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+177,yyyRCIL+204);}}
	;

LetDef: 
		{if(yyyYok){
yyyRSU(22,0,3,12);
yyyGenIntNode();
 (((yyyP12)yyySTsn)->vartab) = symtab_init();
		yyyAdjustINRC(yyyRCIL+204,yyyRCIL+207);}}
	| LetDef IDENTIFIER '=' Expr  ';' 
		{if(yyyYok){
yyyRSU(23,5,3,12);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+207,yyyRCIL+225);}}
	; 

Lexpr: Term '.' IDENTIFIER 	/* Schreibender Feldzugriff 		*/ 
		{if(yyyYok){
yyyRSU(24,3,2,13);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+225,yyyRCIL+234);}}

	| IDENTIFIER  /* Schreibender Variablenzugriff 	*/ 
		{if(yyyYok){
yyyRSU(25,1,2,13);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+234,yyyRCIL+234);/*yyyPrune(25);*/}}
	;

Notexpr: '-' Term
		{if(yyyYok){
yyyRSU(26,2,4,14);
yyyGenIntNode();
 (((yyyP14)yyySTsn)->node) = NULL;	
			yyyAdjustINRC(yyyRCIL+234,yyyRCIL+246);}}
	| NOT Term
		{if(yyyYok){
yyyRSU(27,2,4,14);
yyyGenIntNode();
 (((yyyP14)yyySTsn)->node) = NULL;	
			yyyAdjustINRC(yyyRCIL+246,yyyRCIL+258);}}
	| '-' Notexpr
		{if(yyyYok){
yyyRSU(28,2,4,14);
yyyGenIntNode();
 (((yyyP14)yyySTsn)->node) = NULL;	
			yyyAdjustINRC(yyyRCIL+258,yyyRCIL+270);}}
	| NOT Notexpr 
		{if(yyyYok){
yyyRSU(29,2,4,14);
yyyGenIntNode();
 (((yyyP14)yyySTsn)->node) = NULL;	
			yyyAdjustINRC(yyyRCIL+270,yyyRCIL+282);}}
	;

Addexpr: Term '+' Term
		{if(yyyYok){
yyyRSU(30,3,4,15);
yyyGenIntNode();
 (((yyyP15)yyySTsn)->node) = NULL;	
			yyyAdjustINRC(yyyRCIL+282,yyyRCIL+303);}}	
	| Addexpr '+' Term
		{if(yyyYok){
yyyRSU(31,3,4,15);
yyyGenIntNode();
 (((yyyP15)yyySTsn)->node) = NULL;	
			yyyAdjustINRC(yyyRCIL+303,yyyRCIL+324);}}	
	;

Mulexpr: Term '*' Term
		{if(yyyYok){
yyyRSU(32,3,4,16);
yyyGenIntNode();
 (((yyyP16)yyySTsn)->node) = NULL;	
			yyyAdjustINRC(yyyRCIL+324,yyyRCIL+345);}}	
	| Mulexpr '*' Term
		{if(yyyYok){
yyyRSU(33,3,4,16);
yyyGenIntNode();
 (((yyyP16)yyySTsn)->node) = NULL;	
			yyyAdjustINRC(yyyRCIL+345,yyyRCIL+366);}}	
	;

Orexpr: Term OR Term
		{if(yyyYok){
yyyRSU(34,3,4,17);
yyyGenIntNode();
 (((yyyP17)yyySTsn)->node) = NULL;	
			yyyAdjustINRC(yyyRCIL+366,yyyRCIL+387);}}	
	| Orexpr OR Term
		{if(yyyYok){
yyyRSU(35,3,4,17);
yyyGenIntNode();
 (((yyyP17)yyySTsn)->node) = NULL;	
			yyyAdjustINRC(yyyRCIL+387,yyyRCIL+408);}}	
	;

Expr: Notexpr
		{if(yyyYok){
yyyRSU(36,1,4,18);
yyyGenIntNode();
 (((yyyP18)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+408,yyyRCIL+420);}}
	| Addexpr
		{if(yyyYok){
yyyRSU(37,1,4,18);
yyyGenIntNode();
 (((yyyP18)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+420,yyyRCIL+432);}}
	| Mulexpr
		{if(yyyYok){
yyyRSU(38,1,4,18);
yyyGenIntNode();
 (((yyyP18)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+432,yyyRCIL+444);}}
	| Orexpr
		{if(yyyYok){
yyyRSU(39,1,4,18);
yyyGenIntNode();
 (((yyyP18)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+444,yyyRCIL+456);}}
	| Term '>' Term
		{if(yyyYok){
yyyRSU(40,3,4,18);
yyyGenIntNode();
 (((yyyP18)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+456,yyyRCIL+477);}}
	| Term NOTEQUAL Term 
		{if(yyyYok){
yyyRSU(41,3,4,18);
yyyGenIntNode();
 (((yyyP18)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+477,yyyRCIL+498);}}
	| Term
		{if(yyyYok){
yyyRSU(42,1,4,18);
yyyGenIntNode();
 (((yyyP18)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+498,yyyRCIL+510);}}
	;

ExprList: /* empty */
		/* there ain't no more to do */
	{if(yyyYok){
yyyRSU(43,0,3,19);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+510,yyyRCIL+510);}}| ExprList Expr ','
		{if(yyyYok){
yyyRSU(44,3,3,19);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+510,yyyRCIL+528);}}
	; 

FinalArg: /* empty */
		/* there ain't no more to do */
	{if(yyyYok){
yyyRSU(45,0,3,20);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+528,yyyRCIL+528);}}| Expr
		{if(yyyYok){
yyyRSU(46,1,3,20);
yyyGenIntNode();
yyyAdjustINRC(yyyRCIL+528,yyyRCIL+537);}}
	; 
	
Term: '(' Expr ')'
		{if(yyyYok){
yyyRSU(47,3,4,21);
yyyGenIntNode();
 (((yyyP21)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+537,yyyRCIL+549);}}
	| NUMBER
		/* we don't care for no numbers */
		{if(yyyYok){
yyyRSU(48,1,4,21);
yyyGenIntNode();
 (((yyyP21)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+549,yyyRCIL+552);/*yyyPrune(48);*/}}
	| Term '.' IDENTIFIER  /* Lesender Feldzugriff */
		{if(yyyYok){
yyyRSU(49,3,4,21);
yyyGenIntNode();
 (((yyyP21)yyySTsn)->node) = NULL;
			/*@codegen @Term.node@ = new_num(@NUMBER.val@);*/
		yyyAdjustINRC(yyyRCIL+552,yyyRCIL+564);}}
	| IDENTIFIER  /* Lesender Variablenzugriff */
		{if(yyyYok){
yyyRSU(50,1,4,21);
yyyGenIntNode();
 (((yyyP21)yyySTsn)->node) = NULL;
			yyyAdjustINRC(yyyRCIL+564,yyyRCIL+567);/*yyyPrune(50);*/}}
	| IDENTIFIER '(' /*{ Expr ',' }*/ ExprList FinalArg ')' 	/* Funktionsaufruf */ 
		{if(yyyYok){
yyyRSU(51,5,4,21);
yyyGenIntNode();
 (((yyyP21)yyySTsn)->node) = NULL;
		yyyAdjustINRC(yyyRCIL+567,yyyRCIL+588);}}
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




                                                      /*custom*/  
long yyyMaxNbytesNodeStg = 2000000; 
long yyyMaxNrefCounts =    500000; 
long yyyMaxNchildren =     60000; 
long yyyMaxStackSize =     2000; 
long yyySSALspaceSize =    20000; 
long yyyRSmaxSize =        1000; 
long yyyTravStackMaxSize = 2000; 


struct yyyTB yyyTermBuffer; 

char *yyyNodeAndStackSpace; 

char *yyyNodeSpace;
char *yyyNextNodeSpace; 
char *yyyAfterNodeSpace; 


 
struct yyyGenNode **yyyChildListSpace;  
struct yyyGenNode **yyyNextCLspace; 
struct yyyGenNode **yyyAfterChildListSpace; 



yyyRCT *yyyRefCountListSpace;
yyyRCT *yyyNextRCLspace;  
yyyRCT *yyyAfterRefCountListSpace;   



struct yyySolvedSAlistCell {yyyWAT attrbNum; 
                            long next; 
                           }; 
#define yyyLambdaSSAL 0 
long yyySSALCfreeList = yyyLambdaSSAL; 
long yyyNewSSALC = 1; 
 
struct yyySolvedSAlistCell *yyySSALspace; 


 
struct yyyStackItem {struct yyyGenNode *node; 
                     long solvedSAlist; 
                     struct yyyGenNode *oldestNode; 
                    };  

long yyyNbytesStackStg; 
struct yyyStackItem *yyyStack; 
struct yyyStackItem *yyyAfterStack; 
struct yyyStackItem *yyyStackTop; 



struct yyyRSitem {yyyGNT *node; 
                  yyyWST whichSym; 
                  yyyWAT wa;  
                 };  

struct yyyRSitem *yyyRS;  
struct yyyRSitem *yyyRSTop;  
struct yyyRSitem *yyyAfterRS;  
 





yyyFT yyyRCIL[] = {
yyyR,0,0, yyyR,1,0, yyyR,0,1, yyyR,1,1, 1,0,1, 1,1,1, 
0,0,1, 0,1,1, 0,0,1, 0,1,1, yyyR,2,1, 3,0,1, 
3,1,0, 0,0,2, 0,1,1, yyyR,0,0, yyyR,0,1, 5,0,1, 
5,1,1, 5,2,1, yyyR,3,0, yyyR,3,0, 0,0,1, 0,1,1, 
0,2,1, 2,0,1, 2,1,1, 2,2,1, yyyR,3,0, 1,0,1, 
1,1,1, 1,2,1, yyyR,3,0, 1,0,1, 1,1,1, 1,2,1, 
yyyR,3,0, 1,0,1, 1,2,1, 3,0,1, 3,1,1, 3,2,2, 
yyyR,3,0, 1,0,1, 1,1,1, 1,2,1, 5,0,1, 5,1,1, 
5,2,2, yyyR,3,0, 0,0,1, 0,1,1, 2,0,1, 2,1,1, 
2,2,1, yyyR,3,0, 0,0,1, 0,1,1, 0,2,1, 0,0,1, 
0,1,1, 0,2,1, 1,0,1, 1,1,1, 1,2,1, 3,0,1, 
3,1,1, 3,2,1, yyyR,1,0, yyyR,1,1, 0,0,1, 0,2,1, 
3,0,1, 3,1,1, 3,2,1, 0,0,1, 0,1,1, 0,2,1, 
yyyR,3,0, 1,0,1, 1,1,1, 1,2,1, yyyR,3,0, 1,0,1, 
1,1,1, 1,2,1, yyyR,3,0, 1,0,1, 1,1,1, 1,2,1, 
yyyR,3,0, 1,0,1, 1,1,1, 1,2,1, yyyR,3,0, 0,0,1, 
0,1,1, 0,2,1, 2,0,1, 2,1,1, 2,2,1, yyyR,3,0, 
0,0,1, 0,1,1, 0,2,1, 2,0,1, 2,1,1, 2,2,1, 
yyyR,3,0, 0,0,1, 0,1,1, 0,2,1, 2,0,1, 2,1,1, 
2,2,1, yyyR,3,0, 0,0,1, 0,1,1, 0,2,1, 2,0,1, 
2,1,1, 2,2,1, yyyR,3,0, 0,0,1, 0,1,1, 0,2,1, 
2,0,1, 2,1,1, 2,2,1, yyyR,3,0, 0,0,1, 0,1,1, 
0,2,1, 2,0,1, 2,1,1, 2,2,1, yyyR,3,0, 0,0,1, 
0,1,1, 0,2,1, yyyR,3,0, 0,0,1, 0,1,1, 0,2,1, 
yyyR,3,0, 0,0,1, 0,1,1, 0,2,1, yyyR,3,0, 0,0,1, 
0,1,1, 0,2,1, yyyR,3,0, 0,0,1, 0,1,1, 0,2,1, 
2,0,1, 2,1,1, 2,2,1, yyyR,3,0, 0,0,1, 0,1,1, 
0,2,1, 2,0,1, 2,1,1, 2,2,1, yyyR,3,0, 0,0,1, 
0,1,1, 0,2,1, 0,0,1, 0,1,1, 0,2,1, 1,0,1, 
1,1,1, 1,2,1, 0,0,1, 0,1,1, 0,2,1, yyyR,3,0, 
1,0,1, 1,1,1, 1,2,1, yyyR,3,0, yyyR,3,0, 0,0,1, 
0,1,1, 0,2,1, yyyR,3,0, yyyR,3,0, 2,0,1, 2,1,1, 
2,2,1, 3,0,1, 3,1,1, 3,2,1, 
};

short yyyIIIEL[] = {0,
0,2,3,7,9,11,17,18,21,22,
25,33,34,38,41,45,51,59,63,65,
66,73,74,80,84,86,89,92,95,98,
102,106,110,114,118,122,124,126,128,130,
134,138,140,141,145,146,148,152,154,158,
160,
};

long yyyIIEL[] = {
0,0,2,4,6,8,10,10,12,14,16,19,
22,22,23,23,25,25,27,29,31,32,33,34,
35,36,38,38,39,39,40,40,44,44,48,52,
56,56,60,64,64,68,72,72,75,75,79,79,
82,82,86,86,90,90,94,94,95,95,99,99,
103,105,105,109,113,117,120,123,126,130,130,134,
134,134,137,140,143,144,144,148,148,150,154,154,
155,157,158,162,162,166,170,170,174,178,178,182,
186,186,190,194,198,198,202,206,210,210,214,218,
222,222,226,230,234,234,238,242,246,246,250,254,
258,258,262,266,270,274,278,282,286,290,294,298,
302,302,306,310,314,314,318,322,326,329,332,335,
339,339,342,345,349,353,353,357,357,361,362,366,
370,370,371,375,376,380,381,381,384,387,
};

long yyyIEL[] = {
0,0,0,0,0,0,0,4,
8,8,8,10,12,12,12,14,
16,16,16,16,18,20,20,24,
24,24,24,24,26,30,30,30,
32,32,32,34,36,38,40,40,
42,42,42,42,42,42,42,42,
42,44,46,48,48,50,52,54,
54,54,54,54,54,54,56,60,
60,60,60,60,60,62,64,66,
66,66,66,66,68,72,76,76,
76,78,78,78,78,78,78,80,
86,92,92,92,92,92,92,94,
94,94,94,94,94,98,104,104,
104,104,104,104,104,104,104,104,
110,110,110,110,110,110,110,110,
110,114,120,128,128,128,128,128,
128,128,128,128,128,128,128,128,
128,128,132,134,138,138,140,140,
142,142,142,142,142,144,148,148,
148,148,148,148,148,148,148,150,
152,154,154,154,154,154,154,156,
158,160,160,160,160,160,160,162,
164,166,166,166,166,166,166,168,
170,172,172,172,172,172,172,176,
180,184,184,184,184,184,184,184,
184,184,184,188,192,196,196,196,
196,196,196,196,196,196,196,200,
204,208,208,208,208,208,208,208,
208,208,208,212,216,220,220,220,
220,220,220,220,220,220,220,224,
228,232,232,232,232,232,232,232,
232,232,232,236,240,244,244,244,
244,244,244,244,244,244,244,246,
248,250,250,250,250,250,250,252,
254,256,256,256,256,256,256,258,
260,262,262,262,262,262,262,264,
266,268,268,268,268,268,268,272,
276,280,280,280,280,280,280,280,
280,280,280,284,288,292,292,292,
292,292,292,292,292,292,292,294,
296,298,298,298,298,298,298,298,
298,298,302,306,308,308,308,308,
308,308,310,310,310,310,310,312,
314,316,316,316,316,316,318,320,
322,322,322,322,322,322,322,322,
322,322,322,324,326,328,328,328,
328,328,328,328,328,328,328,328,
328,332,336,340,340,340,340,340,
340,340,340,340,
};

yyyFT yyyEntL[] = {
0,0,2,0,0,1,2,1,1,0,1,1,1,0,1,1,
0,2,4,0,0,2,4,1,1,0,1,1,1,0,1,0,
0,0,0,0,6,0,6,1,6,2,1,0,1,1,1,2,
3,0,3,1,3,2,2,0,2,2,2,1,2,0,2,1,
2,2,4,0,4,1,2,0,4,2,2,2,4,2,6,0,
6,2,2,0,6,1,6,2,2,2,2,1,6,2,3,0,
1,0,3,2,3,1,1,1,1,0,1,2,1,1,4,0,
1,0,2,0,4,1,1,1,2,2,2,1,4,2,1,2,
1,0,4,0,4,1,1,2,4,2,0,1,0,1,1,0,
1,2,1,1,2,0,2,1,2,2,2,0,2,1,2,2,
2,0,2,1,2,2,2,0,2,1,2,2,3,0,1,0,
3,1,1,1,3,2,1,2,1,0,3,0,1,1,3,1,
1,2,3,2,3,0,1,0,3,1,1,1,3,2,1,2,
1,0,3,0,1,1,3,1,1,2,3,2,3,0,1,0,
3,1,1,1,3,2,1,2,1,0,3,0,1,1,3,1,
1,2,3,2,1,0,1,1,1,2,1,0,1,1,1,2,
1,0,1,1,1,2,1,0,1,1,1,2,3,0,1,0,
3,1,1,1,3,2,1,2,3,0,1,0,3,1,1,1,
3,2,1,2,1,0,1,1,1,2,2,0,1,0,2,1,
1,1,2,2,1,2,1,0,1,1,1,2,2,0,2,1,
2,2,1,0,1,1,1,2,4,0,3,0,4,1,3,1,
4,2,3,2,
};

#define yyyPermitUserAlloc  0 


void yyyfatal(msg)
  char *msg; 
{fprintf(stderr,msg);exit(-1);} 



#define yyyNSof   'n' 
#define yyyRCof   'r' 
#define yyyCLof   'c' 
#define yyySof    's' 
#define yyySSALof 'S' 
#define yyyRSof   'q' 
#define yyyTSof   't' 



void yyyHandleOverflow(which) 
  char which; 
  {char *msg1,*msg2; 
   long  oldSize,newSize; 
   switch(which) 
     {
      case yyyNSof   : 
           msg1 = "node storage overflow: ";
           oldSize = yyyMaxNbytesNodeStg; 
           break; 
      case yyyRCof   : 
           msg1 = "dependee count overflow: ";
           oldSize = yyyMaxNrefCounts; 
           break; 
      case yyyCLof   : 
           msg1 = "child list overflow: ";
           oldSize = yyyMaxNchildren; 
           break; 
      case yyySof    : 
           msg1 = "parse-tree stack overflow: ";
           oldSize = yyyMaxStackSize; 
           break; 
      case yyySSALof : 
           msg1 = "SSAL overflow: ";
           oldSize = yyySSALspaceSize; 
           break; 
      case yyyRSof   : 
           msg1 = "ready set overflow: ";
           oldSize = yyyRSmaxSize; 
           break; 
      case yyyTSof   : 
           msg1 = "traversal stack overflow: ";
           oldSize = yyyTravStackMaxSize; 
           break; 
      default        :;  
     }
   newSize = (3*oldSize)/2; 
   if (newSize < 100) newSize = 100; 
   fprintf(stderr,msg1); 
   fprintf(stderr,"size was %d.\n",oldSize); 
   if (yyyPermitUserAlloc) 
      msg2 = "     Try -Y%c%d option.\n"; 
      else 
      msg2 = "     Have to modify evaluator:  -Y%c%d.\n"; 
   fprintf(stderr,msg2,which,newSize); 
   exit(-1); 
  }



void yyySignalEnts(node,startP,stopP) 
  register yyyGNT *node; 
  register yyyFT *startP,*stopP;  
  {register yyyGNT *dumNode; 

   while (startP < stopP)  
     {
      if (!(*startP)) dumNode = node;  
         else dumNode = (node->cL)[(*startP)-1];   
      if (!(--((dumNode->refCountList)[*(startP+1)]
              ) 
           )
         ) 
         { 
          if (++yyyRSTop == yyyAfterRS) 
             {yyyHandleOverflow(yyyRSof); 
              break; 
             }
          yyyRSTop->node = dumNode; 
          yyyRSTop->whichSym = *startP;  
          yyyRSTop->wa = *(startP+1);  
         }  
      startP += 2;  
     }  
  } 




#define yyyCeiling(num,inc) (((inc) * ((num)/(inc))) + (((num)%(inc))?(inc):0)) 



int yyyAlignSize = 8;
int yyyNdSz[22];

int yyyNdPrSz[22];

typedef int yyyCopyType;

int yyyNdCopySz[22];
long yyyBiggestNodeSize = 0;

void yyyNodeSizeCalc()
  {int i;
   yyyGNSz = yyyCeiling(yyyGNSz,yyyAlignSize); 
   yyyNdSz[0] = 0;
   yyyNdSz[1] = sizeof(struct yyyT1);
   yyyNdSz[2] = sizeof(struct yyyT2);
   yyyNdSz[3] = sizeof(struct yyyT3);
   yyyNdSz[4] = sizeof(struct yyyT4);
   yyyNdSz[5] = sizeof(struct yyyT5);
   yyyNdSz[6] = sizeof(struct yyyT6);
   yyyNdSz[7] = sizeof(struct yyyT7);
   yyyNdSz[8] = sizeof(struct yyyT8);
   yyyNdSz[9] = sizeof(struct yyyT9);
   yyyNdSz[10] = sizeof(struct yyyT10);
   yyyNdSz[11] = sizeof(struct yyyT11);
   yyyNdSz[12] = sizeof(struct yyyT12);
   yyyNdSz[13] = sizeof(struct yyyT13);
   yyyNdSz[14] = sizeof(struct yyyT14);
   yyyNdSz[15] = sizeof(struct yyyT15);
   yyyNdSz[16] = sizeof(struct yyyT16);
   yyyNdSz[17] = sizeof(struct yyyT17);
   yyyNdSz[18] = sizeof(struct yyyT18);
   yyyNdSz[19] = sizeof(struct yyyT19);
   yyyNdSz[20] = sizeof(struct yyyT20);
   yyyNdSz[21] = sizeof(struct yyyT21);
   for (i=0;i<22;i++) 
       {yyyNdSz[i] = yyyCeiling(yyyNdSz[i],yyyAlignSize); 
        yyyNdPrSz[i] = yyyNdSz[i] + yyyGNSz;
        if (yyyBiggestNodeSize < yyyNdSz[i])
           yyyBiggestNodeSize = yyyNdSz[i];
        yyyNdCopySz[i] = yyyCeiling(yyyNdSz[i],sizeof(yyyCopyType)) / 
                         sizeof(yyyCopyType); 
       }
  }




void yyySolveAndSignal() {
register long yyyiDum,*yyypL;
register int yyyws,yyywa;
register yyyGNT *yyyRSTopN,*yyyRefN; 
register void *yyyRSTopNp; 


yyyRSTopNp = (yyyRSTopN = yyyRSTop->node)->parent;
yyyRefN= (yyyws = (yyyRSTop->whichSym))?((yyyGNT *)yyyRSTopNp):yyyRSTopN;
yyywa = yyyRSTop->wa; 
yyyRSTop--;
switch(yyyRefN->prodNum) {
case 1:  /***yacc rule 1***/
  switch (yyyws) {
  case 1:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 2:  /***yacc rule 2***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 3:  /***yacc rule 3***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    case 0:
/* the structtab and fieldtab got initialised by an empty program nonterminal
			 * --> propagate them to the parent program and the definitions now */ (((yyyP3)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP3)(((char *)((yyyRefN->cL)[0]))+yyyGNSz))->structtab);
			    break;
    case 1:
 (((yyyP3)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP3)(((char *)((yyyRefN->cL)[0]))+yyyGNSz))->fieldtab);
			
			    break;
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP4)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP3)(((char *)((yyyRefN->cL)[0]))+yyyGNSz))->structtab);
			    break;
    case 1:
 (((yyyP4)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP3)(((char *)((yyyRefN->cL)[0]))+yyyGNSz))->fieldtab);
		    break;
    }
  break;
  }
break;
case 4:  /***yacc rule 4***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
/* propagate the struct and field sym table to every function def */ (((yyyP6)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP4)(((char *)yyyRefN)+yyyGNSz))->structtab);
			    break;
    case 1:
 (((yyyP6)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP4)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
		    break;
    }
  break;
  }
break;
case 5:  /***yacc rule 5***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
/* propagate the struct and field table to the every struct def */ (((yyyP5)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP4)(((char *)yyyRefN)+yyyGNSz))->structtab);
			    break;
    case 1:
 (((yyyP5)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP4)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
		    break;
    }
  break;
  }
break;
case 6:  /***yacc rule 6***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    case 2:
 (((yyyP5)(((char *)yyyRSTopN)+yyyGNSz))->dummy1) = symtab_add((((yyyP5)(((char *)yyyRefN)+yyyGNSz))->structtab), NULL, (((yyyP1)(((char *)((yyyRefN->cL)[1]))+yyyGNSz))->name), NULL);
			    break;
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    }
  break;
  case 4:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP8)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP5)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    }
  break;
  }
break;
case 7:  /***yacc rule 7***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 8:  /***yacc rule 8***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP8)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = symtab_add( (((yyyP8)(((char *)yyyRefN)+yyyGNSz))->fieldtab), next_reg(), (((yyyP1)(((char *)((yyyRefN->cL)[1]))+yyyGNSz))->name), (((yyyP8)(((char *)yyyRefN)+yyyGNSz))->structname));
			    break;
    case 1:
 (((yyyP8)(((char *)yyyRSTopN)+yyyGNSz))->structname) = (((yyyP8)(((char *)yyyRefN)+yyyGNSz))->structname);
		    break;
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 9:  /***yacc rule 9***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 10:  /***yacc rule 10***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    case 0:
//@i @ParamDef.1.tab@ = symtab_add( @ParamDef.0.tab@, @IDENTIFIER.name@, @ParamDef.0.structname@);
 (((yyyP7)(((char *)yyyRSTopN)+yyyGNSz))->tab) = symtab_add( (((yyyP7)(((char *)((yyyRefN->cL)[0]))+yyyGNSz))->tab), next_reg(), (((yyyP1)(((char *)((yyyRefN->cL)[1]))+yyyGNSz))->name), NULL);
		    break;
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 11:  /***yacc rule 11***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    }
  break;
  case 4:  /**/
    switch (yyywa) {
    }
  break;
  case 6:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP6)(((char *)yyyRefN)+yyyGNSz))->structtab);
			    break;
    case 1:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP6)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 2:
/* the parameters are visible within the function --> 
			 * get the new vartab (by the ParamDef) down the tree */ (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = (((yyyP7)(((char *)((yyyRefN->cL)[3]))+yyyGNSz))->tab);
		
			/* these come from the Def, are globally visible and may be 
			 * needed in the Stats as well --> get them down too! */
			    break;
    }
  break;
  }
break;
case 12:  /***yacc rule 12***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 13:  /***yacc rule 13***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
/* just distributing - move along please */ (((yyyP10)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP9)(((char *)yyyRefN)+yyyGNSz))->structtab);
			    yyySignalEnts(yyyRefN,yyyEntL+48,yyyEntL+50);
    break;
    case 1:
 (((yyyP10)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP9)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    yyySignalEnts(yyyRefN,yyyEntL+50,yyyEntL+52);
    break;
    case 2:
 (((yyyP10)(((char *)yyyRSTopN)+yyyGNSz))->vartab)    = (((yyyP9)(((char *)yyyRefN)+yyyGNSz))->vartab);
	
			    yyySignalEnts(yyyRefN,yyyEntL+52,yyyEntL+54);
    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP10)(((char *)((yyyRefN->cL)[0]))+yyyGNSz))->structtab);
			    break;
    case 1:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP10)(((char *)((yyyRefN->cL)[0]))+yyyGNSz))->fieldtab);
			    break;
    case 2:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = (((yyyP10)(((char *)((yyyRefN->cL)[0]))+yyyGNSz))->vartab);
			
			    break;
    }
  break;
  }
break;
case 14:  /***yacc rule 14***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
/* I could open a distribution business by now... */ (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    }
  break;
  }
break;
case 15:  /***yacc rule 15***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
/* distribute everything to the condlist */ (((yyyP11)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->structtab);
			    break;
    case 1:
 (((yyyP11)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 2:
 (((yyyP11)(((char *)yyyRSTopN)+yyyGNSz))->vartab) 	  = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab);
			
			    break;
    }
  break;
  }
break;
case 16:  /***yacc rule 16***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP12)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			/* in here new variables may be added - fork the vartab to ensure visibility scope */
			//@i @LetDef.0.vartab@ = symtab_dup( @Stat.0.vartab@, symtab_init());
			    break;
    case 2:
/* to ensure scope in definitions, fork vartab */ (((yyyP12)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = symtab_dup((((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab), symtab_init());
			    break;
    }
  break;
  case 4:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->structtab);
			
			    break;
    case 1:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 2:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->vartab)    = symtab_merge( (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab), (((yyyP12)(((char *)((yyyRefN->cL)[1]))+yyyGNSz))->vartab));
			
			    break;
    }
  break;
  }
break;
case 17:  /***yacc rule 17***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			/* check if IDENTIFIER is a valid struct */
			    break;
    case 1:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    }
  break;
  case 4:  /**/
    switch (yyywa) {
    }
  break;
  case 6:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->structtab);
		
			    break;
    case 1:
/* and we have to pass things on as well */ (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 2:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = symtab_merge( (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab), symtab_subtab( (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->fieldtab), (((yyyP1)(((char *)((yyyRefN->cL)[3]))+yyyGNSz))->name)));
			
			/* reassign scope if structs are defined below functions */
			    break;
    }
  break;
  }
break;
case 18:  /***yacc rule 18***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP13)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
		
			    break;
    case 1:
/* onwards down the tree! */ (((yyyP13)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab);	
			    break;
    case 2:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->visscope)   = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab);	
			    break;
    }
  break;
  }
break;
case 19:  /***yacc rule 19***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab);	
			
			    break;
    case 1:
/* down the rabbit hole! */ (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab);	
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope)   = (((yyyP10)(((char *)yyyRefN)+yyyGNSz))->vartab);	
			    break;
    }
  break;
  }
break;
case 20:  /***yacc rule 20***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 21:  /***yacc rule 21***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
/* distribute everything to the condlist */ (((yyyP11)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP11)(((char *)yyyRefN)+yyyGNSz))->structtab);
			    break;
    case 1:
 (((yyyP11)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP11)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 2:
 (((yyyP11)(((char *)yyyRSTopN)+yyyGNSz))->vartab) 	  = (((yyyP11)(((char *)yyyRefN)+yyyGNSz))->vartab);
			
			/* distribute everything to the Stats */
			    break;
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP11)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 1:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->vartab)	  = (((yyyP11)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->visscope)	  = (((yyyP11)(((char *)yyyRefN)+yyyGNSz))->vartab);
		    break;
    }
  break;
  case 4:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->structtab) = (((yyyP11)(((char *)yyyRefN)+yyyGNSz))->structtab);
			    break;
    case 1:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP11)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 2:
 (((yyyP9)(((char *)yyyRSTopN)+yyyGNSz))->vartab)	   = (((yyyP11)(((char *)yyyRefN)+yyyGNSz))->vartab);	
			
			/* the Expr doesn't need to know the structs (at least i hope so) */	
			    break;
    }
  break;
  }
break;
case 22:  /***yacc rule 22***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 23:  /***yacc rule 23***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    case 1:
 (((yyyP12)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = symtab_add( (((yyyP12)(((char *)((yyyRefN->cL)[0]))+yyyGNSz))->vartab), NULL, (((yyyP1)(((char *)((yyyRefN->cL)[1]))+yyyGNSz))->name), NULL);

			    yyySignalEnts(yyyRefN,yyyEntL+132,yyyEntL+134);
    break;
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP12)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP12)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 2:
 (((yyyP12)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP12)(((char *)yyyRefN)+yyyGNSz))->visscope);
			
		    break;
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    }
  break;
  case 4:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP12)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 1:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP12)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP12)(((char *)yyyRefN)+yyyGNSz))->visscope);
			
			//@i @LetDef.1.vartab@   = symtab_add( @LetDef.0.vartab@, @IDENTIFIER.0.name@, NULL);
			    break;
    }
  break;
  }
break;
case 24:  /***yacc rule 24***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)  = (((yyyP13)(((char *)yyyRefN)+yyyGNSz))->fieldtab);	
		    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab) 	= (((yyyP13)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) 	= (((yyyP13)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 25:  /***yacc rule 25***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 26:  /***yacc rule 26***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 27:  /***yacc rule 27***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 28:  /***yacc rule 28***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP14)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP14)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP14)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 29:  /***yacc rule 29***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP14)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP14)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP14)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP14)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 30:  /***yacc rule 30***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->visscope);
		
			    break;
    }
  break;
  }
break;
case 31:  /***yacc rule 31***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP15)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP15)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP15)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->visscope);
	
			    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)    = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)    = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope)  = (((yyyP15)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 32:  /***yacc rule 32***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->visscope);

			    break;
    }
  break;
  }
break;
case 33:  /***yacc rule 33***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP16)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP16)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP16)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->visscope);

			    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)    = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)    = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope)    = (((yyyP16)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 34:  /***yacc rule 34***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->visscope);

			    break;
    }
  break;
  }
break;
case 35:  /***yacc rule 35***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP17)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP17)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP17)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->visscope);

			    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab)   = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP17)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 36:  /***yacc rule 36***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP14)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP14)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP14)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 37:  /***yacc rule 37***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP15)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP15)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP15)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 38:  /***yacc rule 38***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP16)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP16)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP16)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 39:  /***yacc rule 39***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP17)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP17)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP17)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 40:  /***yacc rule 40***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
		
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 41:  /***yacc rule 41***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
	
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 42:  /***yacc rule 42***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP18)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 43:  /***yacc rule 43***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 44:  /***yacc rule 44***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP19)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP19)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 1:
/* we didn't have anything to get down for quite a while */ (((yyyP19)(((char *)yyyRSTopN)+yyyGNSz))->vartab)  = (((yyyP19)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP19)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP18)(((char *)((yyyRefN->cL)[1]))+yyyGNSz))->visscope);
			    break;
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) 	 = (((yyyP19)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
		    break;
    case 1:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->vartab) 	    = (((yyyP19)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->visscope)    = (((yyyP19)(((char *)yyyRefN)+yyyGNSz))->visscope);
			
			    yyySignalEnts(yyyRefN,yyyEntL+308,yyyEntL+310);
    break;
    }
  break;
  }
break;
case 45:  /***yacc rule 45***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 46:  /***yacc rule 46***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP20)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
		    break;
    case 1:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP20)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP20)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 47:  /***yacc rule 47***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 2:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			    break;
    case 1:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP18)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  }
break;
case 48:  /***yacc rule 48***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 49:  /***yacc rule 49***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->fieldtab);	
			
			    break;
    case 1:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->vartab)   = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP21)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 50:  /***yacc rule 50***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    }
  break;
  }
break;
case 51:  /***yacc rule 51***/
  switch (yyyws) {
  case 0:  /**/
    switch (yyywa) {
    }
  break;
  case 1:  /**/
    switch (yyywa) {
    }
  break;
  case 3:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP19)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			    break;
    case 1:
/* IDENTIFIER is the name of the function --> ignore */ (((yyyP19)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP19)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->visscope);
			    break;
    }
  break;
  case 4:  /**/
    switch (yyywa) {
    case 0:
 (((yyyP20)(((char *)yyyRSTopN)+yyyGNSz))->fieldtab) = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->fieldtab);
			
			/* there will not be any function calls */
			    break;
    case 1:
 (((yyyP20)(((char *)yyyRSTopN)+yyyGNSz))->vartab) = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->vartab);
			    break;
    case 2:
 (((yyyP20)(((char *)yyyRSTopN)+yyyGNSz))->visscope) = (((yyyP21)(((char *)yyyRefN)+yyyGNSz))->visscope);
		
			    break;
    }
  break;
  }
break;
} /* switch */ 

if (yyyws)  /* the just-solved instance was inherited. */ 
   {if (yyyRSTopN->prodNum) 
       {yyyiDum = yyyIIEL[yyyIIIEL[yyyRSTopN->prodNum]] + yyywa;
        yyySignalEnts(yyyRSTopN,yyyEntL + yyyIEL[yyyiDum],
                                yyyEntL + yyyIEL[yyyiDum+1]
                     );
       }
   } 
   else     /* the just-solved instance was synthesized. */ 
   {if ((char *)yyyRSTopNp >= yyyNodeSpace) /* node has a parent. */ 
       {yyyiDum = yyyIIEL[yyyIIIEL[((yyyGNT *)yyyRSTopNp)->prodNum] + 
                          yyyRSTopN->whichSym 
                         ] + 
                  yyywa;
        yyySignalEnts((yyyGNT *)yyyRSTopNp,
                      yyyEntL + yyyIEL[yyyiDum],
                      yyyEntL + yyyIEL[yyyiDum+1] 
                     );
       } 
       else   /* node is still on the stack--it has no parent yet. */ 
       {yyypL = &(((struct yyyStackItem *)yyyRSTopNp)->solvedSAlist); 
        if (yyySSALCfreeList == yyyLambdaSSAL) 
           {yyySSALspace[yyyNewSSALC].next = *yyypL; 
            if ((*yyypL = yyyNewSSALC++) == yyySSALspaceSize) 
               yyyHandleOverflow(yyySSALof); 
           }  
           else
           {yyyiDum = yyySSALCfreeList; 
            yyySSALCfreeList = yyySSALspace[yyySSALCfreeList].next; 
            yyySSALspace[yyyiDum].next = *yyypL; 
            *yyypL = yyyiDum;  
           } 
        yyySSALspace[*yyypL].attrbNum = yyywa; 
       } 
   }

} /* yyySolveAndSignal */ 






#define condStg unsigned int conds;
#define yyyClearConds {yyyTST->conds = 0;}
#define yyySetCond(n) {yyyTST->conds += (1<<(n));}
#define yyyCond(n) ((yyyTST->conds & (1<<(n)))?1:0)



struct yyyTravStackItem {yyyGNT *node; 
                         char isReady;
                         condStg
                        };



void yyyDoTraversals()
{struct yyyTravStackItem *yyyTravStack,*yyyTST,*yyyAfterTravStack;
 register yyyGNT *yyyTSTn,**yyyCLptr1,**yyyCLptr2; 
 register int yyyi,yyyRL,yyyPass;

 if (!yyyYok) return;
 if ((yyyTravStack = 
                 ((struct yyyTravStackItem *) 
                  malloc((yyyTravStackMaxSize * 
                                  sizeof(struct yyyTravStackItem)
                                 )
                        )
                 )
     )
     == 
     (struct yyyTravStackItem *)NULL
    ) 
    {fprintf(stderr,"malloc error in traversal stack allocation\n"); 
     exit(-1); 
    } 

yyyAfterTravStack = yyyTravStack + yyyTravStackMaxSize; 
yyyTravStack++; 


for (yyyi=0; yyyi<5; yyyi++) {
yyyTST = yyyTravStack; 
yyyTST->node = yyyStack->node;
yyyTST->isReady = 0;
yyyClearConds

while(yyyTST >= yyyTravStack)
  {yyyTSTn = yyyTST->node;
   if (yyyTST->isReady)  
      {yyyPass = 1;
       goto yyyTravSwitch;
yyyTpop:
       yyyTST--;
      } 
      else 
      {yyyPass = 0;
       goto yyyTravSwitch;
yyyTpush:
       yyyTST->isReady = 1;  
       if (yyyTSTn->prodNum)
          if (yyyRL)
             {yyyCLptr2 = yyyTSTn->cL; 
              while 
                ((yyyCLptr2 != yyyNextCLspace)
                 &&
                 ((*yyyCLptr2)->parent == yyyTSTn) 
                )  
                {if (++yyyTST == yyyAfterTravStack)
                    yyyHandleOverflow(yyyTSof);
                    else
                    {yyyTST->node = *yyyCLptr2; 
                     yyyTST->isReady = 0; 
                     yyyClearConds
                    }
                 yyyCLptr2++; 
                } 
             } /* right to left */
             else  /* left to right */
             {yyyCLptr1 = yyyCLptr2 = yyyTSTn->cL; 
              while 
                ((yyyCLptr2 != yyyNextCLspace)
                 &&
                 ((*yyyCLptr2)->parent == yyyTSTn) 
                )  
                yyyCLptr2++; 
              while (yyyCLptr2-- > yyyCLptr1)
                if (++yyyTST == yyyAfterTravStack)
                   yyyHandleOverflow(yyyTSof);
                   else
                   {yyyTST->node = *yyyCLptr2; 
                    yyyTST->isReady = 0; 
                    yyyClearConds
                   }
             } /* left to right */
      } /* else */
   continue;
yyyTravSwitch:
				switch(yyyTSTn->prodNum)	{
case 1:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 2:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 3:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 4:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 5:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 6:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 7:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 8:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 9:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 10:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 11:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { asm_func_prolog((((yyyP1)(((char *)((yyyTSTn->cL)[1]))+yyyGNSz))->name));
			}
if (yyyCond(1) != yyyPass) { burm_label((((yyyP9)(((char *)((yyyTSTn->cL)[5]))+yyyGNSz))->node)); burm_reduce((((yyyP9)(((char *)((yyyTSTn->cL)[5]))+yyyGNSz))->node),1);
			}
if (yyyCond(2) != yyyPass) { reset_regcursor();
		}
				break;
					}
		break;
			}

break;
case 12:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { reset_regcursor();
		}
				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 13:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;yyySetCond(0)
yyySetCond(1)

				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP10)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->vartab)  = (((yyyP9)(((char *)yyyTSTn)+yyyGNSz))->vartab);
			}
if (yyyCond(1) != yyyPass) { (((yyyP9)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->vartab) = (((yyyP9)(((char *)yyyTSTn)+yyyGNSz))->vartab);
		}
				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP9)(((char *)yyyTSTn)+yyyGNSz))->node) = (((yyyP10)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node);
			}
if (yyyCond(1) != yyyPass) { (((yyyP9)(((char *)yyyTSTn)+yyyGNSz))->node)->right = (((yyyP9)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->node);
	
			}
				break;
					}
		break;
			}

break;
case 14:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP10)(((char *)yyyTSTn)+yyyGNSz))->node) = new_ret((((yyyP18)(((char *)((yyyTSTn->cL)[1]))+yyyGNSz))->node));
		}
				break;
					}
		break;
			}

break;
case 15:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 16:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;yyySetCond(0)

				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP9)(((char *)((yyyTSTn->cL)[3]))+yyyGNSz))->vartab)  = symtab_merge_nodupcheck( (((yyyP10)(((char *)yyyTSTn)+yyyGNSz))->vartab), (((yyyP12)(((char *)((yyyTSTn->cL)[1]))+yyyGNSz))->vartab));
			
			//@i @Stats.0.vartab@    = @LetDef.0.vartab@;
			}
				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 17:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;yyySetCond(0)

				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP9)(((char *)((yyyTSTn->cL)[5]))+yyyGNSz))->vartab) = symtab_merge( (((yyyP10)(((char *)yyyTSTn)+yyyGNSz))->vartab), symtab_subtab( (((yyyP10)(((char *)yyyTSTn)+yyyGNSz))->fieldtab), (((yyyP1)(((char *)((yyyTSTn->cL)[3]))+yyyGNSz))->name)));
			
			}
				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { symtab_isdef( (((yyyP10)(((char *)yyyTSTn)+yyyGNSz))->structtab), (((yyyP1)(((char *)((yyyTSTn->cL)[3]))+yyyGNSz))->name));
		
			/* good! now get all fields of the struct into a new symtab
			 * --> these will be added to the varscope of the with-block.  
			 * yet, we will need the already defined variables as well, so
			 * merge these two symtables into one
			 * NOTE: the result will be in arg2 (so the return * of the function 
			 * -- a new symtab_t to ensure scope), and the elements of arg1 will be
			 * appended as copies, so no mixup with the original elements */
			//@i @Stats.vartab@ = symtab_merge( @Stat.vartab@, symtab_subtab( @Stat.fieldtab@, @IDENTIFIER.0.name@));
			}
				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 18:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 19:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 20:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 21:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 22:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 23:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 24:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { symtab_isdef( (((yyyP13)(((char *)yyyTSTn)+yyyGNSz))->fieldtab), (((yyyP1)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->name));
			
			/* and as always there is stuff to get down */
			}
				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 25:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { symtab_isdef( (((yyyP13)(((char *)yyyTSTn)+yyyGNSz))->vartab), (((yyyP1)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->name));
		}
				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 26:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP14)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_NEG, (((yyyP21)(((char *)((yyyTSTn->cL)[1]))+yyyGNSz))->node), NULL);
		}
				break;
					}
		break;
			}

break;
case 27:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP14)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_NOT, (((yyyP21)(((char *)((yyyTSTn->cL)[1]))+yyyGNSz))->node), NULL);
		}
				break;
					}
		break;
			}

break;
case 28:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP14)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_NEG, (((yyyP14)(((char *)((yyyTSTn->cL)[1]))+yyyGNSz))->node), NULL);
		}
				break;
					}
		break;
			}

break;
case 29:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP14)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_NOT, (((yyyP14)(((char *)((yyyTSTn->cL)[1]))+yyyGNSz))->node), NULL);
		}
				break;
					}
		break;
			}

break;
case 30:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP15)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_ADD, (((yyyP21)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node), (((yyyP21)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->node));
		}
				break;
					}
		break;
			}

break;
case 31:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP15)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_ADD, (((yyyP15)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node), (((yyyP21)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->node));
		}
				break;
					}
		break;
			}

break;
case 32:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP16)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_MUL, (((yyyP21)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node), (((yyyP21)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->node));
		}
				break;
					}
		break;
			}

break;
case 33:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP16)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_MUL, (((yyyP16)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node), (((yyyP21)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->node));
		}
				break;
					}
		break;
			}

break;
case 34:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP17)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_OR, (((yyyP21)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node), (((yyyP21)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->node));
		}
				break;
					}
		break;
			}

break;
case 35:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP17)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_OR, (((yyyP17)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node), (((yyyP21)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->node));
		}
				break;
					}
		break;
			}

break;
case 36:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP18)(((char *)yyyTSTn)+yyyGNSz))->node) = (((yyyP14)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node);
		}
				break;
					}
		break;
			}

break;
case 37:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP18)(((char *)yyyTSTn)+yyyGNSz))->node) = (((yyyP15)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node);
		}
				break;
					}
		break;
			}

break;
case 38:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP18)(((char *)yyyTSTn)+yyyGNSz))->node) = (((yyyP16)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node);
		}
				break;
					}
		break;
			}

break;
case 39:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP18)(((char *)yyyTSTn)+yyyGNSz))->node) = (((yyyP17)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node);
		}
				break;
					}
		break;
			}

break;
case 40:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP18)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_GRE, (((yyyP21)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node), (((yyyP21)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->node));
		}
				break;
					}
		break;
			}

break;
case 41:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP18)(((char *)yyyTSTn)+yyyGNSz))->node) = new_op(T_NEQ, (((yyyP21)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node), (((yyyP21)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->node));
		}
				break;
					}
		break;
			}

break;
case 42:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP18)(((char *)yyyTSTn)+yyyGNSz))->node) = (((yyyP21)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->node);
		}
				break;
					}
		break;
			}

break;
case 43:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 44:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 45:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 46:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 47:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP21)(((char *)yyyTSTn)+yyyGNSz))->node) = (((yyyP18)(((char *)((yyyTSTn->cL)[1]))+yyyGNSz))->node);
		}
				break;
					}
		break;
			}

break;
case 48:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP21)(((char *)yyyTSTn)+yyyGNSz))->node) = new_num((((yyyP2)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->val));
		}
				break;
					}
		break;
			}

break;
case 49:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { symtab_isdef( (((yyyP21)(((char *)yyyTSTn)+yyyGNSz))->fieldtab), (((yyyP1)(((char *)((yyyTSTn->cL)[2]))+yyyGNSz))->name));
		
			/* and as always there is stuff to get down */
			}
				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
case 50:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { symtab_isdef( (((yyyP21)(((char *)yyyTSTn)+yyyGNSz))->visscope), (((yyyP1)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->name));
		}
				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

if (yyyCond(0) != yyyPass) { (((yyyP21)(((char *)yyyTSTn)+yyyGNSz))->node) = new_var((((yyyP1)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->name), stentry_reg((((yyyP21)(((char *)yyyTSTn)+yyyGNSz))->vartab), (((yyyP1)(((char *)((yyyTSTn->cL)[0]))+yyyGNSz))->name)));
			
			/* check if IDENTIFIER is a defined variable */
			//@checkscope symtab_isdef( @Term.0.vartab@, @IDENTIFIER.0.name@);
			}
				break;
					}
		break;
			}

break;
case 51:
	switch(yyyi)	{ 
		case 0:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 1:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 2:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 3:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
		case 4:
			switch(yyyPass)	{
				case 0:
yyyRL = 0;
				case 1:

				break;
					}
		break;
			}

break;
								} /* switch */ 
   if (yyyPass) goto yyyTpop; else goto yyyTpush; 
  } /* while */ 
 } /* for */ 
} /* yyyDoTraversals */ 

void yyyExecuteRRsection()  {
   int yyyi; 
   long yyynRefCounts; 
   long cycleSum = 0;
   long nNZrc = 0;

   if (!yyyYok) return; 
   yyynRefCounts = yyyNextRCLspace - yyyRefCountListSpace; 
   for (yyyi=0;yyyi<yyynRefCounts;yyyi++) 
     if (yyyRefCountListSpace[yyyi])
        {cycleSum += yyyRefCountListSpace[yyyi]; nNZrc++;} 
   if (nNZrc) 
      {
       fprintf(stderr,"\n\n\n**********\n");
       fprintf(stderr,
               "cycle detected in completed parse tree");
       fprintf(stderr,
               " after decoration.\n");
       fprintf(stderr,
         "searching parse tree for %d unsolved instances:\n",
               nNZrc
              );
       yyyUnsolvedInstSearchTravAux(yyyStackTop->node);
      }
   yyyDoTraversals();
} /* yyyExecuteRRsection */ 



yyyWAT yyyLRCIL[2] = {0,0,
};



void yyyYoxInit()                                  /*stock*/  
  { 

   yyyNodeSizeCalc(); 

   if ((yyyTermBuffer.snBufPtr = 
        (char *) malloc((yyyBiggestNodeSize + sizeof(yyyCopyType)))
       )  
       == 
       ((char *) NULL) 
      )   
      yyyfatal("malloc error in yyyTermBuffer allocation\n");  
  
  
   yyyNbytesStackStg = yyyMaxStackSize*sizeof(struct yyyStackItem); 
   yyyNbytesStackStg = ((yyyNbytesStackStg/yyyAlignSize)+1)*yyyAlignSize;  
   if ((yyyNodeAndStackSpace = 
        (char *) malloc((yyyNbytesStackStg + 
                                 yyyMaxNbytesNodeStg + 
                                 yyyGNSz + 
                                 yyyBiggestNodeSize + 
                                 sizeof(yyyCopyType) 
                                )
                       )
       )  
       == 
       ((char *) NULL) 
      )   
      yyyfatal("malloc error in ox node and stack space allocation\n");
   yyyStack = (struct yyyStackItem *) yyyNodeAndStackSpace; 
   yyyAfterStack = yyyStack + yyyMaxStackSize;  
   yyyNodeSpace = yyyNodeAndStackSpace + yyyNbytesStackStg;
   yyyAfterNodeSpace = yyyNodeSpace + yyyMaxNbytesNodeStg;
 
 
   if ((yyyRS = (struct yyyRSitem *) 
         malloc(((yyyRSmaxSize+1)*sizeof(struct yyyRSitem)))
       )  
       == 
       ((struct yyyRSitem *) NULL) 
      )   
      yyyfatal("malloc error in ox ready set space allocation\n");  
   yyyRS++; 
   yyyAfterRS = yyyRS + yyyRSmaxSize; 

 
   if ((yyyChildListSpace = 
        (yyyGNT **) malloc((yyyMaxNchildren*sizeof(yyyGNT *)))
       )  
       == 
       ((yyyGNT **) NULL) 
      )   
      yyyfatal("malloc error in ox child list space allocation\n");  
   yyyAfterChildListSpace = yyyChildListSpace + yyyMaxNchildren; 

 
   if ((yyyRefCountListSpace = 
        (yyyRCT *) malloc((yyyMaxNrefCounts * sizeof(yyyRCT)))
       )  
       == 
       ((yyyRCT *) NULL) 
      )   
      yyyfatal("malloc error in ox reference count list space allocation\n");  
   yyyAfterRefCountListSpace = yyyRefCountListSpace + yyyMaxNrefCounts;  
  
 
   if ((yyySSALspace = (struct yyySolvedSAlistCell *) 
          malloc(((yyySSALspaceSize+1) * 
                          sizeof(struct yyySolvedSAlistCell))
                         ) 
       ) 
       == 
       ((struct yyySolvedSAlistCell *) NULL) 
      ) 
      yyyfatal("malloc error in stack solved list space allocation\n"); 
  } /* yyyYoxInit */ 



void yyyYoxReset() 
  { 
   yyyTermBuffer.isEmpty = 1; 
   yyyStackTop = yyyStack; 
   while (yyyStackTop != yyyAfterStack) 
     (yyyStackTop++)->solvedSAlist = yyyLambdaSSAL; 
   yyyStackTop = yyyStack - 1; 
   yyyNextNodeSpace = yyyNodeSpace; 
   yyyRSTop = yyyRS - 1; 
   yyyNextCLspace = yyyChildListSpace;
   yyyNextRCLspace = yyyRefCountListSpace; 
  }  



void yyyDecorate() 
  { 
   while (yyyRSTop >= yyyRS) 
      yyySolveAndSignal();  
  } 



void yyyShift() 
  {yyyRCT *rcPdum; 
   register yyyCopyType *CTp1,*CTp2,*CTp3; 
   register yyyWAT *startP,*stopP;  

   if ((++yyyStackTop) == yyyAfterStack) 
      yyyHandleOverflow(yyySof);
   CTp2 = (yyyCopyType *)(yyyStackTop->oldestNode = 
                          yyyStackTop->node = 
                          (yyyGNT *)yyyNextNodeSpace 
                         ); 
   yyyTermBuffer.isEmpty = 1;
   ((yyyGNT *)CTp2)->parent = (void *)yyyStackTop; 
   ((yyyGNT *)CTp2)->cL = yyyNextCLspace;  
   rcPdum = ((yyyGNT *)CTp2)->refCountList = yyyNextRCLspace;  
   ((yyyGNT *)CTp2)->prodNum = 0; 
   if ((yyyNextRCLspace += yyyTermBuffer.nAttrbs) 
       > 
       yyyAfterRefCountListSpace 
      ) 
      yyyHandleOverflow(yyyRCof); 
   startP = yyyTermBuffer.startP;  
   stopP = yyyTermBuffer.stopP;  
   while (startP < stopP) rcPdum[*(startP++)] = 0; 
   if ((yyyNextNodeSpace += yyyNdPrSz[yyyTermBuffer.typeNum]) 
       > 
       yyyAfterNodeSpace 
      ) 
      yyyHandleOverflow(yyyNSof);  
   CTp1 = (yyyCopyType *)(yyyTermBuffer.snBufPtr); 
   CTp2 = (yyyCopyType *)(((char *)CTp2) + yyyGNSz); 
   CTp3 = CTp2 + yyyNdCopySz[yyyTermBuffer.typeNum]; 
   while (CTp2 < CTp3) *CTp2++ = *CTp1++; 
  } 



void yyyGenIntNode() 
  {register yyyWST i;
   register struct yyyStackItem *stDum;  
   register yyyGNT *gnpDum; 

   if ((stDum = (yyyStackTop -= (yyyRHSlength-1))) >= yyyAfterStack) 
      yyyHandleOverflow(yyySof);
   yyySTsn = ((char *)(yyySTN = (yyyGNT *)yyyNextNodeSpace)) + yyyGNSz; 
   yyySTN->parent       =  (void *)yyyStackTop;  
   yyySTN->cL           =  yyyNextCLspace; 
   yyySTN->refCountList =  yyyNextRCLspace; 
   yyySTN->prodNum      =  yyyProdNum; 
   if ((yyyNextCLspace+yyyRHSlength) > yyyAfterChildListSpace) 
      yyyHandleOverflow(yyyCLof); 
   for (i=1;i<=yyyRHSlength;i++) 
     {gnpDum = *(yyyNextCLspace++) = (stDum++)->node;  
      gnpDum->whichSym = i;  
      gnpDum->parent = (void *)yyyNextNodeSpace; 
     } 
   if ((yyyNextRCLspace += yyyNattrbs) > yyyAfterRefCountListSpace) 
      yyyHandleOverflow(yyyRCof); 
   if ((yyyNextNodeSpace += yyyNdPrSz[yyyTypeNum]) > yyyAfterNodeSpace) 
      yyyHandleOverflow(yyyNSof);  
  } 



#define yyyDECORfREQ 50 



void yyyAdjustINRC(startP,stopP) 
  register yyyFT *startP,*stopP;
  {yyyWST i;
   long SSALptr,SSALptrHead,*cPtrPtr; 
   long *pL; 
   struct yyyStackItem *stDum;  
   yyyGNT *gnpDum; 
   long iTemp;
   register yyyFT *nextP;
   static unsigned short intNodeCount = yyyDECORfREQ;

   nextP = startP;
   while (nextP < stopP) 
     {if ((*nextP) == yyyR)  
         {(yyySTN->refCountList)[*(nextP+1)] = *(nextP+2);
         } 
         else 
         {(((yyySTN->cL)[*nextP])->refCountList)[*(nextP+1)] = *(nextP+2);
         } 
      nextP += 3;  
     }
   pL = yyyIIEL + yyyIIIEL[yyyProdNum]; 
   stDum = yyyStackTop;  
   for (i=1;i<=yyyRHSlength;i++) 
     {pL++; 
      SSALptrHead = SSALptr = *(cPtrPtr = &((stDum++)->solvedSAlist)); 
      if (SSALptr != yyyLambdaSSAL) 
         {*cPtrPtr = yyyLambdaSSAL; 
          do 
            {
             iTemp = (*pL+yyySSALspace[SSALptr].attrbNum);
             yyySignalEnts(yyySTN,
                           yyyEntL + yyyIEL[iTemp],
                           yyyEntL + yyyIEL[iTemp+1]
                          );  
             SSALptr = *(cPtrPtr = &(yyySSALspace[SSALptr].next)); 
            } 
            while (SSALptr != yyyLambdaSSAL);  
          *cPtrPtr = yyySSALCfreeList;  
          yyySSALCfreeList = SSALptrHead;  
         } 
     } 
   nextP = startP + 2;
   while (nextP < stopP) 
     {if (!(*nextP))
         {if ((*(nextP-2)) == yyyR)  
             {pL = &(yyyStackTop->solvedSAlist); 
              if (yyySSALCfreeList == yyyLambdaSSAL) 
                 {yyySSALspace[yyyNewSSALC].next = *pL; 
                  if ((*pL = yyyNewSSALC++) == yyySSALspaceSize) 
                     yyyHandleOverflow(yyySSALof); 
                 }  
                 else
                 {iTemp = yyySSALCfreeList; 
                  yyySSALCfreeList = yyySSALspace[yyySSALCfreeList].next; 
                  yyySSALspace[iTemp].next = *pL; 
                  *pL = iTemp;  
                 } 
              yyySSALspace[*pL].attrbNum = *(nextP-1); 
             } 
             else 
             {if ((gnpDum = (yyySTN->cL)[*(nextP-2)])->prodNum != 0)
                 {
                  iTemp = yyyIIEL[yyyIIIEL[gnpDum->prodNum]] + *(nextP-1);
                  yyySignalEnts(gnpDum, 
                                yyyEntL + yyyIEL[iTemp],  
                                yyyEntL + yyyIEL[iTemp+1] 
                               );    
                 }  
             } 
         } 
      nextP += 3; 
     } 
   yyyStackTop->node = yyySTN;
   if (!yyyRHSlength) yyyStackTop->oldestNode = yyySTN; 
   if (!--intNodeCount) 
      {intNodeCount = yyyDECORfREQ; 
       yyyDecorate(); 
      } 
  } 



void yyyPrune(prodNum) 
  long prodNum;
  {  
   int i,n; 
   register char *cp1,*cp2;  
   register yyyRCT *rcp1,*rcp2,*rcp3;  
   long cycleSum = 0;
   long nNZrc = 0;
   yyyRCT *tempNextRCLspace;
   
   yyyDecorate();
   tempNextRCLspace = yyyNextRCLspace;
   yyyNextRCLspace = 
     (rcp1 = rcp2 = (yyyStackTop->oldestNode)->refCountList) + yyyNattrbs;
   rcp3 = (yyyStackTop->node)->refCountList; 
   while (rcp2 < rcp3) 
     if (*rcp2++) {cycleSum += *(rcp2 - 1); nNZrc++;} 
   if (nNZrc) 
      {
       fprintf(stderr,"\n\n\n----------\n");
       fprintf(stderr,
         "cycle detected during pruning of a subtree\n");
       fprintf(stderr,
         "  at whose root production %d is applied.\n",prodNum);
       yyyNextRCLspace = tempNextRCLspace; 
       fprintf(stderr,
         "prune aborted: searching subtree for %d unsolved instances:\n",
               nNZrc
              );
       yyyUnsolvedInstSearchTrav(yyyStackTop->node);
       return; 
      }
   for (i=0;i<yyyNattrbs;i++) rcp1[i] = rcp3[i]; 
   yyyNextCLspace = (yyyStackTop->oldestNode)->cL; 
   yyyNextNodeSpace = (char *)(yyyStackTop->oldestNode) + 
                      (n = yyyNdPrSz[yyyTypeNum]);
   cp1 = (char *)yyyStackTop->oldestNode; 
   cp2 = (char *)yyyStackTop->node; 
   for (i=0;i<n;i++) *cp1++ = *cp2++; 
   yyyStackTop->node = yyyStackTop->oldestNode; 
   (yyyStackTop->node)->refCountList = rcp1; 
   (yyyStackTop->node)->cL = yyyNextCLspace; 
  } 



void yyyGenLeaf(nAttrbs,typeNum,startP,stopP) 
  int nAttrbs,typeNum; 
  yyyWAT *startP,*stopP; 
  {
   if  (!(yyyTermBuffer.isEmpty)) yyyShift(); 
   yyyTermBuffer.isEmpty = 0;
   yyyTermBuffer.typeNum = typeNum; 
   yyyTermBuffer.nAttrbs = nAttrbs; 
   yyyTermBuffer.startP = startP; 
   yyyTermBuffer.stopP = stopP; 
   
  } 



void yyyerror()
  {yyyYok = 0; 
  } 



/* read the command line for changes in sizes of 
                  the evaluator's data structures */
void yyyCheckForResizes(argc,argv) 
  int argc; 
  char *argv[]; 
  {int i; 
   long dum; 
 
   if (!yyyPermitUserAlloc) return; 
   for (i=1;i<argc;i++) 
     { 
      if ((argv[i][0] != '-') || (argv[i][1] != 'Y')) continue; 
      if (strlen(argv[i]) < 4) goto yyyErrO1; 
      if (sscanf(argv[i]+3,"%d",&dum) != 1) goto yyyErrO1;
      if (dum < 2) dum = 2;
      switch (argv[i][2]) 
        {case yyyNSof:   yyyMaxNbytesNodeStg = dum; break; 
         case yyyRCof:   yyyMaxNrefCounts    = dum; break; 
         case yyyCLof:   yyyMaxNchildren     = dum; break; 
         case yyySof:    yyyMaxStackSize     = dum; break; 
         case yyySSALof: yyySSALspaceSize    = dum; break; 
         case yyyRSof:   yyyRSmaxSize        = dum; break; 
         case yyyTSof:   yyyTravStackMaxSize = dum; break; 
         default : goto yyyErrO1; 
        }
      continue;  
   yyyErrO1 : fprintf(stderr,"invalid command line option: %s\n",
                             argv[i] 
                     ); 
     } 
  } 
   
   
   


#define yyyLastProdNum 51


#define yyyNsorts 21


int yyyProdsInd[] = {
   0,
   0,   2,   3,   7,   9,  11,  17,  18,  21,  22,
  25,  33,  34,  38,  41,  45,  51,  59,  63,  65,
  66,  73,  74,  80,  84,  86,  89,  92,  95,  98,
 102, 106, 110, 114, 118, 122, 124, 126, 128, 130,
 134, 138, 140, 141, 145, 146, 148, 152, 154, 158,
 160,
 166,
};


int yyyProds[][2] = {
{ 334,   0},{1014,   3},{1014,   3},{1014,   3},{1014,   3},
{  21,   4},{ 548,   0},{  21,   4},{ 165,   6},{  21,   4},
{ 172,   5},{ 172,   5},{1049,   0},{ 580,   1},{ 540,   0},
{  70,   8},{ 124,   0},{  70,   8},{  70,   8},{  70,   8},
{ 580,   1},{  16,   7},{  16,   7},{  16,   7},{ 580,   1},
{ 165,   6},{ 662,   0},{ 580,   1},{ 396,   0},{  16,   7},
{ 404,   0},{  63,   9},{ 124,   0},{  63,   9},{  63,   9},
{ 246,  10},{ 548,   0},{  63,   9},{ 246,  10},{ 838,   0},
{ 431,  18},{ 246,  10},{ 675,   0},{ 793,  11},{ 124,   0},
{ 246,  10},{1083,   0},{  42,  12},{ 699,   0},{  63,   9},
{ 124,   0},{ 246,  10},{ 282,   0},{ 431,  18},{ 540,   0},
{ 580,   1},{ 702,   0},{  63,   9},{ 124,   0},{ 246,  10},
{ 286,  13},{ 564,   0},{ 431,  18},{ 246,  10},{ 997,  21},
{ 793,  11},{ 793,  11},{ 793,  11},{ 431,  18},{ 361,   0},
{  63,   9},{ 124,   0},{ 548,   0},{  42,  12},{  42,  12},
{  42,  12},{ 580,   1},{ 564,   0},{ 431,  18},{ 548,   0},
{ 286,  13},{ 997,  21},{ 444,   0},{ 580,   1},{ 286,  13},
{ 580,   1},{ 370,  14},{ 436,   0},{ 997,  21},{ 370,  14},
{1165,   0},{ 997,  21},{ 370,  14},{ 436,   0},{ 370,  14},
{ 370,  14},{1165,   0},{ 370,  14},{ 269,  15},{ 997,  21},
{ 420,   0},{ 997,  21},{ 269,  15},{ 269,  15},{ 420,   0},
{ 997,  21},{ 417,  16},{ 997,  21},{ 412,   0},{ 997,  21},
{ 417,  16},{ 417,  16},{ 412,   0},{ 997,  21},{ 394,  17},
{ 997,  21},{ 737,   0},{ 997,  21},{ 394,  17},{ 394,  17},
{ 737,   0},{ 997,  21},{ 431,  18},{ 370,  14},{ 431,  18},
{ 269,  15},{ 431,  18},{ 417,  16},{ 431,  18},{ 394,  17},
{ 431,  18},{ 997,  21},{ 572,   0},{ 997,  21},{ 431,  18},
{ 997,  21},{ 701,   0},{ 997,  21},{ 431,  18},{ 997,  21},
{ 867,  19},{ 867,  19},{ 867,  19},{ 431,  18},{ 428,   0},
{ 635,  20},{ 635,  20},{ 431,  18},{ 997,  21},{ 396,   0},
{ 431,  18},{ 404,   0},{ 997,  21},{ 717,   2},{ 997,  21},
{ 997,  21},{ 444,   0},{ 580,   1},{ 997,  21},{ 580,   1},
{ 997,  21},{ 580,   1},{ 396,   0},{ 867,  19},{ 635,  20},
{ 404,   0},
};


int yyySortsInd[] = {
  0,
  0,  1,  2,  4,  6,  9, 11, 12, 14, 18,
 22, 25, 28, 30, 34, 38, 42, 46, 50, 53,
 56,
 60,
};


int yyySorts[] = {
  381,  423,  362,  260,  362,  260,  362,  260,  887,  362,
  260, 1012,  260,  544,  362,  260,  210,  809,  362,  260,
  210,  809,  362,  260,  210,  260,  210,  762,  260,  210,
  260,  210,  762,  809,  260,  210,  762,  809,  260,  210,
  762,  809,  260,  210,  762,  809,  260,  210,  762,  809,
  260,  210,  762,  260,  210,  762,  260,  210,  762,  809,
};



char *yyyStringTab[] = {
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,"ParamDef",0,0,0,
0,"Def",0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
"ADD",0,"LetDef",0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,"Stats",0,
0,0,0,0,0,
"FieldDef",0,0,0,0,
0,0,0,0,0,
0,"right",0,0,0,
"T",0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,"t",0,0,
0,0,"y",0,"END",
0,0,0,0,0,
0,"reg",0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
"Funcdef",0,0,0,0,
0,0,"Structdef",0,0,
0,0,0,0,0,
0,0,"isdef",0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
"vartab",0,0,0,0,
0,0,0,0,0,
0,0,"NULL","reduce","GRE",
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,"Stat",0,0,0,
0,0,0,"NEG",0,
0,0,0,0,0,
"fieldtab",0,0,0,0,
0,0,0,0,"Addexpr",
0,0,0,0,0,
0,0,0,0,0,
0,0,"WITH",0,0,
0,"Lexpr",0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,"Start",
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,"THEN","structtab",0,0,
0,0,"subtab",0,0,
"Notexpr",0,0,0,0,
0,0,0,0,0,
0,"name",0,0,0,
0,0,0,0,0,
0,0,0,0,"Orexpr",
0,"'('",0,0,"symtab",
0,0,0,0,"')'",
0,0,0,0,0,
0,0,"'*'",0,0,
0,"strdup","Mulexpr",0,0,
"'+'",0,0,"val",0,
"label",0,0,"','",0,
"int64_t","Expr",0,0,0,
0,"'-'",0,0,0,
0,"tnode_t","prolog",0,"'.'",
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,"updatescope1",0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,"symtab_t",
0,0,0,0,0,
0,0,0,0,0,
"':'",0,"updatescope2",0,"structname",
0,0,0,"';'",0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,"'='",
0,0,0,0,0,
0,0,"'>'",0,0,
0,0,0,0,0,
"IDENTIFIER",0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
"asm",0,0,0,0,
0,0,0,0,0,
0,0,0,"init",0,
0,0,0,0,0,
0,0,0,0,0,
"FinalArg",0,0,0,"num",
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,"codegen",0,
0,0,"FUNC",0,0,
0,0,0,0,0,
0,0,0,0,0,
"COND",0,0,0,0,
0,0,0,0,0,
0,0,"nodupcheck","stentry",0,
0,0,0,0,0,
0,0,0,0,"IN",
"MUL","NOTEQUAL","DO",0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,"NUMBER",0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,"OR","checkscope",0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,"visscope",0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,"strtol",0,0,0,
0,0,0,0,0,
0,0,0,"Condlist",0,
0,0,0,0,0,
0,0,0,0,0,
0,0,"var",0,"node",
0,0,0,0,0,
0,0,0,0,0,
0,"dup",0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,"RETURN",0,
0,0,0,0,0,
0,0,0,0,0,
"next",0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,"ExprList",0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,"dummy1",0,0,
0,0,0,"NEQ",0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,"func",0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,"ret",0,
0,0,0,0,0,
0,0,0,0,0,
"reset",0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,"Term",0,0,
0,0,0,0,0,
0,0,0,"nval","op",
0,0,"tab","sval","Program",
0,0,0,0,0,
0,0,0,"yytext",0,
0,0,0,0,0,
0,0,0,0,"merge",
0,0,0,0,0,
0,0,0,0,0,
0,0,"regcursor",0,"STRUCT",
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,"LET",0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,"burm",
0,0,0,0,0,
"add",0,0,0,0,
0,"new",0,0,0,
0,0,0,0,0,
0,0,0,0,0,
"NOT",0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,"int64",0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0,
0,
};



#define yyySizeofProd(num) (yyyProdsInd[(num)+1] - yyyProdsInd[(num)])

#define yyyGSoccurStr(prodNum,symPos) \
   (yyyStringTab[yyyProds[yyyProdsInd[(prodNum)] + (symPos)][0]])

#define yyySizeofSort(num) (yyySortsInd[(num)+1] - yyySortsInd[(num)])

#define yyySortOf(prodNum,symPos) \
  (yyyProds[yyyProdsInd[(prodNum)] + (symPos)][1]) 

#define yyyAttrbStr(prodNum,symPos,attrbNum)                      \
  (yyyStringTab[yyySorts[yyySortsInd[yyySortOf(prodNum,symPos)] + \
                         (attrbNum)                               \
                        ]                                         \
               ]                                                  \
  )



void yyyShowProd(i)
  int i;
  {int j,nSyms;

   nSyms = yyySizeofProd(i);
   for (j=0; j<nSyms; j++)
     {
      fprintf(stderr,"%s",yyyGSoccurStr(i,j));
      if (j == 0) fprintf(stderr," : "); else fprintf(stderr," ");
     }
   fprintf(stderr,";\n");
  }



void yyyShowProds()
  {int i; for (i=1; i<=yyyLastProdNum; i++) yyyShowProd(i);}



void yyyShowSymsAndSorts()
  {int i; 

   for (i=1; i<=yyyLastProdNum; i++) 
     {int j, nSyms;

      fprintf(stderr,
              "\n\n\n---------------------------------- %3.1d\n",i);
      /* yyyShowProd(i); */ 
      nSyms = yyySizeofProd(i); 
      for (j=0; j<nSyms; j++) 
        {int k, sortSize;

         fprintf(stderr,"%s\n",yyyGSoccurStr(i,j));
         sortSize = yyySizeofSort(yyySortOf(i,j));
         for (k=0; k<sortSize; k++) 
            fprintf(stderr,"  %s\n",yyyAttrbStr(i,j,k));
         if (j == 0) fprintf(stderr,"->\n"); 
              else 
              fprintf(stderr,"\n"); 
        }
     }
  }



void yyyCheckNodeInstancesSolved(np)
  yyyGNT *np;
  {int mysort,sortSize,i,prodNum,symPos,inTerminalNode;
   int nUnsolvedInsts = 0;

   if (np->prodNum != 0)
     {inTerminalNode = 0;
      prodNum = np->prodNum;
      symPos = 0;
     }
   else
     {inTerminalNode = 1;
      prodNum = ((yyyGNT *)(np->parent))->prodNum;
      symPos = np->whichSym;
     }
   mysort = yyySortOf(prodNum,symPos);
   sortSize = yyySizeofSort(mysort);
   for (i=0; i<sortSize; i++)
     if ((np->refCountList)[i] != 0) nUnsolvedInsts += 1;
   if (nUnsolvedInsts)
     {fprintf(stderr,
      "\nFound node that has %d unsolved attribute instance(s).\n",
              nUnsolvedInsts
             );
      fprintf(stderr,"Node is labeled \"%s\".\n",
             yyyGSoccurStr(prodNum,symPos));
      if (inTerminalNode)
        {fprintf(stderr,
                 "Node is terminal.  Its parent production is:\n  ");
         yyyShowProd(prodNum);
        }
      else
        {fprintf(stderr,"Node is nonterminal.  ");
         if (((char *)(np->parent)) >= yyyNodeSpace)
           {fprintf(stderr,
                    "Node is %dth child in its parent production:\n  ",
                   np->whichSym
                  );
            yyyShowProd(((yyyGNT *)(np->parent))->prodNum);
           }
         fprintf(stderr,
                 "Node is on left hand side of this production:\n  ");
         yyyShowProd(np->prodNum);
        }
      fprintf(stderr,"The following instances are unsolved:\n");
      for (i=0; i<sortSize; i++)
        if ((np->refCountList)[i] != 0)
          fprintf(stderr,"     %-16s still has %1d dependencies.\n",
                  yyyAttrbStr(prodNum,symPos,i),(np->refCountList)[i]);
     }
  }



void yyyUnsolvedInstSearchTravAux(pNode)
  yyyGNT *pNode;
  {yyyGNT **yyyCLpdum;
   int i;
  
   yyyCheckNodeInstancesSolved(pNode); 
   yyyCLpdum = pNode->cL;
   while
     ((yyyCLpdum != yyyNextCLspace) && ((*yyyCLpdum)->parent == pNode))
     {
      yyyUnsolvedInstSearchTravAux(*yyyCLpdum);
      yyyCLpdum++;
     }
  }



void yyyUnsolvedInstSearchTrav(pNode)
  yyyGNT *pNode;
  {yyyGNT **yyyCLpdum;
   int i;
  
   yyyCLpdum = pNode->cL;
   while
     ((yyyCLpdum != yyyNextCLspace) && ((*yyyCLpdum)->parent == pNode))
     {
      yyyUnsolvedInstSearchTravAux(*yyyCLpdum);
      yyyCLpdum++;
     }
  }



