# Übersetzerbau VU | 2014S | Beispiel 6: Codeerzeugung A

## Termin

Abgabe spätestens am 21. Mai 2014, 14 Uhr.

## Angabe

Erweitern Sie die statische Analyse aus dem AG-Beispiel mit Hilfe von **iburg** zu einem Compiler, der folgende Untermenge der statisch korrekten Programme in AMD64-Assemblercode übersetzt: alle Programme, in denen aus **Stat** nur **return**-Anweisungen abgeleitet werden, in denen aber kein *Funktionsaufruf abgeleitet* wird. Programme, die statisch korrekt sind, aber dieser Einschränkung nicht entsprechen, werden bei diesem Beispiel nicht als Testeingaben vorkommen.
Ein Teil der Sprache wurde schon im Beispiel attributierte Grammatik erklärt, hier der für dieses Beispiel notwendige Zusatz:

### Datendarstellung

Diese Programmiersprache kennt nur einen Datentyp: das 64-bit-Wort, das als vorzeichenbehaftete Zahl oder als Speicheradresse verwendet werden kann. Weder der Compiler noch das Laufzeitsystem soll eine Typüberprüfung vornehmen. Der Programmierer (der Anwender des Compilers) muss wissen, was er tut, der Compiler soll (und kann) das nicht überprüfen. Unsere Testprogramme führen keine Zugriffe auf ungültige Adressen aus.

### Bedeutung der Operatoren

+, - und das binäre * haben ihre übliche Bedeutung (ein etwaiger Überlauf soll ignoriert werden). or und not führen die Operation bitweise auf ihren Operanden durch. > und <> (entspricht ≠) vergleichen ihre Operanden und liefern -1 für wahr und 0 für falsch.
Bei einem *Feldzugriff* ist **Term** die Anfangsadresse der Struktur. Die Felder einer Struktur sind 64-bit (8 Bytes) groß und enthalten 64-bit-Wörter. Das erste Feld einer Struktur hat den Offset 0 von der Anfangsadresse, das zweite den Offset 8 usw. Bei einem *Feldzugriff* erfolgt der Zugriff auf die Adresse Term+Offset. Der *lesende Feldzugriff* liefert als Resultat das 64-bit-Wort an dieser Adresse.

### Anweisungen 

Die return-Anweisung beendet die Funktion und liefert das Resultat von Expr als Ergebnis des Aufrufs der Funktion.

### Erzeugter Code

Ihr Compiler soll AMD64-Assemblercode ausgeben. Jede Funktion im Programm verhält sich gemäß der Aufrufkonvention. Der erzeugte Code wird nach dem Assemblieren und Linken von C-Funktionen aufgerufen. Beispiel: Die Funktion **func foo(a b) ... end;** kann von C aus mit **foo(x,y)** aufgerufen werden, wobei **a** den Wert von **x** bekommt und **b** den von **y**.
Der Name einer Funktion soll als Assembler-Label am Anfang des erzeugten Codes verwendet werden und das Symbol soll exportiert werden; andere Symbole soll Ihr Code nicht exportieren.
Folgende Einschränkungen sind dazu gedacht, Ihnen gewisse Probleme zu ersparen, die reale Compiler bei der Codeauswahl und Registerbelegung haben. Sie brauchen diese Einschränkungen nicht überprüfen, unsere Testeingaben halten sich an diese Einschränkungen (eine Überprüfung könnte Ihnen allerdings beim Debuggen Ihrer eigenen Testeingaben helfen): Funktionen haben maximal 6 Parameter. Die maximale Tiefe eines Ausdrucks4 ist ≤ 6 - v, wobei v die Anzahl der sichtbaren Variablen ist. Die im Quellprogramm vorkommenden Zahlen und konstanten Ausdrücke sind ≥-2^31 und < 2^31; das gilt aber nicht für Ergebnisse von Berechnungen zur Laufzeit.
Der erzeugte Code soll korrekt sein und möglichst wenige Befehle ausführen (da es hier keine Verzweigungen gibt, ist das gleichbedeutend mit „wenige Befehle enthalten“). Dabei ist nicht an eine zusätzliche Optimierung (wie z.B. common subexpression elimination) gedacht, sondern vor allem an das, was Sie mit iburg tun können, also eine gute Codeauswahl (besonders bezüglich konstanter Operanden und Ausnutzung der Adressierungsarten) und eventuell einige algebraische Optimierungen (siehe z.B. [http://www.complang.tuwien.ac.at/papers/ertl00dagstuhl.ps.gz](http://www.complang.tuwien.ac.at/papers/ertl00dagstuhl.ps.gz)). Für besonders effizienten erzeugten Code gibt es Sonderpunkte.
Beachten Sie, dass es leicht ist, durch eine falsche Optimierungsregel mehr Punkte zu verlieren, als Sie durch Optimierung überhaupt gewinnen können. Testen Sie daher ihre Optimierungen besonders gut (mindestens ein Testfall pro Optimierungsregel). Überlegen Sie sich, welche Optimierungen es wohl wirklich bringen (welche Fälle also tatsächlich vorkommen), und lassen Sie die anderen weg.

## Abgabe

Zum angegebenen Termin stehen die maßgeblichen Dateien im Verzeichnis **˜/abgabe/codea**. Mittels **make clean** soll man alle von Werkzeugen erzeugten Dateien löschen können und mittels make ein Programm namens **codea** erzeugen, das von der Standardeingabe liest und den generierten Code auf die Standardausgabe ausgibt. Bei einem lexikalischen Fehler soll der Fehlerstatus 1 erzeugt werden, bei einem Syntaxfehler Fehlerstatus 2, bei anderen Fehlern der Fehlerstatus 3. Im Fall eines Fehlers darf die Ausgabe beliebig sein.