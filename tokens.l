
%{

#include <stdio.h>
#include "grammar.tab.h"

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

%%

{WHITESPACE}	;
{COMMENT}		process_comment(yytext);

struct		{ return STRUCT; };
end			{ return END; 	 };
func		{ return FUNC; 	 };
return		{ return RETURN; };
with		{ return WITH;   };
do			{ return DO;     };
let			{ return LET;    };
in			{ return IN;     };
cond		{ return COND;   };
then		{ return THEN;   };
not			{ return NOT;    };
or			{ return OR; 	 };

\:			{ return ':'; };
\(			{ return '('; };
\)			{ return ')'; };
\;			{ return ';'; };
\.			{ return '.'; };
\-			{ return '-'; };
\+			{ return '+'; };
\*			{ return '*'; };
\>			{ return '>'; };
\=			{ return '='; };
\,			{ return ','; };

"<>"			{ return NOTEQUAL; };

{DECNUMBER}	{ yylval.nval = (signed long) strtol( yytext, NULL, 10); return NUMBER; };
{HEXNUMBER}	{ yylval.nval = (signed long) strtol( yytext, NULL, 16); return NUMBER; };

{IDENTIFIER}			{ yylval.sval = strdup(yytext); return IDENTIFIER; };

{OTHER}					{ lexerror(yylineno); }

%%

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