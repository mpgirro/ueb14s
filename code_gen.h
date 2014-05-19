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
char *asm_op_tvar_num(char *operator, tnode_t *tvarnode, int val);
char *asm_op_tvar_tvar(char *operator, tnode_t *tvarnode1, tnode_t *tvarnode2);
char *asm_op_tvar_var(char *operator, tnode_t *tvarnode, tnode_t *varnode);

char *asm_eval_cmp(char *cop1, char *cop2, char *var);

char *asm_cmpop_reg_num(char *cop1, char *cop2, tnode_t *varnode, int64_t val);
char *asm_cmpop_reg_reg(char *cop1, char *cop2, tnode_t *varnode1, tnode_t *varnode2);
char *asm_cmpop_tvar_num(char *cop1, char *cop2, tnode_t *tvarnode, int val);
char *asm_cmpop_tvar_tvar(char *cop1, char *cop2, tnode_t *tvarnode1, tnode_t *tvarnode2);
char *asm_cmpop_tvar_var(char *cop1, char *cop2, tnode_t *tvarnode, tnode_t *varnode);
	
	
#endif