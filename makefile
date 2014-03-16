cc	=	cc	# clang oder gcc

CFLAGS	=	-ansi -pedantic -Wall -D_BSD_SOURCE -g
CFLAGS	+=	-Wno-trigraphs

LDFLAGS	=	
ASFLAGS	=	

PROG	=	main_debug
PRJ		=	asma
CONV	=	
SRCS	=	$(PROG).c $(PRJ).s
OBJS	=	$(PROG).o $(PRJ).o

all: $(PROG)

$(PROG): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(PROG)

$(PROG).o: $(PROG).c
	$(CC) $(CFLAGS) -c $(PROG).c

$(PRJ).o: $(PRJ).s
	$(CC) $(CFLAGS) -c $(PRJ).s

clean:
	-rm -f $(PROG) $(OBJS) *~ 



