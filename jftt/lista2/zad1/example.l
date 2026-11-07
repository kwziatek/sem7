 /* Definition section */
%{
#include <stdio.h>

int words = 0;
int lines = 0;
int first_word_in_line = 1; /* Flaga: 1 = czekamy na pierwsze słowo w linii */
%}

%%
 /* Rule Section */
[ \t]+      { /* Ignorujemy wszystkie spacje i tabulatory.
                Sami wstawiamy pojedynczą spację między słowami.*/ }
\n          { /* Jeśli w wierszu było przynajmniej jedno słowo, wypisz znak nowej linii.
                W przeciwnym razie to linia pusta, więc nie wypisuj nic. */
                
                if(!first_word_in_line) {
                    printf("\n");
                    lines++;
                    first_word_in_line = 1;
                }
            }
            
[^ \t\n]+    { /* Natrafiamy na słowo. Jeżeli jakieś już było dodajemy spację.
                Wyświetlamy słowo. */

                if(!first_word_in_line) {
                    printf(" ");
                }
                printf("%s", yytext);

                words++;
                first_word_in_line = 0; // Oznaczamy, że w tej linii wystąpiło już słowo.
            }
%%

 /* Code section */
int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("Nie mozna otworzyc pliku: %s\n", argv[1]);
            return 1;
        }
    } 
    // Jeśli nie podano pliku, yyin czyta z stdin (konsoli)

    yylex(); /* Uruchom skaner */

    // Jeśli plik nie kończył się znakiem nowej linii,
    // a zawierał tekst, doliczamy tę ostatnią linię.
    if(!first_word_in_line) {
        printf("\n");
        lines++;
    }
    
    printf("\n--- PODSUMOWANIE ---\n");
    printf("Liczba linii: %d\n", lines);
    printf("Liczba slow: %d\n", words);
    
    if (argc > 1) {
        fclose(yyin);
    }

    return 0;
}

int yywrap(void) {
    return 1; /* Sygnał końca pliku */
}