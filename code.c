typedef struct burm_state *STATEPTR_TYPE;

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "symtab.h"
#include "syntree.h"

#ifndef ALLOC
#define ALLOC(n) malloc(n)
#endif

#ifndef burm_assert
#define burm_assert(x,y) if (!(x)) { extern void abort(void); y; abort(); }
#endif

#define burm_stmt_NT 1
#define burm_num_NT 2
#define burm_var_NT 3
#define burm_tvar_NT 4
#define burm_T_TVAR_NT 5
#define burm_notvar_NT 6
#define burm_nottvar_NT 7
#define burm_negvar_NT 8
#define burm_negtvar_NT 9
#define burm_addvar_NT 10
#define burm_addtvar_NT 11
#define burm_mulvar_NT 12
#define burm_multvar_NT 13
#define burm_orvar_NT 14
#define burm_ortvar_NT 15
#define burm_grevar_NT 16
#define burm_gretvar_NT 17
#define burm_neqvar_NT 18
#define burm_neqtvar_NT 19
#define burm_ret_NT 20
int burm_max_nt = 20;

struct burm_state {
	int op;
	STATEPTR_TYPE left, right;
	short cost[21];
	struct {
		unsigned burm_stmt:1;
		unsigned burm_num:3;
		unsigned burm_var:1;
		unsigned burm_tvar:4;
		unsigned burm_T_TVAR:1;
		unsigned burm_notvar:1;
		unsigned burm_nottvar:1;
		unsigned burm_negvar:1;
		unsigned burm_negtvar:1;
		unsigned burm_addvar:2;
		unsigned burm_addtvar:3;
		unsigned burm_mulvar:2;
		unsigned burm_multvar:3;
		unsigned burm_orvar:2;
		unsigned burm_ortvar:3;
		unsigned burm_grevar:2;
		unsigned burm_gretvar:3;
		unsigned burm_neqvar:2;
		unsigned burm_neqtvar:3;
		unsigned burm_ret:2;
	} rule;
};

static short burm_nts_0[] = { 0 };
static short burm_nts_1[] = { burm_T_TVAR_NT, 0 };
static short burm_nts_2[] = { burm_num_NT, burm_num_NT, 0 };
static short burm_nts_3[] = { burm_num_NT, 0 };
static short burm_nts_4[] = { burm_notvar_NT, 0 };
static short burm_nts_5[] = { burm_nottvar_NT, 0 };
static short burm_nts_6[] = { burm_negvar_NT, 0 };
static short burm_nts_7[] = { burm_negtvar_NT, 0 };
static short burm_nts_8[] = { burm_addvar_NT, 0 };
static short burm_nts_9[] = { burm_addtvar_NT, 0 };
static short burm_nts_10[] = { burm_mulvar_NT, 0 };
static short burm_nts_11[] = { burm_multvar_NT, 0 };
static short burm_nts_12[] = { burm_orvar_NT, 0 };
static short burm_nts_13[] = { burm_ortvar_NT, 0 };
static short burm_nts_14[] = { burm_grevar_NT, 0 };
static short burm_nts_15[] = { burm_gretvar_NT, 0 };
static short burm_nts_16[] = { burm_neqvar_NT, 0 };
static short burm_nts_17[] = { burm_neqtvar_NT, 0 };
static short burm_nts_18[] = { burm_var_NT, 0 };
static short burm_nts_19[] = { burm_tvar_NT, 0 };
static short burm_nts_20[] = { burm_var_NT, burm_num_NT, 0 };
static short burm_nts_21[] = { burm_num_NT, burm_var_NT, 0 };
static short burm_nts_22[] = { burm_var_NT, burm_var_NT, 0 };
static short burm_nts_23[] = { burm_tvar_NT, burm_num_NT, 0 };
static short burm_nts_24[] = { burm_num_NT, burm_tvar_NT, 0 };
static short burm_nts_25[] = { burm_tvar_NT, burm_tvar_NT, 0 };
static short burm_nts_26[] = { burm_tvar_NT, burm_var_NT, 0 };
static short burm_nts_27[] = { burm_var_NT, burm_tvar_NT, 0 };
static short burm_nts_28[] = { burm_ret_NT, 0 };

