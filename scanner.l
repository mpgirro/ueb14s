% option yylineno

%{
	void handle_keyword(char *keyword);
	void handle_identifier(char *identifier);
	void handle_number(char *number, int base);	
	void handle_comment(char *comment);
	void handle_other(char *other, int line);
%}

keyword		struct|end|func|return|with|do|let|in|cond|then|not|or
lexem		[:\(\);=\.\-\+\*\>]|<>
identifier	[a-zA-Z]+[0-9a-zA-Z_]*
decnumber	[0-9]+
hexnumber	[0-9]+[0-9a-fA-F]*[H|h]
whitespace	[ \t\n]
comment		\/\*.*\*\/
other		.

%%

{keyword|lexem}		handle_keyword(yytext);
{identifier}		handle_identifier(yytext);
{decnumber}		handle_number(yytext,10);
{hexnumber}		handle_number(yytext,16);
{whitespace|comment}	handle_comment(yytext);
{other}			handle_other(yytext,yylineno);


