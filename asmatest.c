/**
 * @file main.c
 * @author Maximilian Irro <e1026859@student.tuwien.ac.at>
 * @date last revision 2014-03-15
 * @brief testpogram for Uebersetzerbau Bsp1 "Assambler A"
 */

/* === librarys === */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdarg.h>

/* === function signatures === */
static void usage(void);
static void errorMsg(char *msg);
void asma_c(unsigned char *s, unsigned char *t, unsigned char *u);

/* === global variables === */
static const char *prgname = "asmatest"; 

/* === externals === */
extern void asma(unsigned char *s, unsigned char *t, unsigned char *u);


int main(int argc, char **argv)
{
	
	char *string1, *string2;
	
    /* set program name */
    if( argc > 0 )
        prgname = argv[0];
        
    /* check for command line options, none are allowed */
    while( (c = getopt(argc, argv, "")) != EOF )
	{
        switch( c )
		{
            case '?':   
                usage();
                break;
            default:
                (void) fprintf(stderr,"You managed the impossible! Congratulations on that\n");
                assert( 0 );
                break;
        }
    }
	
    /* check for correct amount of command line arguments */
    if( argc == 3 )
	{
		// strings provided via command line
		*string1 = argv[1];
		*string2 = argv[2];
	}	
	else if (argc == 1)
	{
		// use default strings
		*string1 = "abcdehfghijklmno";
		*string2 = "yjhdflkffkdkfkfv";
	}
	else
	{
        usage();
	}
	
	printf("String 1: %s\nString 2: %s\n",string1,string2);
	
}


/**
 * @brief mandatory usage function
 */
static void usage(void)
{
    (void) fprintf( stderr, "Usage: %s <string1> <string2>\n", prgname);
    exit(EXIT_FAILURE);
}

/**
 * @brief writes a message to stderr
 * @param msg The error message
 */
static void errorMsg(char *msg)
{
    (void) fprintf( stderr, "%s: ERROR %s\n", prgname, msg);
}


static void signal_handler(int sig)
{
    /* ignore other signals */
    if( sig!=SIGINT && sig!=SIGQUIT && sig!= SIGTERM )
        return;

    /* signals need to be blocked by sigaction */
    DEBUG("Caught Signal\n");
    exit(EXIT_SUCCESS);
}


void asma_c(unsigned char *s, unsigned char *t, unsigned char *u)  
{  
  int i;  
  for (i=0; i<16; i++)  
    u[i] = (s[i]>t[i]) ? s[i] : t[i];  
}