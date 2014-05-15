#ifndef SYMTAB_INCL
#define SYMTAB_INCL

/* === structs === */
	
typedef struct symboltable_entry{
	char *name;

	/* if field entry this is the name  of the
	 * struct this field belongs to, NULL else */
	char *ref;  
	struct symboltable_entry *next;	
} symtabentry_t;

typedef struct symboltable{
	symtabentry_t *first;
	symtabentry_t *last;
} symtab_t;

/* === function signatures === */

symtab_t *symtab_init(void);
symtab_t *symtab_add(symtab_t *tab, char *name, char *ref);
symtab_t *symtab_dup(symtab_t *src, symtab_t *dest);
symtab_t *symtab_merge(symtab_t *tab1, symtab_t *tab2);
symtab_t *symtab_merge_nodupcheck(symtab_t *tab1, symtab_t *tab2);
symtab_t *symtab_subtab(symtab_t *ftab, char *name);
void symtab_checkdup(symtab_t *tab, char *name);
void symtab_isdef(symtab_t *tab, char *name);
void symtab_print(symtab_t *tab);

symtabentry_t *stentry_init(void);
symtabentry_t *stentry_append(symtab_t *tab, symtabentry_t *entry);
symtabentry_t *stentry_dup(symtabentry_t *entry);
symtabentry_t *stentry_find(symtab_t *tab, char *name);

#endif