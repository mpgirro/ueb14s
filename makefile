
OX_FILES = oxout.y oxout.l
BISON_FILES = oxout.tab.h oxout.tab.c
FLEX_FILES = lex.yy.c
ABGABE_FILES = gram.y scan.l symtab.c syntree.c code_gen.c symtab.h syntree.h code_gen.h code.bfe

LIBS = symtab.o syntree.o code_gen.o

.PHONY: all clean 

# creates the parser
all: ag							

# removes all generated files
clean:
	rm -rf $(wildcard *~) $(wildcard *.o) $(OX_FILES) $(BISON_FILES) $(FLEX_FILES) codea
	
# creates oxout.y oxout.l
ox:	ram.y scan.l libs
	ox ram.y scan.l
	
# creates oxout.tab.h oxout.tab.c
bison: ox
	bison -d -v oxout.y
	
# creates lex.yy.c
flex: ox
	flex oxout.l
	
ox.o: bison 
	gcc -c oxout.tab.c -o ox.o -Wno-format
	
lex.o: flex
	gcc -c lex.yy.c -o lex.o
	
code.o: iburg
	gcc -c code.c -o code.o
	
codea: ox.o lex.o libs
	gcc ox.o lex.o code.o $(LIBS) -lfl -o codea
	
libs: symtab.c syntree.c code_gen.c
	gcc -c symtab.c -o symtab.o 
	gcc -c syntree.c -o syntree.o
	gcc -c code_gen.c -o code_gen.o
	
bfe: code.bfe
	bfe code.bfe > code.brg
	
iburg: bfe
	iburg code.brg > code.c
	
abgabe:
	cp makefile $(ABGABE_FILES) ~/abgabe/codea/
