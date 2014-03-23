#include <stdio.h>
#include <string.h>
#include <mcheck.h>
#include <stdlib.h>

extern void asmb(unsigned char *s, unsigned char *t, unsigned char *u);
extern void asmb_callchecking(unsigned char *s, unsigned char *t, unsigned char *u);

void orig_asmb(unsigned char *s, unsigned char *t, unsigned char *u)  
{  
  int i;  
  for (i=0; s[i] && t[i]; i++)  
    u[i] = (s[i]<t[i]) ? s[i] : t[i];  
  u[i] = '\0';  
} 

void printarray(unsigned char* bufstart, int buflength, unsigned char* s)
{
  int i;
  unsigned char *p=s-16;
  unsigned long pl;
  unsigned long l=strlen(s)+1;
  if (p<bufstart)
    p=bufstart;
  pl=s+l+16-p;
  if (p+pl>bufstart+buflength)
    pl=bufstart+buflength-p;
  printf("%p=",p);
  for(i=0; i<pl; i++) {
    if(p+i==s)
      printf("[");
    if (p+i==s+l)
      printf("]");
    printf("%02x",p[i]);
  }
  printf("\n");
}

int test(unsigned char* s,unsigned char* t, unsigned char* u, unsigned long l, 
	 unsigned long sl,unsigned long tl,
	 unsigned long sa,unsigned long ta, unsigned long ua)
{
  unsigned char stmp[l+16];
  unsigned char ttmp[l+16];
  unsigned char utmp[l+16];

  // init
  int i;
  int off=sa+ta+ua*8;
  for (i=0; i<l+16; i++) {
    s[i]=i*14*off;
    t[i]=256-i*15+off;
  }
  s[sa+sl]='\0';
  t[ta+tl]='\0';

  // check
  memcpy(stmp,s,l+16);
  memcpy(ttmp,t,l+16);
  memset(u,0xff,l);
  memset(utmp,0xff,l);
  printf("\nCalling asmb(%p,%p,%p) with\n",s+sa,t+ta,u+ua);
  printarray(s,l+16,s+sa);
  printarray(t,l+16,t+ta);
  fflush(stdout);
  printf("Result:\n");
  asmb_callchecking(s+sa,t+ta,u+ua);
  printarray(u,l+16,u+ua);

  orig_asmb(stmp+sa,ttmp+ta,utmp+ua);

  if (memcmp(utmp,u,strlen(utmp+ua)+ua+1)!=0) {
    printf("failed: return value wrong. Expected:\n");
    printarray(utmp,l+16,utmp+ua);
    return 0;
  } else if (memcmp(stmp,s,l+16)!=0) {
    printf("failed: s modified\n");
    printarray(s,l+16,s+sa);
    printarray(stmp,l+16,stmp+sa);
    return 0;
  } else if (memcmp(ttmp,t,l+16)!=0) {
    printf("failed: t modified\n");
    printarray(ttmp,l+16,ttmp+ta);
    printarray(ttmp,l+16,ttmp+ta);
    return 0;
  } else {
    printf("succeeded\n");
    return 1;
  }
}

int main() 
{
  int success=1;

  int l=51+16;
  unsigned char s[l];
  unsigned char t[l];
  unsigned char u[l];

  memset(s,0xff,l);
  memset(t,0xff,l);
  memset(u,0xff,l);

  l=l-16;

  int i,j,k,l1,l2;
  for(i=0; i<2;i++)
    for(j=0; j<2;j++)
      for(k=0; k<2;k++)
	for(l1=0; l1<48;l1+=7)
	  for(l2=0; l2<36;l2+=5)
	    success&=test(t,s,u,l-1, l1,l2,i,j,k);

  if (!success)
    fprintf(stdout,"\nTest failed.\n");
  else
    fprintf(stdout,"\nTest succeeded.\n");
  return !success;
}
