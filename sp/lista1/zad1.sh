#!/bin/bash

# Sprawdzenie, czy podano argument
if [ -z "$1" ]; then
    echo "Użycie: $0 <ścieżka_do_katalogu>"
    exit 1
fi

# Sprawdzenie, czy podana ścieżka jest faktycznie katalogiem
if [ ! -d "$1" ]; then
    echo "Błąd: '$1' nie jest katalogiem lub nie istnieje."
    exit 1
fi

# Szukanie tylko regularnych plików (-type f) i wypisanie ich na ekran
find "$1" -type f