short *burm_nts[] = {
	0,	/* 0 */
	burm_nts_0,	/* 1 */
	burm_nts_0,	/* 2 */
	burm_nts_1,	/* 3 */
	burm_nts_2,	/* 4 */
	burm_nts_3,	/* 5 */
	burm_nts_3,	/* 6 */
	burm_nts_2,	/* 7 */
	burm_nts_4,	/* 8 */
	burm_nts_5,	/* 9 */
	burm_nts_6,	/* 10 */
	burm_nts_7,	/* 11 */
	burm_nts_8,	/* 12 */
	burm_nts_9,	/* 13 */
	burm_nts_10,	/* 14 */
	burm_nts_11,	/* 15 */
	burm_nts_12,	/* 16 */
	burm_nts_13,	/* 17 */
	burm_nts_14,	/* 18 */
	burm_nts_15,	/* 19 */
	burm_nts_16,	/* 20 */
	burm_nts_17,	/* 21 */
	burm_nts_18,	/* 22 */
	burm_nts_19,	/* 23 */
	burm_nts_18,	/* 24 */
	burm_nts_18,	/* 25 */
	burm_nts_20,	/* 26 */
	burm_nts_21,	/* 27 */
	burm_nts_22,	/* 28 */
	burm_nts_23,	/* 29 */
	burm_nts_24,	/* 30 */
	burm_nts_25,	/* 31 */
	burm_nts_26,	/* 32 */
	burm_nts_27,	/* 33 */
	burm_nts_20,	/* 34 */
	burm_nts_21,	/* 35 */
	burm_nts_22,	/* 36 */
	burm_nts_23,	/* 37 */
	burm_nts_24,	/* 38 */
	burm_nts_25,	/* 39 */
	burm_nts_26,	/* 40 */
	burm_nts_27,	/* 41 */
	burm_nts_20,	/* 42 */
	burm_nts_21,	/* 43 */
	burm_nts_22,	/* 44 */
	burm_nts_23,	/* 45 */
	burm_nts_24,	/* 46 */
	burm_nts_25,	/* 47 */
	burm_nts_26,	/* 48 */
	burm_nts_27,	/* 49 */
	burm_nts_20,	/* 50 */
	burm_nts_21,	/* 51 */
	burm_nts_22,	/* 52 */
	burm_nts_23,	/* 53 */
	burm_nts_24,	/* 54 */
	burm_nts_25,	/* 55 */
	burm_nts_26,	/* 56 */
	burm_nts_27,	/* 57 */
	burm_nts_20,	/* 58 */
	burm_nts_21,	/* 59 */
	burm_nts_22,	/* 60 */
	burm_nts_23,	/* 61 */
	burm_nts_24,	/* 62 */
	burm_nts_25,	/* 63 */
	burm_nts_26,	/* 64 */
	burm_nts_27,	/* 65 */
	burm_nts_3,	/* 66 */
	burm_nts_18,	/* 67 */
	burm_nts_19,	/* 68 */
	burm_nts_28,	/* 69 */
};

char burm_arity[] = {
	0,	/* 0 */
	0,	/* 1=T_NUM */
	0,	/* 2=T_VAR */
	1,	/* 3=T_RET */
	1,	/* 4=T_NOT */
	2,	/* 5=T_ADD */
	2,	/* 6=T_MUL */
	2,	/* 7=T_OR */
	2,	/* 8=T_GRE */
	2,	/* 9=T_NEQ */
	1,	/* 10=T_NEG */
};

static short burm_decode_stmt[] = {
	0,
	69,
};

static short burm_decode_num[] = {
	0,
	1,
	4,
	5,
	6,
	7,
};

static short burm_decode_var[] = {
	0,
	2,
};

static short burm_decode_tvar[] = {
	0,
	3,
	8,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20,
	21,
};

static short burm_decode_T_TVAR[] = {
	0,
};

static short burm_decode_notvar[] = {
	0,
	22,
};

static short burm_decode_nottvar[] = {
	0,
	23,
};

static short burm_decode_negvar[] = {
	0,
	24,
};

static short burm_decode_negtvar[] = {
	0,
	25,
};

static short burm_decode_addvar[] = {
	0,
	26,
	27,
	28,
};

static short burm_decode_addtvar[] = {
	0,
	29,
	30,
	31,
	32,
	33,
};

static short burm_decode_mulvar[] = {
	0,
	34,
	35,
	36,
};

static short burm_decode_multvar[] = {
	0,
	37,
	38,
	39,
	40,
	41,
};

static short burm_decode_orvar[] = {
	0,
	42,
	43,
	44,
};

static short burm_decode_ortvar[] = {
	0,
	45,
	46,
	47,
	48,
	49,
};

static short burm_decode_grevar[] = {
	0,
	50,
	51,
	52,
};

static short burm_decode_gretvar[] = {
	0,
	53,
	54,
	55,
	56,
	57,
};

static short burm_decode_neqvar[] = {
	0,
	58,
	59,
	60,
};

static short burm_decode_neqtvar[] = {
	0,
	61,
	62,
	63,
	64,
	65,
};

static short burm_decode_ret[] = {
	0,
	66,
	67,
	68,
};

int burm_rule(STATEPTR_TYPE state, int goalnt) {
	burm_assert(goalnt >= 1 && goalnt <= 20, PANIC("Bad goal nonterminal %d in burm_rule\n", goalnt));
	if (!state)
		return 0;
	switch (goalnt) {
	case burm_stmt_NT:
		return burm_decode_stmt[state->rule.burm_stmt];
	case burm_num_NT:
		return burm_decode_num[state->rule.burm_num];
	case burm_var_NT:
		return burm_decode_var[state->rule.burm_var];
	case burm_tvar_NT:
		return burm_decode_tvar[state->rule.burm_tvar];
	case burm_T_TVAR_NT:
		return burm_decode_T_TVAR[state->rule.burm_T_TVAR];
	case burm_notvar_NT:
		return burm_decode_notvar[state->rule.burm_notvar];
	case burm_nottvar_NT:
		return burm_decode_nottvar[state->rule.burm_nottvar];
	case burm_negvar_NT:
		return burm_decode_negvar[state->rule.burm_negvar];
	case burm_negtvar_NT:
		return burm_decode_negtvar[state->rule.burm_negtvar];
	case burm_addvar_NT:
		return burm_decode_addvar[state->rule.burm_addvar];
	case burm_addtvar_NT:
		return burm_decode_addtvar[state->rule.burm_addtvar];
	case burm_mulvar_NT:
		return burm_decode_mulvar[state->rule.burm_mulvar];
	case burm_multvar_NT:
		return burm_decode_multvar[state->rule.burm_multvar];
	case burm_orvar_NT:
		return burm_decode_orvar[state->rule.burm_orvar];
	case burm_ortvar_NT:
		return burm_decode_ortvar[state->rule.burm_ortvar];
	case burm_grevar_NT:
		return burm_decode_grevar[state->rule.burm_grevar];
	case burm_gretvar_NT:
		return burm_decode_gretvar[state->rule.burm_gretvar];
	case burm_neqvar_NT:
		return burm_decode_neqvar[state->rule.burm_neqvar];
	case burm_neqtvar_NT:
		return burm_decode_neqtvar[state->rule.burm_neqtvar];
	case burm_ret_NT:
		return burm_decode_ret[state->rule.burm_ret];
	default:
		burm_assert(0, PANIC("Bad goal nonterminal %d in burm_rule\n", goalnt));
	}
	return 0;
}

