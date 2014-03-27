CC	= gcc
FLEXF 	= lex.yy.c
SCANNER = scanner
OBJS	= $(SCANNER).o
SRCS	= $(SCANNER).l

.PHONY: all clean

all: scanner							

# removes all generated object files
clean:
	rm -rf $(FLEXF) $(OBJS) $(SCANNER)
	
# creates the flex c file
flex: $(SCANNER).l
	flex $(SCANNER).l
	
# creates the scanner binary
scanner: flex
	$(CC) -c $(FLEXF) -o $(OBJS)
	$(CC) $(OBJS) -o $(SCANNER) -lfl
	
abgabe:
	cp makefile $(SRCS) ~/abgabe/scanner/
	
