#ifndef CODEGEN_INCL
#define CODEGEN_INCL


char *new_varname();
char *asm_tmp_var();
char *asm_func_prolog(char *name);
	
char *asm_not_var(tnode_t *varnode);
char *asm_not_tvar(tnode_t *tvarnode);
char *asm_neg_var(tnode_t *varnode);
char *asm_neg_tvar(tnode_t *tvarnode);

char *asm_op_reg_num(char *operator, tnode_t *varnode, int64_t val);
char *asm_op_reg_reg(char *operator, tnode_t *varnode1, tnode_t *varnode2);
char *asm_op_tvar_num(char *operator, tnode_t *tvarnode, int64_t val);
char *asm_op_tvar_tvar(char *operator, tnode_t *tvarnode1, tnode_t *tvarnode2);
char *asm_op_tvar_var(char *operator, tnode_t *tvarnode, tnode_t *varnode);

char *asm_eval_cmp(char *cmp_op, char *var);

char *asm_cmpop_reg_num(char *cmp_op, tnode_t *varnode, int64_t val);
char *asm_cmpop_num_reg(char *cmp_op, int64_t val, tnode_t *varnode);
char *asm_cmpop_reg_reg(char *cmp_op, tnode_t *varnode1, tnode_t *varnode2);
char *asm_cmpop_tvar_num(char *cmp_op, tnode_t *tvarnode, int64_t val);
char *asm_cmpop_num_tvar(char *cmp_op, int64_t val, tnode_t *tvarnode);
char *asm_cmpop_tvar_tvar(char *cmp_op, tnode_t *tvarnode1, tnode_t *tvarnode2);
char *asm_cmpop_tvar_var(char *cmp_op, tnode_t *tvarnode, tnode_t *varnode);
char *asm_cmpop_var_tvar(char *cmp_op, tnode_t *varnode, tnode_t *tvarnode);
	
	
#endif