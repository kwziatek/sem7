 /* Definition section */
%{
    int singleLineComment = 1;  /* singleLineComment = 0 for all chars in single line comment */
    int multiLineComment = 1;   /* multiLineComment = 0 for all chars in multi line comment*/
%}

%%
 /* Rule section */
"//"    { /* if not already in a comment, start a comment
            Do not print anything regardless */
            if(singleLineComment && multiLineComment) {
                singleLineComment = 0;
            }
        }
"/*"    { /* if not already in a comment, start multiline comment 
        Do not print anytning regardless */
        if(singleLineComment && multiLineComment) {
            multiLineComment = 0;
        }
    
    }
"*/"    { /* if in multi line comment, end it 
            Don't print anything regardless */
            if(!multiLineComment)  {
                multiLineComment = 1;
            }
        }
\n      {
            if(!singleLineComment) {
                singleLineComment = 1;
            }
            if (multiLineComment) {
                /* Drukuj nową linię tylko jeśli nie jesteśmy w bloku / * * / */
                printf("\n");
            }
        }
.       { /* If in comment skip, otherwise print */
            if(singleLineComment && multiLineComment) {
                printf("%s", yytext);
            }
        }

%%
 /* Code section */
int main(int argc, char **argv) {
    if(argc > 1) {
        yyin = fopen(argv[1], "r");
    }
    if(!yyin) {
        printf("Nie mozna otworzyc pliku %s", yytext);
        return 1;
    }
    // If no file provided, yyin reads from stdin (console)

    yylex();

    // add empty line for better display
    printf("\n");

    if(argc > 1) {
        fclose(yyin);
    }

    return 0;
}

int yywrap(void) {
    return 1; /* EOF signal*/
}