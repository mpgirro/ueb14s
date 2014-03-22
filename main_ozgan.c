#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern void asmb(unsigned char *s, unsigned char *t, unsigned char *u);

void 
asmb_ref(unsigned char *s, unsigned char *t, unsigned char *u)
{
	int i;

	for (i = 0; s[i] && t[i]; i++)
		u[i] = (s[i] < t[i]) ? s[i] : t[i];
	
	u[i] = '\0';
}

void
test(int a, char *s, char *t)
{
	int i;
	int dim1;
	int dim2;

	unsigned char *str1, *str2;
	unsigned char str[256], str_ref[256];

	dim1 = strlen(s);
	dim2 = strlen(t);

	str1 = malloc(dim1+1);
	str2 = malloc(dim2+1);

	memset(str1, '\0', dim1+1);
	memset(str2, '\0', dim2+1);

	strncpy((char *)str1, (const char *)s, dim1);
	strncpy((char *)str2, (const char *)t, dim2);

	str1[dim1] = '\0';
	str2[dim2] = '\0';

	printf("===========================\n");
	printf("%d. test\n", a);

	printf("str1: %s - %d Byte\n", (char *)str1, (int)strlen((const char *)str1));
	printf("str2: %s - %d Byte\n", (char *)str2, (int)strlen((const char *)str2));
	printf("\n");

	asmb(str1, str2, str);
	asmb_ref(str1, str2, str_ref);

	printf("str:        %s - %d Byte\n", str, (int)strlen((const char *)str));
	printf("str_ref:    %s - %d Byte\n", str_ref, (int)strlen((const char *)str_ref));
	printf("\n");

	printf(strcmp((const char *)str, (const char *)str_ref) ? 
		"status: fail\n" : "status: ok\n");

	free(str1);
	free(str2);
}

int
main(int argc, char const *argv[])
{
	test(1, "19999999999999999991334445556", "1111222233334444555");
	test(2, "0e1c2a3846546200", "01f2e3d4c500");
	test(3, "a", "bbbbbbbbbbbbb");
	test(4, "aaa", "bbbbbbbbbbbbbbcccccccccccccccc");
	
	return 0;
}

