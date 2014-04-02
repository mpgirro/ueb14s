
%{

#include <stdio.h>
#include "grammar.tab.h"

extern void lexerror(int);

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
{COMMENT}		;

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

{DECNUMBER}	{ yylval.nval = (signed long) strtol( yytext, NULL, 10); return DECNUMBER; };
{HEXNUMBER}	{ yylval.nval = (signed long) strtol( yytext, NULL, 16); return HEXNUMBER; };

{IDENTIFIER}			{ yylval.sval = strdup(yytext); return IDENTIFIER; };

{OTHER}					{ lexerror(yylineno); }

%%