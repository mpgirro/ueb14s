
%{

#include <stdio.h>
#include "grammar.tab.h"

extern void lexerror(int);

%}

%option   yylineno

identifier	[a-zA-Z]+[0-9a-zA-Z_]*
decnumber	[0-9]+
hexnumber	[0-9]+[0-9a-fA-F]*[H|h]
whitespace	[ \t\n]
comment		"/*"
other		.

%%

{whitespace}	;
{comment}		;

struct		{ return struct; };
end			{ return end; 	 };
func		{ return func; 	 };
return		{ return return; };
with		{ return with;   };
do			{ return do;     };
let			{ return let;    };
in			{ return in;     };
cond		{ return cond;   };
then		{ return then;   };
not			{ return not;    };
or			{ return or; 	 };

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

<>			{ return notequal; };

{decnumber}	{ yylval.nval = (signed long) strtol( yytext, NULL, 10); return number; };
{hexnumber}	{ yylval.nval = (signed long) strtol( yytext, NULL, 16); return number; };

{identifier}			{ yylval.sval = strdup(yytext); return identifier; };

{other}					{ lexerror(yylineno); }

%%