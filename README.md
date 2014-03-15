# Angabe

Gegeben ist folgende C-Funktion:

	void asma(unsigned char *s, unsigned char *t, unsigned char *u) 
	{
		int i;
		for (i=0; i<16; i++)
			u[i] = (s[i]>t[i]) ? s[i] : t[i];
	}

Schreiben Sie diese Funktion in Assembler unter Verwendung von pminub (viel mehr ist übrigens auch nicht nötig, insbesondere keine Schleife).

# Hinweise

Beachten Sie, dass Sie nur dann Punkte bekommen, wenn Ihre Version *pminub* verwendet und korrekt ist, also bei gleicher (zulässiger) Eingabe das gleiche Resultat liefert wie das Original.
Zum Assemblieren und Linken verwendet man am besten *gcc*, der Compiler-Treiber kümmert sich dann um die richtigen Optionen für *as* und *ld*.

# Abgabe

Legen Sie ein Verzeichnis *~/abgabe/asma* an, in das Sie die maßgeblichen Dateien stellen. Mittels *make clean* soll man alle von Werkzeugen erzeugten Dateien löschen können und *make* soll eine Datei *asma.o* erzeugen. Diese Datei soll nur die Funktion *asma* enthalten, keinesfalls *main*. Diese Funk- tion soll den Aufrufkonventionen gehorchen und wird bei der Prüfung der abgegebenen Programme mit C-Code zusammengebunden.