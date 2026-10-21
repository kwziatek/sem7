#!/bin/bash

# Sprawdzenie argumentu
if [ -z "$1" ]; then
    echo "Użycie: $0 <ścieżka_do_katalogu>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Błąd: '$1' nie jest katalogiem."
    exit 1
fi

# Przetwarzanie plików
find "$1" -type f -exec cat {} + | \
    tr -s '[:space:]' '\n' | \
    grep -a -v '^$' | \
    sort | \
    uniq -c | \
    sort -nr