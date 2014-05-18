#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

symtab_t *symtab_init(void)
{
	symtab_t *tab = malloc(sizeof(symtab_t));
	tab->first = NULL;
	tab->last = NULL;
	return tab;
}

symtab_t *symtab_add(symtab_t *tab, char *reg, char *name, char *ref)
{
	/* ok, now lets add the new entry */
	symtabentry_t *entry = stentry_init();
	
	entry->name = strdup(name);
	
	if(reg != NULL)
		entry->reg = strdup(reg);
	else
		entry->reg = NULL;

	/* strdup(NULL) is very undefined and not to be trusted */
	if(ref != NULL)
		entry->ref = strdup(ref);
	else 
		entry->ref = NULL;
	entry->next = NULL;
	stentry_append(tab, entry);
	return tab;
}

/* make an exact duplicate (copy) of symbol table src into dest */
symtab_t *symtab_dup(symtab_t *src, symtab_t *dest)
{
	symtabentry_t *cursor;
	symtabentry_t *copy;
	if(src->first != NULL) 
	{
		cursor = src->first;
		while(cursor != NULL) 
		{
			copy = stentry_dup(cursor);
			if(dest->first == NULL) 
			{
				dest->first = copy;
				dest->last 	= copy;
			} else {
				dest->last->next = copy;
				dest->last = copy;
			}
			cursor = cursor->next;
		}
	}
	return dest;
}

/*
 * adds every element of 
 */
symtab_t *symtab_merge(symtab_t *tab1, symtab_t *tab2)
{	
	symtabentry_t *cursor = tab1->first;
	while(cursor != NULL) 
	{
		stentry_append(tab2, stentry_dup(cursor)); /* append a copy! */
		cursor = cursor->next;
	}
	return tab2;
}

symtab_t *symtab_merge_nodupcheck(symtab_t *tab1, symtab_t *tab2)
{	
	symtabentry_t *cursor = tab1->first;
	while(cursor != NULL) 
	{
		symtabentry_t *entry = stentry_find(tab2, cursor->name);
		if(entry == NULL) 
		{
			stentry_append(tab2, stentry_dup(cursor)); 
		}
		cursor = cursor->next;
	}
	return tab2;
}

/* search all entries of a symtab_t for element having a *ref equal to ref
 * returns a new symtab_t with these elements, all elements are copies of there originals
 */
symtab_t *symtab_subtab(symtab_t *tab, char *ref)
{
	symtab_t *ntab = symtab_init(); /* fields of struct */
	if(ref != NULL)
	{
		if(tab->first != NULL)
		{
			symtabentry_t *cursor = tab->first;
			while(cursor != NULL) 
			{	
				if( strcmp(ref, cursor->ref) == 0 && cursor->ref != NULL ) 
				{
					stentry_append(ntab, stentry_dup(cursor)); /* append a copy! */
				}
				cursor = cursor->next;
			}
		}
	}
	return ntab;
}

/*
 * checks if a symbol 'name' is already in the symbol table *tab, raises an error if so
 */
void symtab_checkdup(symtab_t *tab, char *name)
{
	symtabentry_t *entry = stentry_find(tab, name);
	if(entry != NULL) 
	{
		(void) fprintf(stderr, "duplicate names found: %s\n", name);
		semanticerror();
	}
}

/*
 * check if a symbol 'name' is defined in *tab, raised an error if not
 */
void symtab_isdef(symtab_t *tab, char *name)
{
	
	printf("checking if %s is defined in:\n",name);
	symtab_print(tab);
	
	symtabentry_t *entry = stentry_find(tab, name);
	if(entry == NULL) 
	{
		(void) fprintf(stderr, "symbol not defined in scope: %s\n", name);
		semanticerror();
	}
}

void symtab_print(symtab_t *tab){
	
	symtabentry_t *cursor = tab->first;
	printf("symtab: ");
	while(cursor != NULL) 
	{
		printf("%s, ", cursor->name);
		cursor = cursor->next;
	}
	printf("\n");
}

symtabentry_t *stentry_init(void)
{
	symtabentry_t *entry = malloc(sizeof(symtabentry_t));
	entry->next = NULL;
	return entry;
}

/* append a entry to the symbol table at the first position */
symtabentry_t *stentry_append(symtab_t *tab, symtabentry_t *entry)
{
	
	/* check if variable is already defined */
	symtab_checkdup(tab, entry->name);
	
	if(tab->first == NULL) 
	{
		tab->first = entry;
		tab->last = entry;
	} else 
	{
		entry->next = tab->first;
		tab->first = entry;
	}
	return entry;
}

/* duplicate a symbol table entry, returns an exact copy */
symtabentry_t *stentry_dup(symtabentry_t *entry)
{
	symtabentry_t *dup = stentry_init();
	dup->name = strdup(entry->name);
	
	/* strdup(NULL) is very undefined and not to be trusted */
	if(dup->ref != NULL)
		dup->ref = strdup(entry->ref);
	else 
		dup->ref = NULL;
	dup->next = NULL;
	return dup;
}

symtabentry_t *stentry_find(symtab_t *tab, char *name)
{
	symtabentry_t *match = NULL;
	symtabentry_t *cursor = tab->first;
	while(cursor != NULL) 
	{
		if(strcmp(name, cursor->name) == 0) 
		{
			match = cursor;
			break;
		}
		cursor = cursor->next;
	}
	return match;
}

symtabentry_t *stentry_reg(symtab_t *tab, char *name)
{
	symtabentry_t *entry = stentry_find(tab,name);
	if(entry == NULL)
	{
		(void) fprintf(stderr, "not register found for entry: %s. entry is NULL\n", name);
		semanticerror();
	}
	return entry->reg;
}

/* returns the register of a given field (by name) */
char *stentry_fieldreg(symtab_t *fieldtab, char *name)
{
	/* first loop up the field entry */
	symtabentry_t fentry = stentry_find(fieldtab,name);
	
	/* now make a list of all the fields of the struct 
	 * the struct name is specified by the ref of the fieldentry */
	symtab_t structfields = symtab_subtab(fieldtab,fentry->ref);
	
	/* the fields of each struct are added chonologically by definiton
	 * appearence to the fieldtab. therefore, just count the position
	 * in the structtab to get the field position */
	
	int pos = -1; /* first element will have offset 0 */
	symtabentry_t *cursor = structfields->first;
	while(cursor != NULL) 
	{
		if(strcmp(name, cursor->name) == 0) 
			break;
		else
			pos += 1;
	}
	
	
}


