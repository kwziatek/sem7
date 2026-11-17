 /* Definition section */
%{
#include <stdio.h>

int string_w = 1; /* string_w = 1 : czekamy na stringa */
int comment_w = 1; /* comment_w = 1: czekamy na komentarz */

%}

 /* Deklaracja stanów skanera (Start Conditions) */


%%
 /* Rules section */
^[ \t]*"--".*\n?    { /* Jeżeli na początku linii (^) są tylko tabulatory, spacje i komentarz,
                        to usuwamy cały wiersz. */
                    }
\"                  { /* Jeżeli jesteśmy w komentarzu, pomijamy, jeżeli w stringu,
                        zamykamy string. W przeciwnym razie zamykamy stringa */
                        if (!comment_w) {

                        } else if(!string_w) {
                            string_w = 1;
                            printf("%s", yytext);
                        } else {
                            string_w = 0;
                            printf("%s", yytext);
                        }
                    }

"--"                { /* Jeżeli jesteśmy w stringu, wyświetlamy. W przeciwnym razie
                        zaczynamy komentarz */
                        if (!string_w) {
                            printf("%s", yytext);
                        } else {
                            comment_w = 0;
                        }
                    }
\n                  { /* Jeśli jesteśmy w komentarzu, zamykamy */
                        if(!comment_w) {
                            comment_w = 1;
                        } 
                        printf("%s", yytext);
                    }
[^ \t\"\n-]+         { /* Jeśli w komentarzu, pomijamy. W przeciwnym razie, wyświetlamy. */
                        if(comment_w) {
                            printf("%s", yytext);
                        } 
                    }
.                   { 
                        /* Drobne znaki (np. pojedyncze spacje/tabulatory poza stringiem/komentarzem) */
                        if (comment_w) {
                            printf("%s", yytext);
                        }
                    }
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