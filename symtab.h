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