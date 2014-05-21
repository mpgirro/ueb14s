#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h> /* for 64 bit int */
#include "syntree.h"
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
	//(void) fprintf(output, "\n----\nnew generated varname: %s\n-----\n", var);
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
	(void) fprintf(output, "%s:\n",name);
}

char *asm_not_var(tnode_t *varnode)
{
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tmovq %%%s, %%%s\n", varnode->reg, tmp_regs[0]);
	(void) fprintf(output, "\tnotq %%%s\n", tmp_regs[0]);
	(void) fprintf(output, "\tmovq %%%s, %s\n", tmp_regs[0], var);
	return var;
}

char *asm_not_tvar(tnode_t *tvarnode)
{
	(void) fprintf(output, "\tnotq %s\n", tvarnode->name);
	return tvarnode->name;
}

char *asm_neg_var(tnode_t *varnode)
{	
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tmovq %%%s, %%%s\n", varnode->reg, tmp_regs[0]);
	(void) fprintf(output, "\tnegq %%%s\n", tmp_regs[0]);
	(void) fprintf(output, "\tmovq %%%s, %s\n", tmp_regs[0], var);
	return var;
}

char *asm_neg_tvar(tnode_t *tvarnode)
{
	(void) fprintf(output, "\tnegq %s\n", tvarnode->name);
	return tvarnode->name;
}

/* ======= these are for "normal" operators (add, mul, etc.) ======= */

char *asm_op_reg_num(char *operator, tnode_t *varnode, int64_t val)
{
	
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tmovq %%%s, %%%s\n", varnode->reg, tmp_regs[0]);
	(void) fprintf(output, "\t%s $%d, %%%s\n", operator, val, tmp_regs[0]);
	(void) fprintf(output, "\tmovq %%%s, %s\n", tmp_regs[0], var);
	//return varnode->reg;
	return var;
}

char *asm_op_reg_reg(char *operator, tnode_t *varnode1, tnode_t *varnode2)
{
	char *var = asm_tmp_var();
	
	//(void) fprintf(output, "\tmovq %%%s, %s\n", varnode1->reg, var);
	(void) fprintf(output, "\tmovq %%%s, %%%s\n", varnode1->reg, tmp_regs[0]);
	(void) fprintf(output, "\t%s %%%s, %%%s\n", operator, varnode2->reg, tmp_regs[0]);
	(void) fprintf(output, "\tmovq %%%s, %s\n", tmp_regs[0], var);
	/*
	(void) fprintf(output, "\t%s %%%s, %%%s\n", operator, varnode1->reg, varnode2->reg);
	(void) fprintf(output, "\tmovq %%%s, %s\n", varnode2->reg, var);
	*/
	//(void) fprintf(output, "\t%s %%%s, %%%s\n", operator, varnode1->reg, varnode2->reg);
	//return varnode2->reg
	return var;
}

char *asm_op_tvar_num(char *operator, tnode_t *tvarnode, int64_t val)
{
	(void) fprintf(output, "\tmovq %s, %%%s\n", tvarnode->name, tmp_regs[0]);
	(void) fprintf(output, "\t%s $%d, %%%s\n", operator, val, tmp_regs[0]);
	(void) fprintf(output, "\tmovq %%%s, %s\n", tmp_regs[0], tvarnode->name);
	return tvarnode->name;
}

char *asm_op_tvar_tvar(char *operator, tnode_t *tvarnode1, tnode_t *tvarnode2)
{
	/* most operations can't take a memory location as source and dest at the same time */
	(void) fprintf(output, "\tmovq %s, %%%s\n", tvarnode1->name, tmp_regs[0]);
	(void) fprintf(output, "\tmovq %s, %%%s\n", tvarnode2->name, tmp_regs[1]);
	(void) fprintf(output, "\t%s %%%s, %%%s\n", operator, tmp_regs[0], tmp_regs[1]);
	(void) fprintf(output, "\tmovq %%%s, %s\n", tmp_regs[1], tvarnode2->name);
	return tvarnode2->name;
}

char *asm_op_tvar_var(char *operator, tnode_t *tvarnode, tnode_t *varnode)
{
	(void) fprintf(output, "\tmovq %s, %%%s\n", tvarnode->name, tmp_regs[0]);
	(void) fprintf(output, "\t%s %%%s, %%%s\n", operator, varnode->reg, tmp_regs[0]);
	(void) fprintf(output, "\tmovq %%%s, %s\n", tmp_regs[0], tvarnode->name);
	return tvarnode->name;
}

/* ======= there are for comparator operators (>, <>) ======= */

char *asm_eval_cmp(char *cmp_op, char *var)
{
	(void) fprintf(output, "\tmovq $-1, %%%s\n", tmp_regs[0]); 
	(void) fprintf(output, "\tmovq $0, %%%s\n", tmp_regs[1]);
	
	//(void) fprintf(output, "\tcmov%s $-1, %%%s\n", cop1, tmp_regs[0]); /* if (greater|not equal) write -1 to return var */
	(void) fprintf(output, "\tcmov%sq %%%s, %%%s\n", cmp_op, tmp_regs[1], tmp_regs[0]); /* else write 0 */
	(void) fprintf(output, "\tmovq %%%s, %s\n", tmp_regs[0], var);
}