static void burm_closure_T_TVAR(STATEPTR_TYPE, int);
static void burm_closure_notvar(STATEPTR_TYPE, int);
static void burm_closure_nottvar(STATEPTR_TYPE, int);
static void burm_closure_negvar(STATEPTR_TYPE, int);
static void burm_closure_negtvar(STATEPTR_TYPE, int);
static void burm_closure_addvar(STATEPTR_TYPE, int);
static void burm_closure_addtvar(STATEPTR_TYPE, int);
static void burm_closure_mulvar(STATEPTR_TYPE, int);
static void burm_closure_multvar(STATEPTR_TYPE, int);
static void burm_closure_orvar(STATEPTR_TYPE, int);
static void burm_closure_ortvar(STATEPTR_TYPE, int);
static void burm_closure_grevar(STATEPTR_TYPE, int);
static void burm_closure_gretvar(STATEPTR_TYPE, int);
static void burm_closure_neqvar(STATEPTR_TYPE, int);
static void burm_closure_neqtvar(STATEPTR_TYPE, int);
static void burm_closure_ret(STATEPTR_TYPE, int);

static void burm_closure_T_TVAR(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 1;
	}
}

static void burm_closure_notvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 2;
	}
}

static void burm_closure_nottvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 3;
	}
}

static void burm_closure_negvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 4;
	}
}

static void burm_closure_negtvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 5;
	}
}

static void burm_closure_addvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 6;
	}
}

static void burm_closure_addtvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 7;
	}
}

static void burm_closure_mulvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 8;
	}
}

static void burm_closure_multvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 9;
	}
}

static void burm_closure_orvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 10;
	}
}

static void burm_closure_ortvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 11;
	}
}

static void burm_closure_grevar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 12;
	}
}

static void burm_closure_gretvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 13;
	}
}

static void burm_closure_neqvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 14;
	}
}

static void burm_closure_neqtvar(STATEPTR_TYPE p, int c) {
	if (c + 0 < p->cost[burm_tvar_NT]) {
		p->cost[burm_tvar_NT] = c + 0;
		p->rule.burm_tvar = 15;
	}
}

static void burm_closure_ret(STATEPTR_TYPE p, int c) {
	if (c + 1 < p->cost[burm_stmt_NT]) {
		p->cost[burm_stmt_NT] = c + 1;
		p->rule.burm_stmt = 1;
	}
}

