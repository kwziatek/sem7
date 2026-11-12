#!/bin/bash

# Sprawdzenie czy podano dokładnie 2 argumenty
if [ "$#" -ne 2 ]; then
    echo "Użycie: $0 <NR_REWIZJI> <URL_KATALOGU>"
    echo "Przykład: $0 23 https://repo.cs.pwr.edu.pl/info/SP/l3/a/"
    exit 1
fi

REV=$1
URL=$2

# Utworzenie unikalnego katalogu tymczasowego w systemie
TMP_DIR=$(mktemp -d)

# Pobranie czystych plików z podanej rewizji (bez meta-katalogów .svn)
# Flaga -q (quiet) ukrywa standardowe wyjście, pobieramy do katalogu "dane"
svn export -q -r "$REV" "$URL" "$TMP_DIR/dane"

# Sprawdzenie, czy polecenie svn wykonało się poprawnie
if [ $? -ne 0 ]; then
    echo "Błąd: Nie udało się pobrać danych. Sprawdź URL, rewizję lub połączenie." >&2
    rm -rf "$TMP_DIR"
    exit 2
fi

# Przetwarzanie plików i statystyka słów
find "$TMP_DIR/dane" -type f -exec cat {} + 2>/dev/null | \
    grep -oE '\w+' | \
    tr '[:upper:]' '[:lower:]' | \
    sort | \
    uniq -c | \
    sort -nr

# Posprzątanie plików tymczasowych
rm -rf "$TMP_DIR"