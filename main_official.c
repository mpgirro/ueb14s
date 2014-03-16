#include <stdio.h>
#include <string.h>
#include <mcheck.h>
#include <stdlib.h>

extern void asma(unsigned char *s, unsigned char *t, unsigned char *u);
  
//extern uac_sigbus();
extern void asma_callchecking(unsigned char *s, unsigned char *t, unsigned char *u);

void orig_asma(unsigned char *s, unsigned char *t, unsigned char *u)  
{  
  int i;  
  for (i=0; i<16; i++)  
    u[i] = (s[i]>t[i]) ? s[i] : t[i];  
} 

void printarray(unsigned char* bufstart, int buflength, unsigned char* s)
{
  int i;
  unsigned char *p=s-16;
  unsigned long pl;
  unsigned long l=16;
  if (p<bufstart)
    p=bufstart;
  pl=s+l+16-p;
  if (p+pl>bufstart+buflength)
    pl=bufstart+buflength-p;
  printf("%p=",p);
  for(i=0; ;i++) {
    if (p+i==s+l)
      printf("]");
    if (!(i<pl))
      break;
    if(p+i==s)
      printf("[");
    printf("%02x",p[i]);
  }
  printf("\n");
}

int test(unsigned char* s,unsigned char* t, unsigned char* u,
	 unsigned long sa,unsigned long ta, unsigned long ua)
{
  unsigned long l=16;
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

  // check
  memcpy(stmp,s,l+16);
  memcpy(ttmp,t,l+16);
  memset(u,0xff,l);
  memset(utmp,0xff,l);
  printf("\nCalling asma(%p,%p,%p) with\n",s+sa,t+ta,u+ua);
  printarray(s+sa,l,s+sa);
  printarray(t+ta,l,t+ta);
  printf("Result:\n");
  asma_callchecking(s+sa,t+ta,u+ua);

  printarray(u+ua,16,u+ua);

  orig_asma(stmp+sa,ttmp+ta,utmp+ua);

  if (memcmp(utmp+ua,u+ua,16)!=0) {
    printf("failed: return value wrong. Expected:\n");
    printarray(utmp+ua,l,utmp+ua);
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

int main(int argc, char **argv)
{
  int success=1;
  int l=16+16;
  int i,j,k;

  unsigned char s[l];
  unsigned char t[l];
  unsigned char u[l];

  for(i=0; i<3;i++)
    for(j=0; j<3;j++)
      for(k=0; k<3;k++)
	success&=test(s,t,u,i,j,k);

  if (!success)
    fprintf(stdout,"\nTest failed.\n");
  else
    fprintf(stdout,"\nTest succeeded.\n");
  return !success;
}
