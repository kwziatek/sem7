 /* Definition section */
%{
#include <stdio.h>

%}

%%
 /* Rules section */
^[ \t]*"--".*\n?    { /* Jeżeli na początku linii (^) są tylko tabulatory, spacje i komentarz,
                        to usuwamy cały wiersz. */
                    }
"--".*              { /* Jeśli komentarz jest w środku linii, usuwamy go, 
                        i wszystko, co jest po nim */
                    }
 /* Czysty tekst i puste linie zostaną automatycznie wypisane, nie trzeba reguł. */

%%
 /* Code section */

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if(!yyin) {
            printf("Nie mozna otworzyc pliku %s\n", argv[1]);
            return 1;
        }
    }
    // If not file provided yyin reads from stdin (console)

    yylex(); /* Start scanner */

    /* Add an empty line for better display */
    printf("\n");

    if(argc > 1) {
        fclose(yyin);
    }

    return 0;
}

int yywrap(void) {
    return 1; /* EOF signal */
}