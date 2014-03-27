# Scanner

## Termin

Abgabe spätestens am 2. April 2014, 14 Uhr.

## Angabe

Schreiben Sie mit flex einen Scanner, der Identifier, Zahlen, und folgende Schlüsselwörter unterscheiden kann: **struct end func return with do let in cond then not or**. Weiters soll er auch noch folgende Lexeme erkennen: **: ( ) ; = . - + * > <> ,**

Identifier bestehen aus Buchstaben, Ziffern, und _, dürfen aber nur mit Buchstaben beginnen.

Zahlen sind entweder Hexadezimalzahlen oder Dezimalzahlen. Hexadezimalzahlen beginnen mit einer Dezimalziffer, gefolgt von null oder mehr Hexadezimalzifferm, gefolgt von H. Hex-Ziffern dürfen sowohl groß als auch klein geschrieben werden. Dezimalzahlen bestehen aus einer oder mehr Dezimalziffern.

Leerzeichen, Tabs und Newlines zwischen den Lexemen sind erlaubt und werden ignoriert, ebenso Kommentare, die mit **/\*** anfangen und bis zum nächsten **\*/** gehen; Kommentare können also nicht geschachtelt werden.

Alles Andere sind lexikalische Fehler.

Es soll jeweils das längste mögliche Lexem erkannt werden, **end39** ist also ein Identifier (longest input match), **39end** ist die Zahl **39** gefolgt vom Schlüsselwort **end**.

Der Scanner soll für jedes Lexem eine Zeile ausgeben: für Schlüsselwörter und Lexeme aus Sonderzeichen soll das Lexem ausgegeben werden, für Identifier **id** gefolgt von einem Leerzeichen und dem String des Identifiers, für Zahlen **num** gefolgt von einem Leerzeichen und der Zahl in Dezimaldarstellung ohne führende Nullen. Für Leerzeichen, Tabs, Newlines und Kommentare soll nichts ausgegeben werden (auch keine Leerzeile).

Der Scanner soll zwischen Groß- und Kleinbuchstaben unterscheiden, End ist also kein Schlüsselwort.

## Abgabe

Legen Sie ein Verzeichnis **~/abgabe/scanner** an, in das Sie die maßgeblichen Dateien stellen. Mittels **make clean** soll man alle von Werkzeugen erzeugten Dateien lo ̈schen ko ̈nnen (auch den ausfu ̈hrbaren Scanner) und mittels **make** ein Programm namens **scanner** erzeugen, das von der Standardeingabe liest und auf die Standardausgabe ausgibt. Korrekte Eingaben sollen akzeptiert werden (Ausstieg mit Status 0, z.B. mit **exit(0)**), bei einem lexikalischen Fehler soll der Fehlerstatus 1 erzeugt werden. Bei einem lexikalischen Fehler darf der Scanner Beliebiges ausgeben (eine sinnvolle Fehlermeldung hilft bei der Fehlersuche).