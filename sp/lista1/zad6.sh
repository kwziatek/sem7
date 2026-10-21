#!/bin/bash

# Sprawdzenie argumentów
if [ -z "$1" ]; then
    echo "Użycie: $0 <ścieżka_do_katalogu>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Błąd: '$1' nie jest katalogiem."
    exit 1
fi

# Przetwarzanie plików
find "$1" -type f -exec awk '
{
    delete count
    delete printed
    
    # Zliczanie wystąpień każdego słowa w bieżącym wierszu
    for (i = 1; i <= NF; i++) {
        count[$i]++
    }
    
    # Wypisywanie słów, które wystąpiły więcej niż raz w tym wierszu
    for (i = 1; i <= NF; i++) {
        word = $i
        if (count[word] > 1 && !printed[word]) {
            print "Słowo: \"" word "\" | Plik: " FILENAME " | Wiersz: " $0
            printed[word] = 1
        }
    }
}' {} +