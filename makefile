
BISON_FILES = grammar.tab.h grammar.tab.c
FLEX_FILES = lex.yy.c
OBJECT_FILES = scanner.o

.PHONY: all clean

# creates the parser
all: parser							

# removes all generated files
clean:
	rm -rf $(BISON_FILES) $(FLEX_FILES) $(OBJECT_FILES) parser
	
bison:
	bison -d grammar.y
	
flex:
	flex tokens.l
	
parser: bison flex
	gcc main.c grammar.tab.c lex.yy.c -lfl -o parser
	
