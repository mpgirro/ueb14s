/**
 * @file main.c
 * @author Maximilian Irro <e1026859@student.tuwien.ac.at>
 * @date last revision 2014-03-17
 * @brief testpogram for Uebersetzerbau Bsp2 "Assambler B"
 */

/* === librarys === */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdarg.h>

void print_hex(const char *varname, unsigned char *s);

/* === externals === */
extern void asmb(unsigned char *s, unsigned char *t, unsigned char *u);


int main(int argc, char **argv)
{
	
	unsigned char 	*s, *t, *u;
	s = malloc(17);
	t = malloc(17);
	u = malloc(17);
					
	strncpy((char *) s, "abcdehfghijklmno", 16);
	strncpy((char *) t, "yjhdflkffkdkfkfv", 16);

	s[13]='\0';

	print_hex("s",s);
	print_hex("t",t);

	asmb(s,t,u);
	u[16] = '\0';
	
	print_hex("u",u);
	
	free(s);
	free(t);
	free(u);
	
	return 0;
}

void print_hex(const char *varname,unsigned char *s)
{
	int i;
	(void) printf("%s: %s \t(0x",varname,s);
	for(i=0;i<16;i++)
	{
		(void) printf("%02x",(unsigned int) *s++);
	}
	(void) printf(")\n");
}
