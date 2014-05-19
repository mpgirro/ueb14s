#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h> /* for 64 bit int */
#include "code_gen.h"

extern FILE *output; /* this is where the assambler code goes */

char *tmp_regs[] = {"r10", "r11"};
int tmp_count = 0;
char *tmp_var = "tmp";

char *new_varname()
{
	int len = 1;
	int tcount = 0;
	char *var;
	tmp_count += 1;
	tcount = tmp_count;
	while((tcount = tcount / 10 ) > 0)
		len += 1;
	
	char num[len+1];
	sprintf(num, "%d", tmp_count);
	len += 4; /* tmp */
	len += 1; /* \0 terminate */
	var = malloc(sizeof(char)*len);
	strcpy(var, tmp_var);
	strcat(var,num);
	return var;
}

char *asm_tmp_var()
{
	char *var = new_varname();
	(void) fprintf(output, "\t.data\n");
	(void) fprintf(output, "%s:\n",var);
	(void) fprintf(output, "\t.space 8\n");
	(void) fprintf(output, "\t.align 8\n");
	(void) fprintf(output, "\t.text\n");
	return var;
}

char *asm_func_prolog(char *name)
{
	(void) fprintf(output, "\t.globl %s\n",name);
	(void) fprintf(output, "\t.type %s, @function\n",name);
	(void) fprintf(output, "\n%s:\n");
}

char *asm_not_var(tnode_t *varnode)
{
	(void) fprintf(output, "\tnot %%%s\n", varnode->reg);
	return varnode->name;
}

char *asm_not_tvar(tnode_t *tvarnode)
{
	(void) fprintf(output, "\tnot %s\n", tvarnode->reg);
	return tvarnode->name;
}

char *asm_neg_var(tnode_t *varnode)
{
	(void) fprintf(output, "\tneg %%%s\n", varnode->reg);
	return varnode->name;
}

char *asm_neg_tvar(tnode_t *tvarnode)
{
	(void) fprintf(output, "\tneg %s\n", tvarnode->reg);
	return tvarnode->name;
}
/*
char *asm_add_reg_num(tnode_t *varnode, int64_t val)
{
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tmovq %%%s, %s\n", varnode->reg, var);
	(void) fprintf(output, "\taddq $%d, %s\n", val, var);
	return var;
}

char *asm_add_reg_reg(tnode_t *varnode1, tnode_t *varnode2)
{
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tmovq %%%s, %s\n", varnode1->reg, var);
	(void) fprintf(output, "\taddq %%%s, %s\n", varnode2->reg, var);
	return var;
}

char *asm_add_tvar_num(tnode_t *tvarnode, int val)
{
	(void) fprintf(output, "\taddq $%d, %s\n", val, tvarnode->name);
	return tvarnode->name;
}

char *asm_add_tvar_tvar(tnode_t *tvarnode1, tnode_t *tvarnode2)
{
	(void) fprintf(output, "\nmovq %s, %%%s\n", tvarnode1->name, tmp_regs[0]);
	(void) fprintf(output, "\taddq %%%s, %s\n", tmp_regs[0], tvarnode2->name);
	return tvarnode2->name;
}

char *asm_add_tvar_var(tnode_t *tvarnode, tnode_t *varnode)
{
	(void) fprintf(output, "\taddq %%%s, %s\n", varnode->reg, tvarnode->name);
	return tvarnode->name;
}

char *asm_mul_reg_num(tnode_t *varnode, int val)
{
	char *var = asm_temp_variable();
	(void) fprintf(output, "\tpush %%rdx\n");
	(void) fprintf(output, "\tmovq %%%s, %%rax\n", varnode->reg);
	(void) fprintf(output, "\tmovq $%d, %%rdx\n", val);
	(void) fprintf(output, "\tmulq %%rdx\n");
	(void) fprintf(output, "\tmovq %%rax, %s\n", var);
	(void) fprintf(output, "\tpop %%rdx\n");
	return var;
}

char *asm_mul_reg_reg(tnode_t *varnode1, tnode_t *varnode2)
{
	char *var = asm_temp_variable();
	(void) fprintf(output, "\tpush %%rdx\n");
	(void) fprintf(output, "\tmovq %%%s, %%rax\n", varnode1->reg);
	(void) fprintf(output, "\tmulq %%%s\n", varnode2->reg);
	(void) fprintf(output, "\tmovq %%rax, %s\n", var);
	(void) fprintf(output, "\tpop %%rdx\n");
	return var;
}

char *asm_mul_tvar_num(tnode_t *tvarnode, int val)
{
	(void) fprintf(output, "\tpush %%rdx\n");
	(void) fprintf(output, "\tmovq $%d, %%rax\n", val);
	(void) fprintf(output, "\tmulq %s\n", tvarnode->name);
	(void) fprintf(output, "\tmovq %%rax, %s\n", tvarnode->name);
	(void) fprintf(output, "\tpop %%rdx\n");
	return tvarnode->name;
}

char *asm_mul_tvar_tvar(tnode_t *tvarnode1, tnode_t *tvarnode2)
{
	(void) fprintf(output, "\tpush %%rdx\n");
	(void) fprintf(output, "\tmovq %s, %%rax\n", tvarnode1->name);
	(void) fprintf(output, "\tmulq %s\n", tvarnode2->name);
	(void) fprintf(output, "\tmovq %%rax, %s\n", tvarnode2->name);
	(void) fprintf(output, "\tpop %%rdx\n");
	return tvarnode2->name;
}

char *asm_mul_tvar_var(tnode_t *tvarnode, tnode_t *varnode)
{
	(void) fprintf(output, "\tpush %%rdx\n");
	(void) fprintf(output, "\tmovq %s, %%rax\n", tvarnode->name);
	(void) fprintf(output, "\tmulq %%%s\n", varnode->reg);
	(void) fprintf(output, "\tmovq %%rax, %s\n", tvarnode->name);
	(void) fprintf(output, "\tpop %%rdx\n");
	return tvarnode->name;
}
*/

