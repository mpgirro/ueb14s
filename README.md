# Attributierte Grammatik

## Termin

Abgabe spätestens am 7. Mai 2014, 14 Uhr.

## Angabe

Erweitern Sie den Parser aus dem letzten Beispiel mit Hilfe von **ox** um eine Symboltabelle und eine statische Analyse.

Die *hervorgehobenen* Begriffe beziehen sich auf Kommentare in der Grammatik.

Die folgenden Dinge haben Namen: Funktionen, Strukturen, Felder und Variablen.

Eine Funktion wird im *Funktionsaufruf* verwendet und in der *Funktionsdefinition* definiert. Verwendete Funktionen müssen nicht definiert werden und können nicht deklariert2 werden. Funktionen dürfen, soweit es den Compiler betrifft, doppelt definiert werden und dürfen den gleichen Namen wie Variablen oder Labels haben; daher muss der Compiler Funktionsnamen nicht in einer Symboltabelle verwalten. Auch die Übereinstimmung der Anzahl der Argumente soll (und kann) der Compiler nicht überprüfen.

Alle Namen (**id**s), die in einer *Parameterdefinition* oder in einer **let**-Anweisung vorkommen, sind Variablennamen. Variablen, die in einer *Parameterdefinition* definiert wurden, sind in der ganzen Funktion sichtbar. Variablen, die einer **let**-Anweisung definiert wurden, sind zwischen dem **in** und dem **end** sichtbar, und nirgendwo sonst. In der Definition ist die Variable noch nicht sichtbar.

*Strukturnamen* aus **Structdefs** (und nur diese) können in einer **with**-Anweisung als **id** (zwischen **:** und **in**) verwendet werden. Strukturnamen sind im gesamten Programm an diesen Stellen sichtbar (auch vor der Definition).

Alle Namen (**id**s) in einer Felddefinition sind Feldnamen.

Feldnamen können in zwei Kontexten verwendet werden: 1) Im *schreibenden* oder *lesenden Feldzugriff* hinter dem Punkt (Feldkontext). 2) Im *schreibenden* oder *lesenden Variablenzugriff* (Variablenkontext).

Feldnamen sind im ganzen Programm im Feldkontext sichtbar (auch vor der Definition).

Ein Feldname ist normalerweise nicht im Variablenkontext sichtbar. In den **Stats** einer **with**-Anweisung sind die Namen der Felder der Struktur sichtbar, deren Namen als **id** in der **with**-Anweisung vorkommt (zwischen **:** und **do**). Beispiel: **with a:b do c=d; end;** hier können c und d Felder sein, die in der Definition der Struktur b definiert wurden.

In einem Programm darf ein Name nur einmal als Strukturname vorkommen. In einem Programm darf ein Name nur einmal als Feldname vorkommen. Strukturen und Felder haben getrennte Namensräume, derselbe Name kann also für eine Struktur und für ein Feld verwendet werden.

In einer Funktion dürfen an keiner Stelle zwei Variablen oder Felder mit dem gleichen Namen im Variablenkontext sichtbar sein (unabhängig davon, ob der Name tatsächlich im Variablenkontext verwendet wird). Es darf aber derselbe Name definiert werden, wenn sich die Sichtbarkeitsbereiche nicht überlappen. Beispiel:

	struct a: b end;  
	func f(c)  
	  let b=0; in b=0; /* Variable */ end;  
	  with 0:a do b=0; /* Feld     */ end;  
	end;  
 
	func g(b)  
	  with 0:a do /* fehler: zwei b sind sichtbar */ end;  
	end;


[Die Funktion f ergibt zur Laufzeit keinen Sinn (nach den Regeln aus den folgenden Beispielen), aber das braucht und soll der Compiler nicht statisch überprüfen.]

Bei einem *Variablenzugriff* muss eine Variable, ein Parameter oder Feld (im Variablenkontext) mit dem Namen sichtbar sein.

## Hinweise

Es ist empfehlenswert, die Grammatik so umzuformen, dass sie für die Attributierung günstig ist: Fälle, die syntaktisch gleich ausschauen, aber bei den Attributierungsregeln verschieden behandelt werden müssen, sollten auf verschiedene Regeln aufgeteilt werden; umgekehrt sollten Duplizierungen, die in dem Bemühen vorgenommen wurden, Konflikte zu vermeiden, auf ihre Sinnhaftigkeit überprüft und ggf. rückgängig gemacht werden. Testen Sie Ihre Grammatikumformungen mit den Testfällen.

Offenbar übersehen viele Leute, dass attributierte Grammatiken Information auch von rechts nach links (im Ableitungsbaum) weitergeben können. Sie denken sich dann recht komplizierte Lösungen aus. Dabei reichen die von ox zur Verfügung gestellten Möglichkeiten vollkommen aus, um zu einer relativ einfachen Lösung zu kommen.

Verwenden Sie bei der Attributberechnung keine globalen Variablen oder Funktionen mit Seiteneffekten (z.B. Funktionen, die übergebene Datenstrukturen ändern)! ox macht globale Variablen einerseits unnötig, andererseits auch fast unbenutzbar, da die Ausführungsreihenfolge der Attributberechnung nicht vollständig festgelegt ist. Bei Traversals ist die Reihenfolge festgelegt, und Sie können globale Variablen verwenden; seien Sie aber trotzdem vorsichtig.
Sie brauchen angeforderten Speicher (z.B. für Symboltabellen-Einträge oder Typinformation) nicht freigeben, die Testprogramme sind nicht so groß, dass der Speicher ausgeht (zumindest wenn Sie’s nicht übertreiben).
Das Werkzeug Torero ([http://www.complang.tuwien.ac.at/torero/](http://www.complang.tuwien.ac.at/torero/)) ist dazu gedacht, bei der Erstellung von attributierten Grammatiken zu helfen.

## Abgabe

Zum angegebenen Termin stehen die maßgeblichen Dateien im Verzeichnis **˜/abgabe/ag**. Mittels **make clean** soll man alle von Werkzeugen erzeugten Dateien löschen können und mittels **make** ein Programm namens **ag** erzeugen, das von der Standardeingabe liest. Korrekte Programme sollen akzeptiert werden, bei einem lexikalischen Fehler soll der Fehlerstatus 1 erzeugt werden, bei Syntaxfehlern der Fehlerstatus 2, bei anderen Fehlern (z.B. Verwendung eines nicht sichtbaren Namens) der Fehlerstatus 3. Die Ausgabe kann beliebig sein, auch bei korrekter Eingabe.