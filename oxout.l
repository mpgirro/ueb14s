/* output from Ox version G1.04 */

%{  /* Definitions */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h> /* for 64 bit int */
#include "oxout.tab.h"
#include "symtab.h"
#include "syntree.h"

extern void lexerror(int);
void process_comment(char *comment);

%}

%option   yylineno

IDENTIFIER	[a-zA-Z]+[0-9a-zA-Z_]*
DECNUMBER	[0-9]+
HEXNUMBER	[0-9]+[0-9a-fA-F]*[H|h]
WHITESPACE	[ \t\n]
COMMENT		"/*"
OTHER		.


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
%% /* Rules */

{WHITESPACE}	;
{COMMENT}	process_comment(yytext);

struct	{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return STRUCT;} };
end		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return END;} 	 };
func	{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return FUNC;} 	 };
return	{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return RETURN;} };
with	{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return WITH;}   };
do		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return DO;}     };
let		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return LET;}    };
in		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return IN;}     };
cond	{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return COND;}   };
then	{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return THEN;}   };
not		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return NOT;}    };
or		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return OR;} 	 };

\:		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return ':';} };
\(		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return '(';} };
\)		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return ')';} };
\;		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return ';';} };
\.		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return '.';} };
\-		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return '-';} };
\+		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return '+';} };
\*		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return '*';} };
\>		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return '>';} };
\=		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return '=';} };
\,		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return ',';} };

"<>"		{ {yyyGenLeaf(0,0,yyyLRCIL+0,yyyLRCIL+0);return NOTEQUAL;} };

{DECNUMBER}	{ /*yylval.nval = (signed long) strtol( yytext, NULL, 10);*/ {yyyGenLeaf(1,2,yyyLRCIL+0,yyyLRCIL+1); (((yyyP2)(yyyTermBuffer.snBufPtr))->val) = (int64_t) strtol(yytext,NULL,10); return NUMBER;}  };
{HEXNUMBER}	{ /*yylval.nval = (signed long) strtol( yytext, NULL, 16);*/ {yyyGenLeaf(1,2,yyyLRCIL+0,yyyLRCIL+1); (((yyyP2)(yyyTermBuffer.snBufPtr))->val) = (int64_t) strtol(yytext,NULL,16); return NUMBER;}  };

{IDENTIFIER}	{ {yyyGenLeaf(1,1,yyyLRCIL+1,yyyLRCIL+2); (((yyyP1)(yyyTermBuffer.snBufPtr))->name) = strdup(yytext); return IDENTIFIER;}  };

{OTHER}		{ lexerror(yylineno); };

%% /* Code */

void process_comment(char *comment)
{
	/* stole this from https://www.cs.princeton.edu/~appel/modern/c/software/flex/flex.html */
	register int c;

	for ( ; ; )
	{
		/* eat up text of comment */
		while ( (c = input()) != '*' && c != EOF );

		/* so, lets check if the comment is truly over */
		if ( c == '*' )
		{	
			/* eat up all the stars, in case there are more */
			while ( (c = input()) == '*' ) ;
                    	
			/* check if comments is finally over */
			if ( c == '/' )
				break;    /* found the end */
        }

		/* oh boy - this should never be happening */
        if ( c == EOF )
        {
			lexerror(yylineno);
            break;
        }
	}
}
