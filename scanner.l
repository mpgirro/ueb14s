% option yylineno

%{
	void handle_keyword(char *keyword);
	void handle_identifier(char *identifier);
	void handle_decnumber(char *decnumber);
	void handle_hexnumber(char *hexnumber);	
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
{decnumber}		handle_decnumber(yytext);
{hexnumber}		handle_hexnumber(yytext);
{whitespace|comment}	handle_comment(yytext);
{other}			handle_other(yytext,yylineno);

%%

int main(int argc, char **argv)
{
	/* decide whether to to read from file or from input stream */
	if( argc > 1)
	{
		yyin = fopen(argv[1],"r");
	} else {
		yyin = stdin;
	}

	yylex();

	/* if we reached this, everything went well */
	exit(EXIT_SUCCESS);
}

void handle_keyword(char *keyword)
{
	/* print only the lexem */
	(void) fprintf(stdout, "%s\n", keyword);
}

void handle_identifier(char *identifier)
{
	/* print "id" followed by the identifier */
	(void) fprintf(stdout, "id %s\n", identifier); 
}

void handle_decnumber(char *decnumber)
{
	char *endptr;
	/* print "num" followed by the number */
	(void) fprintf(stdout, "num %ld\n", (signed long) strtol( decnumber, &endptr, 10);  
}

void handle_hexnumber(char *hexnumber)
{
	char *endptr;
	/* print "num" followed hexnumber in decimal representation */
	(void) fprintf(stdout, "num %ld\n", (signed long) strtol( hexnumber, &endptr, 16);
}

void handle_comment(char *comment)
{
	/* nothing to do here */
}

void handle_other(char *other)
{
	(void) fprintf(stderr, "lexical error in line %d (invald character sequence: %d)\n", line, other);
	exit(EXIT_FAILURE);
}
