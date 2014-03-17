/**
 * @file main.c
 * @author Maximilian Irro <e1026859@student.tuwien.ac.at>
 * @date last revision 2014-03-16
 * @brief testpogram for Uebersetzerbau Bsp1 "Assambler A"
 */

/* === librarys === */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdarg.h>

void print_hex(const char *varname, unsigned char *s);

/* === externals === */
extern void asma(unsigned char *s, unsigned char *t, unsigned char *u);


int main(int argc, char **argv)
{
	
	unsigned char 	*s, *t, *u;
	s = malloc(17);
	t = malloc(17);
	u = malloc(17);
					
	strncpy((char *) s, "abcdehfghijklmno", 16);
	strncpy((char *) t, "yjhdflkffkdkfkfv", 16);
	/*
	(void) printf("s: %s (%x)\n", s, (unsigned int)(s & 0xff));
	(void) printf("t: %s (%x)\n", t, (unsigned int)(t & 0xff));
	*/
	print_hex("s",s);
	print_hex("t",t);

	asma(s,t,u);
	u[16] = '\0';
	
	/*(void) printf("u: %s (%x)\n", u, (unsigned int)(u & 0xff));*/
	print_hex("u",u);
	
	free(s);
	free(t);
	free(u);
	
	return 0;
}

void print_hex(const char *varname,unsigned char *s)
{
	(void) printf("%s: %s (0x",varname,s);
	while(*s)
	{
		(void) printf("%02x",(unsigned int) *s++);
	}
	(void) printf(")\n");
}
