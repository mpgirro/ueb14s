cc	=	cc	# clang oder gcc

CFLAGS	=	-ansi -pedantic -Wall -D_BSD_SOURCE -g
CFLAGS	+=	-Wno-trigraphs

LDFLAGS	=	
ASFLAGS	=	

PROG	=	main
PRJ	=	asmb
CONV	=	
SRCS	=	$(PROG).c $(PRJ).s
OBJS	=	$(PROG).o $(PRJ).o

$(PRJ).o: $(PRJ).s
	$(CC) $(CFLAGS) -c $(PRJ).s

all: $(PROG)

$(PROG): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(PROG)

$(PROG).o: $(PROG).c
	$(CC) $(CFLAGS) -c $(PROG).c

clean:
	-rm -f $(PROG) $(OBJS) *~ 

abgabe:
	cp makefile $(SRCS) ~/abgabe/asmb/

