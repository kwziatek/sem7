#!/bin/bash

# Sprawdzenie czy podano dokładnie 2 argumenty
if [ "$#" -ne 2 ]; then
    echo "Użycie: $0 <NR_REWIZJI> <URL_KATALOGU>"
    echo "Przykład: $0 18 https://repo.cs.pwr.edu.pl/info/SP/l3/a/"
    exit 1
fi

REV=$1
URL=$2

# Utworzenie unikalnego katalogu tymczasowego w systemie
TMP_DIR=$(mktemp -d)

# Pobranie czystych plików z podanej rewizji
svn export -q -r "$REV" "$URL" "$TMP_DIR/dane"

# Sprawdzenie, czy polecenie svn wykonało się poprawnie
if [ $? -ne 0 ]; then
    echo "Błąd: Nie udało się pobrać danych. Sprawdź URL, rewizję lub połączenie." >&2
    rm -rf "$TMP_DIR"
    exit 2
fi

# Przetwarzanie: zliczanie liczby plików, w których występuje dane słowo
find "$TMP_DIR/dane" -type f -print0 | while IFS= read -r -d '' file; do
    # Wyciągamy słowa z konkretnego pliku, ujednolicamy wielkość liter
    # i używamy sort -u, aby zostawić tylko UNIKALNE słowa dla TEGO pliku
    grep -oE '\w+' "$file" | tr '[:upper:]' '[:lower:]' | sort -u
done | sort | uniq -c | sort -nr

# Posprzątanie plików tymczasowych
rm -rf "$TMP_DIR"