char *asm_cmpop_reg_num(char *cmp_op, tnode_t *varnode, int64_t val)
{
	char *var = asm_tmp_var();
	/* case 1: A>B --> cmp B, A */
	(void) fprintf(output, "\tmovq $%d, %%%s\n", val, tmp_regs[0]); 
	(void) fprintf(output, "\tcmpq %%%s, %%%s\n", tmp_regs[0], varnode->reg); 
	asm_eval_cmp(cmp_op, var);
	return var;
}

char *asm_cmpop_num_reg(char *cmp_op, int64_t val, tnode_t *varnode)
{
	char *var = asm_tmp_var();
	/* case 1: A>B --> cmp B, A */
	(void) fprintf(output, "\tmovq $%d, %%%s\n", val, tmp_regs[0]); 
	(void) fprintf(output, "\tcmpq %%%s, %%%s\n", varnode->reg, tmp_regs[0]); 
	asm_eval_cmp(cmp_op, var);
	return var;
}
	
char *asm_cmpop_reg_reg(char *cmp_op, tnode_t *varnode1, tnode_t *varnode2)
{
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tcmpq %%%s, %%%s\n", varnode2->reg, varnode1->reg);
	asm_eval_cmp(cmp_op, var);
	return var;
}

char *asm_cmpop_tvar_num(char *cmp_op, tnode_t *tvarnode, int64_t val)
{
	//char *var = asm_tmp_var();
	/* most operations can't take a memory location as source and dest */
	(void) fprintf(output, "\nmovq %s, %%%s\n", tvarnode->name, tmp_regs[0]);
	(void) fprintf(output, "\tmovq $%d, %%%s\n", val, tmp_regs[1]);
	(void) fprintf(output, "\tcmpq %%%s, %%%s\n", tmp_regs[1], tmp_regs[0]);
	asm_eval_cmp(cmp_op, tvarnode->name);
	return tvarnode->name;
}

char *asm_cmpop_num_tvar(char *cmp_op, int64_t val, tnode_t *tvarnode)
{
	//char *var = asm_tmp_var();
	/* most operations can't take a memory location as source and dest */
	(void) fprintf(output, "\nmovq %s, %%%s\n", tvarnode->name, tmp_regs[0]);
	(void) fprintf(output, "\nmovq $%d, %%%s\n", val, tmp_regs[1]);
	(void) fprintf(output, "\tcmpq %%%s, $%d\n", tmp_regs[0], tmp_regs[1]);
	asm_eval_cmp(cmp_op, tvarnode->name);
	return tvarnode->name;
}

char *asm_cmpop_tvar_tvar(char *cmp_op, tnode_t *tvarnode1, tnode_t *tvarnode2)
{
	//char *var = asm_tmp_var();
	/* most operations can't take a memory location as source and dest */
	(void) fprintf(output, "\tmovq %s, %%%s\n", tvarnode1->name, tmp_regs[0]);
	(void) fprintf(output, "\tmovq %s, %%%s\n", tvarnode2->name, tmp_regs[1]);
	(void) fprintf(output, "\tcmpq %%%s, %%%s\n", tmp_regs[1], tmp_regs[0]);
	asm_eval_cmp(cmp_op, tvarnode2->name);
	return tvarnode2->name;
}

char *asm_cmpop_tvar_var(char *cmp_op, tnode_t *tvarnode, tnode_t *varnode)
{
	//char *var = asm_tmp_var();
	/* most operations can't take a memory location as source and dest */
	(void) fprintf(output, "\tmovq %s, %%%s\n", tvarnode->name, tmp_regs[0]);
	(void) fprintf(output, "\tcmpq %%%s, %%%s\n", varnode->reg, tmp_regs[0]);
	asm_eval_cmp(cmp_op, tvarnode->name);
	return tvarnode->name;
}

char *asm_cmpop_var_tvar(char *cmp_op, tnode_t *varnode, tnode_t *tvarnode)
{
	//char *var = asm_tmp_var();
	/* most operations can't take a memory location as source and dest */
	(void) fprintf(output, "\tmovq %s, %%%s\n", tvarnode->name, tmp_regs[0]);
	(void) fprintf(output, "\tcmpq %%%s, %%%s\n", tmp_regs[0], varnode->reg);
	asm_eval_cmp(cmp_op, tvarnode->name);
	return tvarnode->name;
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

char *asm_fieldref_var(tnode_t *varnode)
{
	char *var = asm_tmp_var();
	(void) fprintf(output, "\tmovq %i(%%%s), %%%s\n", varnode->offset*8, varnode->reg, tmp_regs[0]);
	(void) fprintf(output, "\tmovq %%%s, %s\n", tmp_regs[0], var);
	return var;
}
char *asm_fieldref_tvar(tnode_t *tvarnode)
{
	(void) fprintf(output, "\tmovq %s, %%%s\n", tvarnode->name, tmp_regs[0]);
	(void) fprintf(output, "\tmovq %i(%%%s), %s\n", tvarnode->offset*8, tmp_regs[0], tvarnode->name);
	return tvarnode->name;
}