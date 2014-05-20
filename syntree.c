#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h> /* for 64 bit int */
#include "syntree.h"

tnode_t *new_node(nodetype_t type, tnode_t *left, tnode_t *right)
{
	tnode_t *node = malloc(sizeof(tnode_t));
	node->op = type;
	node->left = left;
	node->right = right;
	node->val = 0;
	return node;
}
	
tnode_t *new_num(int64_t val)
{
	tnode_t *node = new_node(T_NUM, NULL, NULL);
	node->val = val;
	return node;
}

tnode_t *new_var(char *name, char *reg)
{
	tnode_t *node = new_node(T_VAR, NULL, NULL);
	node->name = name;
	node->reg = reg;
	return node;
}

tnode_t *new_op(nodetype_t type, tnode_t *left, tnode_t *right)
{
	tnode_t *node = new_node(type, left, right);
	return node;
}


tnode_t *new_ret(tnode_t *left)
{
	tnode_t *node = new_node(T_RET, left, NULL);
	return node;
}
