# auto generated object file
OBJECT_FILES = asma.o asmatest.o

.PHONY: all clean

# creates the asma object file
all: asma							

# removes all generated object files
clean:
	rm -rf $(OBJECT_FILES) asma
	
# creates the asma object file
asma: asma.s
	gcc -c asma.s -o asma.o
	
asmatest: asma
	gcc -c asmatest.c -o asmatest.o
	gcc asmatest.o asma.o -o asma
	
# creates assembler code from a c file
assembler: 
	gcc -O -S asma.c

