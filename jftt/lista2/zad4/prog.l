%{
#include <stdio.h>
#include <stdlib.h>

#define STACK_SIZE 100
int stack[STACK_SIZE];
int sp = 0;    /* Wskaźnik stosu (Stack Pointer) */
int error = 0; /* Flaga błędu */

/* Funkcja do potęgowania całkowitoliczbowego */
int int_pow(int base, int exp) {
    if (exp < 0) return 0; /* Dla uproszczenia: ujemne potęgi całkowite dają 0 */
    int res = 1;
    for (int i = 0; i < exp; i++) {
        res *= base;
    }
    return res;
}

/* Funkcja zdejmująca dwie liczby ze stosu i wykonująca operację */
void op2(char op) {
    if (sp < 2) {
        printf("Blad: za malo argumentow do operacji '%c'\n", op);
        error = 1;
        return;
    }
    
    int b = stack[--sp]; /* Prawa strona działania */
    int a = stack[--sp]; /* Lewa strona działania */
    
    switch(op) {
        case '+': stack[sp++] = a + b; break;
        case '-': stack[sp++] = a - b; break;
        case '*': stack[sp++] = a * b; break;
        case '/': 
            if (b == 0) {
                printf("Blad: dzielenie przez 0\n");
                error = 1;
            } else {
                stack[sp++] = a / b;
            }
            break;
        case '%':
            if (b == 0) {
                printf("Blad: dzielenie modulo przez 0\n");
                error = 1;
            } else {
                stack[sp++] = a % b;
            }
            break;
        case '^':
            stack[sp++] = int_pow(a, b);
            break;
    }
}
%}

 /* Definiujemy ekskluzywny stan do pomijania znaków po błędzie */
%x ERROR_RECOVERY

%%

<INITIAL>{
    /* Dopasowanie liczb (opcjonalny minus na początku) */
    -?[0-9]+    { 
                    if (sp >= STACK_SIZE) {
                        printf("Blad: przepelnienie stosu\n");
                        error = 1;
                        BEGIN(ERROR_RECOVERY);
                    } else {
                        stack[sp++] = atoi(yytext);
                    }
                }

    /* Operatory */
    "+"         { op2('+'); if (error) BEGIN(ERROR_RECOVERY); }
    "-"         { op2('-'); if (error) BEGIN(ERROR_RECOVERY); }
    "*"         { op2('*'); if (error) BEGIN(ERROR_RECOVERY); }
    "/"         { op2('/'); if (error) BEGIN(ERROR_RECOVERY); }
    "%"         { op2('%'); if (error) BEGIN(ERROR_RECOVERY); }
    "^"         { op2('^'); if (error) BEGIN(ERROR_RECOVERY); }

    /* Ignorowanie spacji i tabulatorów */
    [ \t]+      { /* puste akcje */ }

    /* Koniec wyrażenia - znak nowej linii */
    \n          {
                    if (sp == 1) {
                        printf("Wynik: %d\n", stack[0]);
                    } else if (sp > 1) {
                        printf("Blad: za malo operatorow (pozostaly liczby na stosie)\n");
                    }
                    /* Resetowanie kalkulatora na nową linię */
                    sp = 0;
                    error = 0;
                }

    /* Wyłapywanie każdego innego, niedozwolonego znaku */
    .           { 
                    printf("Blad: nieznany znak '%s'\n", yytext);
                    error = 1;
                    BEGIN(ERROR_RECOVERY);
                }
}

<ERROR_RECOVERY>{
    /* Jeśli wpadliśmy w stan błędu, ignorujemy całą resztę linii */
    .           { /* ignoruj wszystko */ }
    
    /* Enter resetuje system i przywraca stan początkowy (INITIAL) */
    \n          { 
                    sp = 0; 
                    error = 0; 
                    BEGIN(INITIAL); 
                }
}

%%

int main(void) {
    printf("--- Kalkulator RPN ---\n");
    printf("Dostepne operatory: + - * / %% ^\n");
    printf("Wpisz dzialanie i nacisnij Enter:\n");
    yylex();
    return 0;
}

int yywrap(void) {
    return 1;
}