STATEPTR_TYPE burm_state(int op, STATEPTR_TYPE left, STATEPTR_TYPE right) {
	int c;
	STATEPTR_TYPE p, l = left, r = right;

	if (burm_arity[op] > 0) {
		p = (STATEPTR_TYPE)ALLOC(sizeof *p);
		burm_assert(p, PANIC("ALLOC returned NULL in burm_state\n"));
		p->op = op;
		p->left = l;
		p->right = r;
		p->rule.burm_stmt = 0;
		p->cost[1] =
		p->cost[2] =
		p->cost[3] =
		p->cost[4] =
		p->cost[5] =
		p->cost[6] =
		p->cost[7] =
		p->cost[8] =
		p->cost[9] =
		p->cost[10] =
		p->cost[11] =
		p->cost[12] =
		p->cost[13] =
		p->cost[14] =
		p->cost[15] =
		p->cost[16] =
		p->cost[17] =
		p->cost[18] =
		p->cost[19] =
		p->cost[20] =
			32767;
	}
	switch (op) {
	case 1: /* T_NUM */
		{
			static struct burm_state z = { 1, 0, 0,
				{	0,
					32767,
					0,	/* num: T_NUM */
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
				},{
					0,
					1,	/* num: T_NUM */
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
				}
			};
			return &z;
		}
	case 2: /* T_VAR */
		{
			static struct burm_state z = { 2, 0, 0,
				{	0,
					32767,
					32767,
					0,	/* var: T_VAR */
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
					32767,
				},{
					0,
					0,
					1,	/* var: T_VAR */
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
				}
			};
			return &z;
		}
	case 3: /* T_RET */
		assert(l);
		{	/* ret: T_RET(tvar) */
			c = l->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_ret_NT]) {
				p->cost[burm_ret_NT] = c + 0;
				p->rule.burm_ret = 3;
				burm_closure_ret(p, c + 0);
			}
		}
		{	/* ret: T_RET(var) */
			c = l->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_ret_NT]) {
				p->cost[burm_ret_NT] = c + 0;
				p->rule.burm_ret = 2;
				burm_closure_ret(p, c + 0);
			}
		}
		{	/* ret: T_RET(num) */
			c = l->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_ret_NT]) {
				p->cost[burm_ret_NT] = c + 0;
				p->rule.burm_ret = 1;
				burm_closure_ret(p, c + 0);
			}
		}
		break;
	case 4: /* T_NOT */
		assert(l);
		{	/* nottvar: T_NOT(tvar) */
			c = l->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_nottvar_NT]) {
				p->cost[burm_nottvar_NT] = c + 0;
				p->rule.burm_nottvar = 1;
				burm_closure_nottvar(p, c + 0);
			}
		}
		{	/* notvar: T_NOT(var) */
			c = l->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_notvar_NT]) {
				p->cost[burm_notvar_NT] = c + 0;
				p->rule.burm_notvar = 1;
				burm_closure_notvar(p, c + 0);
			}
		}
		{	/* num: T_NOT(num) */
			c = l->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_num_NT]) {
				p->cost[burm_num_NT] = c + 0;
				p->rule.burm_num = 3;
			}
		}
		break;
	case 5: /* T_ADD */
		assert(l && r);
		{	/* addtvar: T_ADD(var,tvar) */
			c = l->cost[burm_var_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_addtvar_NT]) {
				p->cost[burm_addtvar_NT] = c + 0;
				p->rule.burm_addtvar = 5;
				burm_closure_addtvar(p, c + 0);
			}
		}
		{	/* addtvar: T_ADD(tvar,var) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_addtvar_NT]) {
				p->cost[burm_addtvar_NT] = c + 0;
				p->rule.burm_addtvar = 4;
				burm_closure_addtvar(p, c + 0);
			}
		}
		{	/* addtvar: T_ADD(tvar,tvar) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_addtvar_NT]) {
				p->cost[burm_addtvar_NT] = c + 0;
				p->rule.burm_addtvar = 3;
				burm_closure_addtvar(p, c + 0);
			}
		}
		{	/* addtvar: T_ADD(num,tvar) */
			c = l->cost[burm_num_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_addtvar_NT]) {
				p->cost[burm_addtvar_NT] = c + 0;
				p->rule.burm_addtvar = 2;
				burm_closure_addtvar(p, c + 0);
			}
		}
		{	/* addtvar: T_ADD(tvar,num) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_addtvar_NT]) {
				p->cost[burm_addtvar_NT] = c + 0;
				p->rule.burm_addtvar = 1;
				burm_closure_addtvar(p, c + 0);
			}
		}
		{	/* addvar: T_ADD(var,var) */
			c = l->cost[burm_var_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_addvar_NT]) {
				p->cost[burm_addvar_NT] = c + 0;
				p->rule.burm_addvar = 3;
				burm_closure_addvar(p, c + 0);
			}
		}
		{	/* addvar: T_ADD(num,var) */
			c = l->cost[burm_num_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_addvar_NT]) {
				p->cost[burm_addvar_NT] = c + 0;
				p->rule.burm_addvar = 2;
				burm_closure_addvar(p, c + 0);
			}
		}
		{	/* addvar: T_ADD(var,num) */
			c = l->cost[burm_var_NT] + r->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_addvar_NT]) {
				p->cost[burm_addvar_NT] = c + 0;
				p->rule.burm_addvar = 1;
				burm_closure_addvar(p, c + 0);
			}
		}
		{	/* num: T_ADD(num,num) */
			c = l->cost[burm_num_NT] + r->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_num_NT]) {
				p->cost[burm_num_NT] = c + 0;
				p->rule.burm_num = 2;
			}
		}
		break;
	case 6: /* T_MUL */
		assert(l && r);
		{	/* multvar: T_MUL(var,tvar) */
			c = l->cost[burm_var_NT] + r->cost[burm_tvar_NT] + 4;
			if (c + 0 < p->cost[burm_multvar_NT]) {
				p->cost[burm_multvar_NT] = c + 0;
				p->rule.burm_multvar = 5;
				burm_closure_multvar(p, c + 0);
			}
		}
		{	/* multvar: T_MUL(tvar,var) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_var_NT] + 4;
			if (c + 0 < p->cost[burm_multvar_NT]) {
				p->cost[burm_multvar_NT] = c + 0;
				p->rule.burm_multvar = 4;
				burm_closure_multvar(p, c + 0);
			}
		}
		{	/* multvar: T_MUL(tvar,tvar) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_tvar_NT] + 4;
			if (c + 0 < p->cost[burm_multvar_NT]) {
				p->cost[burm_multvar_NT] = c + 0;
				p->rule.burm_multvar = 3;
				burm_closure_multvar(p, c + 0);
			}
		}
		{	/* multvar: T_MUL(num,tvar) */
			c = l->cost[burm_num_NT] + r->cost[burm_tvar_NT] + 4;
			if (c + 0 < p->cost[burm_multvar_NT]) {
				p->cost[burm_multvar_NT] = c + 0;
				p->rule.burm_multvar = 2;
				burm_closure_multvar(p, c + 0);
			}
		}
		{	/* multvar: T_MUL(tvar,num) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_num_NT] + 4;
			if (c + 0 < p->cost[burm_multvar_NT]) {
				p->cost[burm_multvar_NT] = c + 0;
				p->rule.burm_multvar = 1;
				burm_closure_multvar(p, c + 0);
			}
		}
		{	/* mulvar: T_MUL(var,var) */
			c = l->cost[burm_var_NT] + r->cost[burm_var_NT] + 4;
			if (c + 0 < p->cost[burm_mulvar_NT]) {
				p->cost[burm_mulvar_NT] = c + 0;
				p->rule.burm_mulvar = 3;
				burm_closure_mulvar(p, c + 0);
			}
		}
		{	/* mulvar: T_MUL(num,var) */
			c = l->cost[burm_num_NT] + r->cost[burm_var_NT] + 4;
			if (c + 0 < p->cost[burm_mulvar_NT]) {
				p->cost[burm_mulvar_NT] = c + 0;
				p->rule.burm_mulvar = 2;
				burm_closure_mulvar(p, c + 0);
			}
		}
		{	/* mulvar: T_MUL(var,num) */
			c = l->cost[burm_var_NT] + r->cost[burm_num_NT] + 4;
			if (c + 0 < p->cost[burm_mulvar_NT]) {
				p->cost[burm_mulvar_NT] = c + 0;
				p->rule.burm_mulvar = 1;
				burm_closure_mulvar(p, c + 0);
			}
		}
		{	/* num: T_MUL(num,num) */
			c = l->cost[burm_num_NT] + r->cost[burm_num_NT] + 4;
			if (c + 0 < p->cost[burm_num_NT]) {
				p->cost[burm_num_NT] = c + 0;
				p->rule.burm_num = 5;
			}
		}
		break;
	case 7: /* T_OR */
		assert(l && r);
		{	/* ortvar: T_OR(var,tvar) */
			c = l->cost[burm_var_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_ortvar_NT]) {
				p->cost[burm_ortvar_NT] = c + 0;
				p->rule.burm_ortvar = 5;
				burm_closure_ortvar(p, c + 0);
			}
		}
		{	/* ortvar: T_OR(tvar,var) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_ortvar_NT]) {
				p->cost[burm_ortvar_NT] = c + 0;
				p->rule.burm_ortvar = 4;
				burm_closure_ortvar(p, c + 0);
			}
		}
		{	/* ortvar: T_OR(tvar,tvar) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_ortvar_NT]) {
				p->cost[burm_ortvar_NT] = c + 0;
				p->rule.burm_ortvar = 3;
				burm_closure_ortvar(p, c + 0);
			}
		}
		{	/* ortvar: T_OR(num,tvar) */
			c = l->cost[burm_num_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_ortvar_NT]) {
				p->cost[burm_ortvar_NT] = c + 0;
				p->rule.burm_ortvar = 2;
				burm_closure_ortvar(p, c + 0);
			}
		}
		{	/* ortvar: T_OR(tvar,num) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_ortvar_NT]) {
				p->cost[burm_ortvar_NT] = c + 0;
				p->rule.burm_ortvar = 1;
				burm_closure_ortvar(p, c + 0);
			}
		}
		{	/* orvar: T_OR(var,var) */
			c = l->cost[burm_var_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_orvar_NT]) {
				p->cost[burm_orvar_NT] = c + 0;
				p->rule.burm_orvar = 3;
				burm_closure_orvar(p, c + 0);
			}
		}
		{	/* orvar: T_OR(num,var) */
			c = l->cost[burm_num_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_orvar_NT]) {
				p->cost[burm_orvar_NT] = c + 0;
				p->rule.burm_orvar = 2;
				burm_closure_orvar(p, c + 0);
			}
		}
		{	/* orvar: T_OR(var,num) */
			c = l->cost[burm_var_NT] + r->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_orvar_NT]) {
				p->cost[burm_orvar_NT] = c + 0;
				p->rule.burm_orvar = 1;
				burm_closure_orvar(p, c + 0);
			}
		}
		break;
	case 8: /* T_GRE */
		assert(l && r);
		{	/* gretvar: T_GRE(var,tvar) */
			c = l->cost[burm_var_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_gretvar_NT]) {
				p->cost[burm_gretvar_NT] = c + 0;
				p->rule.burm_gretvar = 5;
				burm_closure_gretvar(p, c + 0);
			}
		}
		{	/* gretvar: T_GRE(tvar,var) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_gretvar_NT]) {
				p->cost[burm_gretvar_NT] = c + 0;
				p->rule.burm_gretvar = 4;
				burm_closure_gretvar(p, c + 0);
			}
		}
		{	/* gretvar: T_GRE(tvar,tvar) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_gretvar_NT]) {
				p->cost[burm_gretvar_NT] = c + 0;
				p->rule.burm_gretvar = 3;
				burm_closure_gretvar(p, c + 0);
			}
		}
		{	/* gretvar: T_GRE(num,tvar) */
			c = l->cost[burm_num_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_gretvar_NT]) {
				p->cost[burm_gretvar_NT] = c + 0;
				p->rule.burm_gretvar = 2;
				burm_closure_gretvar(p, c + 0);
			}
		}
		{	/* gretvar: T_GRE(tvar,num) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_gretvar_NT]) {
				p->cost[burm_gretvar_NT] = c + 0;
				p->rule.burm_gretvar = 1;
				burm_closure_gretvar(p, c + 0);
			}
		}
		{	/* grevar: T_GRE(var,var) */
			c = l->cost[burm_var_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_grevar_NT]) {
				p->cost[burm_grevar_NT] = c + 0;
				p->rule.burm_grevar = 3;
				burm_closure_grevar(p, c + 0);
			}
		}
		{	/* grevar: T_GRE(num,var) */
			c = l->cost[burm_num_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_grevar_NT]) {
				p->cost[burm_grevar_NT] = c + 0;
				p->rule.burm_grevar = 2;
				burm_closure_grevar(p, c + 0);
			}
		}
		{	/* grevar: T_GRE(var,num) */
			c = l->cost[burm_var_NT] + r->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_grevar_NT]) {
				p->cost[burm_grevar_NT] = c + 0;
				p->rule.burm_grevar = 1;
				burm_closure_grevar(p, c + 0);
			}
		}
		break;
	case 9: /* T_NEQ */
		assert(l && r);
		{	/* neqtvar: T_NEQ(var,tvar) */
			c = l->cost[burm_var_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_neqtvar_NT]) {
				p->cost[burm_neqtvar_NT] = c + 0;
				p->rule.burm_neqtvar = 5;
				burm_closure_neqtvar(p, c + 0);
			}
		}
		{	/* neqtvar: T_NEQ(tvar,var) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_neqtvar_NT]) {
				p->cost[burm_neqtvar_NT] = c + 0;
				p->rule.burm_neqtvar = 4;
				burm_closure_neqtvar(p, c + 0);
			}
		}
		{	/* neqtvar: T_NEQ(tvar,tvar) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_neqtvar_NT]) {
				p->cost[burm_neqtvar_NT] = c + 0;
				p->rule.burm_neqtvar = 3;
				burm_closure_neqtvar(p, c + 0);
			}
		}
		{	/* neqtvar: T_NEQ(num,tvar) */
			c = l->cost[burm_num_NT] + r->cost[burm_tvar_NT] + 1;
			if (c + 0 < p->cost[burm_neqtvar_NT]) {
				p->cost[burm_neqtvar_NT] = c + 0;
				p->rule.burm_neqtvar = 2;
				burm_closure_neqtvar(p, c + 0);
			}
		}
		{	/* neqtvar: T_NEQ(tvar,num) */
			c = l->cost[burm_tvar_NT] + r->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_neqtvar_NT]) {
				p->cost[burm_neqtvar_NT] = c + 0;
				p->rule.burm_neqtvar = 1;
				burm_closure_neqtvar(p, c + 0);
			}
		}
		{	/* neqvar: T_NEQ(var,var) */
			c = l->cost[burm_var_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_neqvar_NT]) {
				p->cost[burm_neqvar_NT] = c + 0;
				p->rule.burm_neqvar = 3;
				burm_closure_neqvar(p, c + 0);
			}
		}
		{	/* neqvar: T_NEQ(num,var) */
			c = l->cost[burm_num_NT] + r->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_neqvar_NT]) {
				p->cost[burm_neqvar_NT] = c + 0;
				p->rule.burm_neqvar = 2;
				burm_closure_neqvar(p, c + 0);
			}
		}
		{	/* neqvar: T_NEQ(var,num) */
			c = l->cost[burm_var_NT] + r->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_neqvar_NT]) {
				p->cost[burm_neqvar_NT] = c + 0;
				p->rule.burm_neqvar = 1;
				burm_closure_neqvar(p, c + 0);
			}
		}
		break;
	case 10: /* T_NEG */
		assert(l);
		{	/* negtvar: T_NEG(var) */
			c = l->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_negtvar_NT]) {
				p->cost[burm_negtvar_NT] = c + 0;
				p->rule.burm_negtvar = 1;
				burm_closure_negtvar(p, c + 0);
			}
		}
		{	/* negvar: T_NEG(var) */
			c = l->cost[burm_var_NT] + 1;
			if (c + 0 < p->cost[burm_negvar_NT]) {
				p->cost[burm_negvar_NT] = c + 0;
				p->rule.burm_negvar = 1;
				burm_closure_negvar(p, c + 0);
			}
		}
		{	/* num: T_NEG(num) */
			c = l->cost[burm_num_NT] + 1;
			if (c + 0 < p->cost[burm_num_NT]) {
				p->cost[burm_num_NT] = c + 0;
				p->rule.burm_num = 4;
			}
		}
		break;
	default:
		burm_assert(0, PANIC("Bad operator %d in burm_state\n", op));
	}
	return p;
}

