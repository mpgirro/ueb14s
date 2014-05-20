#ifndef SYNTREE_INCL
#define SYNTREE_INCL

/* === enums === */

typedef enum node_type 
{
	T_NUM = 1,
	T_VAR = 2,
	T_RET = 3,
	T_NOT = 4,
	T_ADD = 5,
	T_MUL = 6,
	T_OR  = 7,
	T_GRE = 8,
	T_NEQ = 9,
	T_NEG = 10
} nodetype_t;

/* === structs === */
	
/* structure of syntax tree nodes 
 * built by ox for iburg  */
typedef struct tree_node
{
	nodetype_t op;
	struct tree_node *left;
	struct tree_node *right;
	struct burm_state *label;
	char *name;
	int64_t val;
	char *reg;
} tnode_t;

typedef tnode_t *treenodeptr;  /* so that burg/iburg understands it */

/* macros for iburg  */
#define NODEPTR_TYPE    	treenodeptr
#define OP_LABEL(p)     	((p)->op)
#define LEFT_CHILD(p)   	((p)->left)
#define RIGHT_CHILD(p)  	((p)->right)
#define STATE_LABEL(p)  	((p)->label)
#define PANIC				printf

/* === function signatures === */

tnode_t *new_node(nodetype_t type, tnode_t *left, tnode_t *right);
tnode_t *new_num(int64_t val);
tnode_t *new_var(char *name, char *reg);
tnode_t *new_op(nodetype_t type, tnode_t *left, tnode_t *right);
tnode_t *new_ret(tnode_t *left);

#endif