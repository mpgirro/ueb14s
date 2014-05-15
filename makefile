
OX_FILES = oxout.y oxout.l
BISON_FILES = oxout.tab.h oxout.tab.c
FLEX_FILES = lex.yy.c
OBJECT_FILES = ox.o lex.o
SRCS_FILES = gram.y scan.l
ABGABE_FILES = gram.y scan.l symtab.h symtab.c

LIBS = symtab.o syntree.o

.PHONY: all clean

# creates the parser
all: ag							

# removes all generated files
clean:
	rm -rf $(wildcard *~) $(wildcard *.o) $(OX_FILES) $(BISON_FILES) $(FLEX_FILES) $(OBJECT_FILES) ag 
	
# creates oxout.y oxout.l
ox:	$(SRCS_FILES) libs
	ox $(SRCS_FILES)
	
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
	
ag: ox.o lex.o 
	gcc ox.o lex.o symtab.o  -lfl -o ag
	
codea: libs
	
libs: symtab.c 
	gcc -c symtab.c -o symtab.o
	
abgabe:
	cp makefile $(ABGABE_FILES) ~/abgabe/codea/