#ifdef STATE_LABEL
static void burm_label1(NODEPTR_TYPE p) {
	burm_assert(p, PANIC("NULL tree in burm_label\n"));
	switch (burm_arity[OP_LABEL(p)]) {
	case 0:
		STATE_LABEL(p) = burm_state(OP_LABEL(p), 0, 0);
		break;
	case 1:
		burm_label1(LEFT_CHILD(p));
		STATE_LABEL(p) = burm_state(OP_LABEL(p),
			STATE_LABEL(LEFT_CHILD(p)), 0);
		break;
	case 2:
		burm_label1(LEFT_CHILD(p));
		burm_label1(RIGHT_CHILD(p));
		STATE_LABEL(p) = burm_state(OP_LABEL(p),
			STATE_LABEL(LEFT_CHILD(p)),
			STATE_LABEL(RIGHT_CHILD(p)));
		break;
	}
}

STATEPTR_TYPE burm_label(NODEPTR_TYPE p) {
	burm_label1(p);
	return STATE_LABEL(p)->rule.burm_stmt ? STATE_LABEL(p) : 0;
}

NODEPTR_TYPE *burm_kids(NODEPTR_TYPE p, int eruleno, NODEPTR_TYPE kids[]) {
	burm_assert(p, PANIC("NULL tree in burm_kids\n"));
	burm_assert(kids, PANIC("NULL kids in burm_kids\n"));
	switch (eruleno) {
	case 2: /* var: T_VAR */
	case 1: /* num: T_NUM */
		break;
	case 69: /* stmt: ret */
	case 21: /* tvar: neqtvar */
	case 20: /* tvar: neqvar */
	case 19: /* tvar: gretvar */
	case 18: /* tvar: grevar */
	case 17: /* tvar: ortvar */
	case 16: /* tvar: orvar */
	case 15: /* tvar: multvar */
	case 14: /* tvar: mulvar */
	case 13: /* tvar: addtvar */
	case 12: /* tvar: addvar */
	case 11: /* tvar: negtvar */
	case 10: /* tvar: negvar */
	case 9: /* tvar: nottvar */
	case 8: /* tvar: notvar */
	case 3: /* tvar: T_TVAR */
		kids[0] = p;
		break;
	case 65: /* neqtvar: T_NEQ(var,tvar) */
	case 64: /* neqtvar: T_NEQ(tvar,var) */
	case 63: /* neqtvar: T_NEQ(tvar,tvar) */
	case 62: /* neqtvar: T_NEQ(num,tvar) */
	case 61: /* neqtvar: T_NEQ(tvar,num) */
	case 60: /* neqvar: T_NEQ(var,var) */
	case 59: /* neqvar: T_NEQ(num,var) */
	case 58: /* neqvar: T_NEQ(var,num) */
	case 57: /* gretvar: T_GRE(var,tvar) */
	case 56: /* gretvar: T_GRE(tvar,var) */
	case 55: /* gretvar: T_GRE(tvar,tvar) */
	case 54: /* gretvar: T_GRE(num,tvar) */
	case 53: /* gretvar: T_GRE(tvar,num) */
	case 52: /* grevar: T_GRE(var,var) */
	case 51: /* grevar: T_GRE(num,var) */
	case 50: /* grevar: T_GRE(var,num) */
	case 49: /* ortvar: T_OR(var,tvar) */
	case 48: /* ortvar: T_OR(tvar,var) */
	case 47: /* ortvar: T_OR(tvar,tvar) */
	case 46: /* ortvar: T_OR(num,tvar) */
	case 45: /* ortvar: T_OR(tvar,num) */
	case 44: /* orvar: T_OR(var,var) */
	case 43: /* orvar: T_OR(num,var) */
	case 42: /* orvar: T_OR(var,num) */
	case 41: /* multvar: T_MUL(var,tvar) */
	case 40: /* multvar: T_MUL(tvar,var) */
	case 39: /* multvar: T_MUL(tvar,tvar) */
	case 38: /* multvar: T_MUL(num,tvar) */
	case 37: /* multvar: T_MUL(tvar,num) */
	case 36: /* mulvar: T_MUL(var,var) */
	case 35: /* mulvar: T_MUL(num,var) */
	case 34: /* mulvar: T_MUL(var,num) */
	case 33: /* addtvar: T_ADD(var,tvar) */
	case 32: /* addtvar: T_ADD(tvar,var) */
	case 31: /* addtvar: T_ADD(tvar,tvar) */
	case 30: /* addtvar: T_ADD(num,tvar) */
	case 29: /* addtvar: T_ADD(tvar,num) */
	case 28: /* addvar: T_ADD(var,var) */
	case 27: /* addvar: T_ADD(num,var) */
	case 26: /* addvar: T_ADD(var,num) */
	case 7: /* num: T_MUL(num,num) */
	case 4: /* num: T_ADD(num,num) */
		kids[0] = LEFT_CHILD(p);
		kids[1] = RIGHT_CHILD(p);
		break;
	case 68: /* ret: T_RET(tvar) */
	case 67: /* ret: T_RET(var) */
	case 66: /* ret: T_RET(num) */
	case 25: /* negtvar: T_NEG(var) */
	case 24: /* negvar: T_NEG(var) */
	case 23: /* nottvar: T_NOT(tvar) */
	case 22: /* notvar: T_NOT(var) */
	case 6: /* num: T_NEG(num) */
	case 5: /* num: T_NOT(num) */
		kids[0] = LEFT_CHILD(p);
		break;
	default:
		burm_assert(0, PANIC("Bad external rule number %d in burm_kids\n", eruleno));
	}
	return kids;
}

