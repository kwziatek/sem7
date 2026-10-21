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
find "$1" -type f -exec bash -c '
    for file; do
        tr -s "[:space:]" "\n" < "$file" | grep -a -v "^$" | sort -u
    done
' _ {} + | \
    sort | \
    uniq -c | \
    sort -nr