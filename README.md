# Parser

## Termin

Abgabe spätestens am 9. April 2014, 14 Uhr.

## Angabe
Gegeben ist die Grammatik (in **yacc**/**bison**-artiger EBNF):

	Program: { Def ’;’ }
	;
	
	Def: 	Funcdef
	   		| Structdef
			;
	
	Structdef: 	struct id ’:’ 	/* Strukturname */ 
				{id} 			/* Felddefinition */
				end
				;
	
	Funcdef: func id 		/* Funktionsname */
			’(’ { id } ’)’ 	/* Parameterdefinition */
			Stats end
			;
	
	Stats: { Stat ’;’ }
	     	;
		 
	Stat: 	return Expr
			| cond { Expr then Stats end ’;’ } end 
			| let { id ’=’ Expr ’;’ } in Stats end
			| with Expr ’:’ id do Stats end
			| Lexpr ’=’ Expr 	/* Zuweisung */ 
			| Term
			;
		
	Lexpr: 	id 				/* Schreibender Variablenzugriff */ 
			| Term ’.’ id 	/* Schreibender Feldzugriff */
			;
	
	Expr: 	{ not | ’-’ }  Term
	    	| Term { ’+’ Term }
	    	| Term { ’*’ Term }
	    	| Term { or Term }
	    	| Term ( ’>’ | ’<>’ ) Term
	    	;
		
	Term: 	’(’ Expr ’)’
	    	| num
			| Term ’.’ id 	/* Lesender Feldzugriff */
			| id			 /* Lesender Variablenzugriff */
			| id ’(’ { Expr ’,’ } [ Expr ] ’)’ 	/* Funktionsaufruf */ 
			;
			
Schreiben Sie einen Parser für diese Sprache mit **flex** und **yacc**/**bison**. Die Lexeme sind die gleichen wie im Scanner-Beispiel (**id** steht für einen Identifier, **num** für eine Zahl). Das Startsymbol ist **Program**.

## Abgabe

Zum angegebenen Termin stehen im Verzeichnis **~/abgabe/parser** die maßgeblichen Dateien. Mittels **make clean** soll man alle von Werkzeugen erzeugten Dateien löschen können und mittels **make** ein Programm namens **parser** erzeugen, das von der Standardeingabe liest. Korrekte Programme sollen ak- zeptiert werden (Ausstieg mit Status 0, z.B. mit **exit(0)**), bei einem lexikalischen Fehler soll der Fehlerstatus 1 erzeugt werden, bei Syntaxfehlern der Fehlerstatus 2. Das Programm darf auch etwas ausgeben (auch bei korrekter Eingabe), z.B. damit Sie sich beim Debugging leichter tun.

## Hinweise

Die Verwendung von Präzedenzdeklarationen von yacc kann leicht zu Fehlern führen, die man nicht so schnell bemerkt (bei dieser Grammatik sind sie sowieso sinnlos). Konflikte in der Grammatik sollten Sie durch Umformen der Grammatik beseitigen; **yacc** löst den Konflikt zwar, aber nicht unbedingt in der von Ihnen gewünschten Art.

Links- oder Rechtsrekursion? Also: Soll das rekursive Vorkommen eines Nonterminals als erstes (links) oder als letztes (rechts) auf der rechten Seite der Regel stehen? Bei **yacc**/**bison** und anderen LR-basierten Parsergenerato- ren funktioniert beides. Sie sollten sich daher in erster Linie danach richten, was leichter geht, z.B. weil es Konflikte vermeidet oder weil es einfachere Attributierungsregeln erlaubt. Z.B. kann man mittels Linksrekursion bei der Subtraktion einen Parse-Baum erzeugen, der auch dem Auswertungsbaum entspricht. Sollte es keine anderen Gründe geben, kann man der Linksrekursion den Vorzug geben, weil sie mit einer konstanten Tiefe des Parser-Stacks auskommt.