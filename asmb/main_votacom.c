#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void asmb(unsigned char *s, unsigned char *t, unsigned char *u);

int main(int argc, const char* argv[]) {
	if (argc < 3) {
		printf("at least 2 arguments needed.\n");
		return 1;
	}
	int alen = strlen(argv[1]);
	int blen = strlen(argv[2]);
	unsigned char *a = malloc(alen + 16);
	unsigned char *b = malloc(blen + 16);
	strncpy(a, argv[1], alen + 1);
	strncpy(b, argv[2], blen + 1);

	int max = alen;
	if (blen > alen)
		max = blen;
	unsigned char *c = malloc(max + 16);

	asmb(a, b, c);
	printf("%s\n", c);

	free(a);
	free(b);
	free (c);
}

