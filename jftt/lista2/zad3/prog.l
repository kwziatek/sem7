%{
#include <stdio.h>
#include <string.h>

int keepDoxygen = 0; /* Flaga włączana opcją np. -d */
%}

 /* Deklaracja ekskluzywnych stanów skanera (Start Conditions) */
%x MULTI
%x MULTI_DOX

%%

 /* --- 1. KOMENTARZE JEDNOLINIJKOWE OD POCZĄTKU WIESZA --- */
 /* Łapiemy z \n na końcu, aby usunąć z kodu całą pustą linię */
^[ \t]*"///".*\n?   |
^[ \t]*"//!".*\n?   {
    if (keepDoxygen) printf("%s", yytext);
}

^[ \t]*"//".*\n?    {
    /* Zignoruj - cała linia ze zwykłym komentarzem zniknie */
}

 /* --- 2. KOMENTARZE JEDNOLINIJKOWE DOKLEJONE DO KODU --- */
 /* Usuwają tylko sam komentarz (.* nie łapie \n, więc wiersz z kodem zostaje) */
"///".* |
"//!".* {
    if (keepDoxygen) printf("%s", yytext);
}

"//".*  {
    /* Zignoruj sam komentarz na końcu linii */
}


 /* --- 3. POCZĄTEK KOMENTARZA WIELOLINIJKOWEGO --- */
"/**" |
"/*!"   {
    if (keepDoxygen) {
        printf("%s", yytext);
        BEGIN(MULTI_DOX); /* Przejdź w tryb zachowywania Doxygen */
    } else {
        BEGIN(MULTI);     /* Przejdź w tryb zwykłego usuwania */
    }
}

"/*"    {
    BEGIN(MULTI); /* Przejdź w tryb usuwania */
}


 /* --- 4. ZACHOWANIE WEWNĄTRZ ZWYKŁEGO KOMENTARZA (USUWANIE) --- */
<MULTI>"*/" {
    BEGIN(INITIAL); /* Znaleziono koniec, wracamy do normalnego kodu */
}
<MULTI>.|\n {
    /* Zjadaj wszystko znak po znaku wewnątrz komentarza */
}


 /* --- 5. ZACHOWANIE WEWNĄTRZ KOMENTARZA DOXYGEN (PRZEPISYWANIE) --- */
<MULTI_DOX>"*/" {
    printf("%s", yytext);
    BEGIN(INITIAL); /* Znaleziono koniec, wracamy do normalnego kodu */
}
<MULTI_DOX>.|\n {
    printf("%s", yytext); /* Przepisujemy zawartość Doxygen na ekran */
}

%%

int main(int argc, char **argv) {
    int i;
    
    /* Przetwarzanie argumentów w poszukiwaniu opcji i nazwy pliku */
    for (i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-d") == 0) {
            keepDoxygen = 1; /* Włącz opcję Doxygen */
        } else {
            /* Jeśli to nie opcja, traktuj jako plik do otwarcia */
            yyin = fopen(argv[i], "r");
            if(!yyin) {
                printf("Nie mozna otworzyc pliku %s\n", argv[i]);
                return 1;
            }
        }
    }

    yylex();

    if(yyin) {
        fclose(yyin);
    }
    
    return 0;
}

int yywrap(void) {
    return 1;
}