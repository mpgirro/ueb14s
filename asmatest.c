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


/* === function signatures === */
static void usage(void);
static void errorMsg(char *msg);
void asma_c(unsigned char *s, unsigned char *t, unsigned char *u);

/* === global variables === */
static const char *prgname = "asmatest"; 


int main(int argc, char **argv)
{
	
	
	
	
}


/**
 * @brief mandatory usage function
 */
static void usage(void)
{
    (void) fprintf( stderr, "Usage: %s [-i infile] [-o outfile] [-e errfile] <cmd> [options]\n", prgname);
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


void asma_c(unsigned char *s, unsigned char *t, unsigned char *u)  
{  
  int i;  
  for (i=0; i<16; i++)  
    u[i] = (s[i]>t[i]) ? s[i] : t[i];  
}