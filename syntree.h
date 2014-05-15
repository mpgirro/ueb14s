#ifndef SYNTREE_INCL
#define SYNTREE_INCL

#ifndef CODE
typedef struct burm_state *STATEPTR_TYPE; 
#endif

/* macros for iburg  */
#define NODEPTR_TYPE    	treenodep
#define OP_LABEL(p)     	((p)->op)
#define LEFT_CHILD(p)   	((p)->kids[0])
#define RIGHT_CHILD(p)  	((p)->kids[1])
#define STATE_LABEL(p)  	((p)->label)
#define PANIC				printf

/* === enums === */

typedef enum node_type 
{
	T_NUM = 1,
	T_VAR = 2,
	T_RET = 3
} nodetype_t;

/* === structs === */
	
typedef struct tree_node
{
	nodetype_t op;
	struct syntree_node *left;
	struct syntree_node *right;
	struct burm_struct *state;
	char *name;
	char *reg;
	int64_t val;
} tnode_t;

typedef tnode_t *tnode_p  /* treenode pointer type */

/* === function signatures === */

tnode_t *new_node(nodetype_t type, tnode_t *left, tnode_t *right);
tnode_t *new_num(int val);
tnode_t *new_var(char *name, char *reg);
tnode_t *new_op(nodetype_t type, tnode_t *left, tnode_t *right);
tnode_t *new_ret(tnode_t *left);
tnode_t *new_prog(tnode_t *left, tnode_t *right);

#endif