int burm_op_label(NODEPTR_TYPE p) {
	burm_assert(p, PANIC("NULL tree in burm_op_label\n"));
	return OP_LABEL(p);
}

STATEPTR_TYPE burm_state_label(NODEPTR_TYPE p) {
	burm_assert(p, PANIC("NULL tree in burm_state_label\n"));
	return STATE_LABEL(p);
}

NODEPTR_TYPE burm_child(NODEPTR_TYPE p, int index) {
	burm_assert(p, PANIC("NULL tree in burm_child\n"));
	switch (index) {
	case 0:	return LEFT_CHILD(p);
	case 1:	return RIGHT_CHILD(p);
	}
	burm_assert(0, PANIC("Bad index %d in burm_child\n", index));
	return 0;
}

#endif





void burm_reduce(NODEPTR_TYPE bnode, int goalnt)
{
  int ruleNo = burm_rule (STATE_LABEL(bnode), goalnt);
  short *nts = burm_nts[ruleNo];
  NODEPTR_TYPE kids[100];
  int i;

  if (ruleNo==0) {
    fprintf(stderr, "tree cannot be derived from start symbol");
    exit(1);
  }
  burm_kids (bnode, ruleNo, kids);
  for (i = 0; nts[i]; i++)
    burm_reduce (kids[i], nts[i]);    /* reduce kids */

#if DEBUG
  printf ("%s", burm_string[ruleNo]);  /* display rule */
#endif

  switch (ruleNo) {
  case 10:

    break;
  case 11:

    break;
  case 12:

    break;
  case 13:

    break;
  case 14:

    break;
  case 15:

    break;
  case 16:

    break;
  case 30:
	bnode->name = asm_op_tvar_num("add", bnode->right, bnode->left->val);
    break;
  case 17:

    break;
  case 31:
	bnode->name = asm_op_tvar_tvar("add", bnode->left, bnode->right);
    break;
  case 18:

    break;
  case 32:
	bnode->name = asm_op_tvar_var("add", bnode->left, bnode->right);
    break;
  case 19:

    break;
  case 33:
	bnode->name = asm_op_tvar_var("add", bnode->right, bnode->left);
    break;
  case 34:
	bnode->name = asm_op_reg_num("imul", bnode->left, bnode->right->val);
    break;
  case 35:
	bnode->name = asm_op_reg_num("imul", bnode->right, bnode->left->val); 
    break;
  case 36:
 	bnode->name = asm_op_reg_reg("imul", bnode->left, bnode->right); 
    break;
  case 50:
	bnode->name = asm_cmpop_reg_num("g", "le", bnode->left, bnode->right->val);
    break;
  case 37:
	bnode->name = asm_op_tvar_num("imul", bnode->left, bnode->right->val);
    break;
  case 51:
	bnode->name = asm_cmpop_reg_num("g", "le", bnode->right, bnode->left->val); 
    break;
  case 38:
	bnode->name = asm_op_tvar_num("imul", bnode->right, bnode->left->val); 
    break;
  case 52:
 	bnode->name = asm_cmpop_reg_reg("g", "le", bnode->left, bnode->right);
    break;
  case 39:
 	bnode->name = asm_op_tvar_tvar("imul", bnode->left, bnode->right); 
    break;
  case 53:
	bnode->name = asm_cmpop_tvar_num("g", "le", bnode->left, bnode->right->val);
    break;
  case 54:
	bnode->name = asm_cmpop_tvar_num("g", "le", bnode->right, bnode->left->val);
    break;
  case 55:
	bnode->name = asm_cmpop_tvar_tvar("g", "le", bnode->left, bnode->right);
    break;
  case 56:
	bnode->name = asm_cmpop_tvar_var("g", "le", bnode->left, bnode->right);
    break;
  case 1:

    break;
  case 57:
	bnode->name = asm_cmpop_tvar_var("g", "le", bnode->right, bnode->left);
    break;
  case 2:

    break;
  case 58:
	bnode->name = asm_cmpop_reg_num("e", "ne", bnode->left, bnode->right->val);
    break;
  case 3:

    break;
  case 59:
	bnode->name = asm_cmpop_reg_num("e", "ne", bnode->right, bnode->left->val); 
    break;
  case 4:
	bnode->val = bnode->left->val + bnode->right->val;
    break;
  case 5:
	bnode->val = ~bnode->left->val;
    break;
  case 6:
	bnode->val = -bnode->left->val;
    break;
  case 7:
	bnode->val = bnode->left->val * bnode->right->val;
    break;
  case 8:

    break;
  case 9:

    break;
  case 20:

    break;
  case 21:

    break;
  case 22:
 	bnode->name = asm_not_var(bnode->left);
    break;
  case 23:
	bnode->name = asm_not_tvar(bnode->left);
    break;
  case 24:
 	bnode->name = asm_neg_var(bnode->left);
    break;
  case 25:
	bnode->name = asm_neg_tvar(bnode->left);
    break;
  case 26:
	bnode->name = asm_op_reg_num("add", bnode->left, bnode->right->val);
    break;
  case 40:
	bnode->name = asm_op_tvar_var("imul", bnode->left, bnode->right);
    break;
  case 27:
	bnode->name = asm_op_reg_num("add", bnode->right, bnode->left->val); 
    break;
  case 41:
	bnode->name = asm_op_tvar_var("imul", bnode->right, bnode->left);
    break;
  case 28:
 	bnode->name = asm_op_reg_reg("add", bnode->left, bnode->right); 
    break;
  case 42:
	bnode->name = asm_op_reg_num("or", bnode->left, bnode->right->val);
    break;
  case 29:
	bnode->name = asm_op_tvar_num("add", bnode->left, bnode->right->val);
    break;
  case 43:
	bnode->name = asm_op_reg_num("or", bnode->right, bnode->left->val); 
    break;
  case 44:
 	bnode->name = asm_op_reg_reg("or", bnode->left, bnode->right); 
    break;
  case 45:
	bnode->name = asm_op_tvar_num("or", bnode->left, bnode->right->val);
    break;
  case 46:
	bnode->name = asm_op_tvar_num("or", bnode->right, bnode->left->val);
    break;
  case 60:
 	bnode->name = asm_cmpop_reg_reg("e", "ne", bnode->left, bnode->right);
    break;
  case 47:
	bnode->name = asm_op_tvar_tvar("or", bnode->left, bnode->right);
    break;
  case 61:
	bnode->name = asm_cmpop_tvar_num("e", "ne", bnode->left, bnode->right->val);
    break;
  case 48:
	bnode->name = asm_op_tvar_var("or", bnode->left, bnode->right);
    break;
  case 62:
	bnode->name = asm_cmpop_tvar_num("e", "ne", bnode->right, bnode->left->val);
    break;
  case 49:
	bnode->name = asm_op_tvar_var("or", bnode->right, bnode->left);
    break;
  case 63:
	bnode->name = asm_cmpop_tvar_tvar("e", "ne", bnode->left, bnode->right);
    break;
  case 64:
	bnode->name = asm_cmpop_tvar_var("e", "ne", bnode->left, bnode->right);
    break;
  case 65:
	bnode->name = asm_cmpop_tvar_var("e", "ne", bnode->right, bnode->left);
    break;
  case 66:
	asm_ret_num(bnode->left);
    break;
  case 67:
	asm_ret_reg(bnode->left); 
    break;
  case 68:
	asm_ret_tvar(bnode->left); 
    break;
  case 69:
	asm_ret();
    break;
  default:    assert (0);
  }
}
