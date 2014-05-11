/* === structs === */
	
typedef struct symboltable_entry{
	char *name;

	/* if field entry this is the name  of the
	 * struct this field belongs to, NULL else */
	char *ref;  
	struct symboltable_entry *next;	
} symtabentry;

typedef struct symboltable{
	symtabentry *first;
	symtabentry *last;
} symtab;