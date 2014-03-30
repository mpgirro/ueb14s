%option yylineno

%{
	void process_keyword(char *keyword);
	void process_lexem(char *lexem);
	void process_identifier(char *identifier);
	void process_decnumber(char *decnumber);
	void process_hexnumber(char *hexnumber);
	void process_whitespace(char *whitespace);	
	void process_comment(char *comment);
	void process_other(char *other, int lineno);
%}

keyword		struct|end|func|return|with|do|let|in|cond|then|not|or
lexem		[:\(\);=\.\-\+\*\>,]|<>
identifier	[a-zA-Z]+[0-9a-zA-Z_]*
decnumber	[0-9]+
hexnumber	[0-9]+[0-9a-fA-F]*[H|h]
whitespace	[ \t\n]
comment		"/*"
other		.

%%

{keyword}		process_keyword(yytext);
{lexem}			process_keyword(yytext);
{identifier}		process_identifier(yytext);
{decnumber}		process_decnumber(yytext);
{hexnumber}		process_hexnumber(yytext);
{whitespace}		process_whitespace(yytext);
{comment}		process_comment(yytext);
{other}			process_other(yytext,yylineno);

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

	yylex();

	/* if we reached this, everything went well */
	exit(EXIT_SUCCESS);
}

void process_keyword(char *keyword)
{
	/* print only the keyword */
	(void) fprintf(stdout, "%s\n", keyword);
}

void process_lexem(char *lexem)
{
	/* print only the lexem */
	(void) fprintf(stdout, "%s\n", lexem);
}

void process_identifier(char *identifier)
{
	/* print "id" followed by the identifier */
	(void) fprintf(stdout, "id %s\n", identifier); 
}

void process_decnumber(char *decnumber)
{
	char *endptr;
	/* print "num" followed by the number */
	(void) fprintf(stdout, "num %ld\n", (signed long) strtol( decnumber, &endptr, 10));  
}

void process_hexnumber(char *hexnumber)
{
	char *endptr;
	/* print "num" followed hexnumber in decimal representation */
	(void) fprintf(stdout, "num %ld\n", (signed long) strtol( hexnumber, &endptr, 16));
}

void process_whitespace(char *whitespace)
{
	/* nothing to do here */
}

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
			(void) fprintf(stderr, "EOF in comment\n");
			exit(EXIT_FAILURE);	
                	break;
                }
	}
}

void process_other(char *other, int lineno)
{
	(void) fprintf(stderr, "lexical error in line %d (invald character sequence: %d)\n", lineno, other);
	exit(EXIT_FAILURE);
}
