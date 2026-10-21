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
    for (i = 1; i <= NF; i++) {
        print "Słowo: " $i " | Plik: " FILENAME " | Linia: " $0
    }
}' {} +