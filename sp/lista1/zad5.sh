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

# Podmiana znaków we wszystkich znalezionych plikach
find "$1" -type f -exec sed -i 's/a/A/g' {} +