/**
 * @file main.c
 * @author Maximilian Irro <e1026859@student.tuwien.ac.at>
 * @date last revision 2014-03-16
 * @brief testpogram for Uebersetzerbau Bsp1 "Assambler A"
 */

/* === librarys === */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdarg.h>

/* === externals === */
extern void asma(unsigned char *s, unsigned char *t, unsigned char *u);


int main(int argc, char **argv)
{
	
	unsigned char 	*s, *t, *u;
	s = malloc(17);
	t = malloc(17);
	u = malloc(17);
					
	*s = "abcdehfghijklmno",
	*t = "yjhdflkffkdkfkfv", 
	s[16] = t[16] = u[16] = '\0';
	
	(void) printf("s: %s\n", s);
	(void) printf("t: %s\n", t);
	(void) printf("u: %s\n", asma(s,t,u));
	
	free(s);
	free(t);
	free(u);
	
	return 0;
}