/* ======= these are for "normal" operators (add, mul, etc.) ======= */

char *asm_op_reg_num(char *operator, tnode_t *varnode, int64_t val)
{
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tmovq %%%s, %s\n", varnode->reg, var);
	(void) fprintf(output, "\t%s $%d, %s\n", operator, val, var);
	return var;
}

char *asm_op_reg_reg(char *operator, tnode_t *varnode1, tnode_t *varnode2)
{
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tmovq %%%s, %s\n", varnode1->reg, var);
	(void) fprintf(output, "\t%s %%%s, %s\n", operator, varnode2->reg, var);
	return var;
}

char *asm_op_tvar_num(char *operator, tnode_t *tvarnode, int val)
{
	(void) fprintf(output, "\t%s $%d, %s\n", operator, val, tvarnode->name);
	return tvarnode->name;
}

char *asm_op_tvar_tvar(char *operator, tnode_t *tvarnode1, tnode_t *tvarnode2)
{
	(void) fprintf(output, "\nmovq %s, %%%s\n", tvarnode1->name, tmp_regs[0]);
	(void) fprintf(output, "\t%s %%%s, %s\n", operator, tmp_regs[0], tvarnode2->name);
	return tvarnode2->name;
}

char *asm_op_tvar_var(char *operator, tnode_t *tvarnode, tnode_t *varnode)
{
	(void) fprintf(output, "\t%s %%%s, %s\n", operator, varnode->reg, tvarnode->name);
	return tvarnode->name;
}

/* ======= there are for comparator operators (>, <>) ======= */

char *asm_eval_cmp(char *cop1, char *cop2, char *var)
{
	(void) fprintf(output, "\tcmov%s $-1, %s\n", cop1, var); /* if (greater|not equal) write -1 to return var */
	(void) fprintf(output, "\tcmov%s $0, %s\n", cop2, var); /* else write 0 */
}

char *asm_cmpop_reg_num(char *cop1, char *cop2, tnode_t *varnode, int64_t val)
{
	char *var = asm_tmp_var();
	/* case 1: A>B --> cmp B, A */
	(void) fprintf(output, "\tcmp $%d, %s\n", val, varnode->reg); 
	asm_eval_cmp(cop1, cop2, var);
	//return var;
}
	
char *asm_cmpop_reg_reg(char *cop1, char *cop2, tnode_t *varnode1, tnode_t *varnode2)
{
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tcmp %%%s, %%%s\n", varnode2->reg, varnode1->reg);
	return asm_eval_cmp(cop1, cop2, var);
	return var;
}

char *asm_cmpop_tvar_num(char *cop1, char *cop2, tnode_t *tvarnode, int val)
{
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tcmp $%d, %s\n", val, tvarnode->name);
	return asm_eval_cmp(cop1, cop2, var);
	return var;
}

char *asm_cmpop_tvar_tvar(char *cop1, char *cop2, tnode_t *tvarnode1, tnode_t *tvarnode2)
{
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tcmp %s, %s\n", tvarnode2->name, tvarnode1->name);
	return asm_eval_cmp(cop1, cop2, var);
	return var;
}

char *asm_cmpop_tvar_var(char *cop1, char *cop2, tnode_t *tvarnode, tnode_t *varnode)
{
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tcmp %%%s, %s\n", varnode->reg, tvarnode->name);
	return asm_eval_cmp(cop1, cop2, var);
	return var;
}

/* ========= */

void asm_ret()
{
	(void) fprintf(output, "\tret\n");
}

void asm_ret_reg(tnode_t *varnode)
{
	(void) fprintf(output, "\tmovq %%%s, %%rax\n", varnode->reg);
}

void asm_ret_num(tnode_t *numnode)
{
	(void) fprintf(output, "\tmovq $%d, %%rax\n", numnode->val);
}

void asm_ret_tvar(tnode_t *tvarnode)
{
	(void) fprintf(output, "\tmovq %s, %%rax\n", tvarnode->name);
}