#include <stdio.h>
#include <string.h>
#include <stdlib.h>

unsigned char *str1, *str2;
unsigned char *str, *str_ref;


extern void asma(unsigned char *s, unsigned char *t, unsigned char *u);

void 
asma_ref(unsigned char *s, unsigned char *t, unsigned char *u)
{
	int i;

	for (i = 0; i < 16; i++)
		u[i] = (s[i] > t[i]) ? s[i] : t[i];
}

void
test(int a, char *s, char *t)
{
	printf("===========================\n");
	printf("%d. test\n", a);

	strncpy((char *)str1, (const char *)s, 16);
	strncpy((char *)str2, (const char *)t, 16);
	str1[16] = str2[16] = '\0';

	printf("str1: %s\n", (char *)str1);
	printf("str2: %s\n", (char *)str2);
	printf("\n");

	asma(str1, str2, str);
	asma_ref(str1, str2, str_ref);
	
	str[16] = str_ref[16] = '\0';

	printf("str:        %s\n", str);
	printf("str_ref:    %s\n", str_ref);
	printf("\n");

	printf(strncmp((const char *)str, (const char *)str_ref, 16) ? "status: fail\n" : "status: ok\n");
}

int
main(int argc, char *argv[])
{

	str1 = malloc(17);
	str2 = malloc(17);

	str = malloc(17);
	str_ref = malloc(17);

	test(1, "1234567890abcdef", "abc987def654ghi3");
	test(2, "                ", "!!  !!  --  ..  ");
	test(3, "~ prObE__PRoBe ~", "==ProBE--pRObe==");
	test(4, "!!$$%%&&(())==##", "@@##++**\?\?==&&%%");

	free(str);
	free(str_ref);

	free(str2);
	free(str1);

	return 0;
}

