# Assambler B

## Termin

Abgabe spätestens am 26. März 2014, 14 Uhr.

## Angabe

Gegeben ist folgende C-Funktion:

	void asmb(unsigned char *s, unsigned char *t, unsigned char *u) 
	{
	  int i;
	  for (i=0; s[i] && t[i]; i++)
		u[i] = (s[i]<t[i]) ? s[i] : t[i]; u[i] = ’\0’;
	}

Schreiben Sie diese Funktion in Assembler unter Verwendung von *pminub*. Sie dürfen dabei annehmen, dass hinter dem letzten Zeichen von s, t. und u noch 16 Bytes zugreifbar sind, und sie dürfen bis zu 15 Zeichen hinter dem Ende von u beliebig verändern.
Für besonders effiziente Lösungen (gemessen an der Anzahl der ausgeführten Maschinenbefehle; wird ein Befehl n mal ausgeführt, zählt er n-fach) gibt es Bonuspunkte.


## Hinweise

Beachten Sie, dass Sie nur dann Punkte bekommen, wenn Ihre Version korrekt ist, also bei jeder zulässigen Eingabe das gleiche Resultat liefert wie das Original. Dadurch können Sie viel mehr verlieren als Sie durch Optimierung gewinnen können, also optimieren Sie im Zweifelsfall lieber weniger als mehr.
Die Vertrautheit mit dem Assembler müssen Sie beim Gespräch am Ende des Semesters beweisen, indem Sie Fragen zum abgegebenen Code beantworten.


## Abgabe

Legen Sie ein Verzeichnis *~/abgabe/asmb* an, in das Sie die maßgeblichen Dateien stellen. Mittels *make clean* soll man alle von Werkzeugen erzeugten Dateien löschen können und *make* soll eine Datei *asma.o* erzeugen. Diese Datei soll nur die Funktion *asmb* enthalten, keinesfalls *main*. Diese Funk- tion soll den Aufrufkonventionen gehorchen und wird bei der Prüfung der abgegebenen Programme mit C-Code zusammengebunden.