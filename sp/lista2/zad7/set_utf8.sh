#!/bin/bash
URL=$1
PATTERN=$2
TMP_DIR=$(mktemp -d)

# 1. Pobranie repozytorium do tymczasowego katalogu
svn checkout "$URL" "$TMP_DIR"

# 2. Znalezienie plików wg wzorca i ustawienie właściwości
find "$TMP_DIR" -type f -name "$PATTERN" -exec svn propset svn:mime-type "text/plain;charset=utf-8" {} +

# 3. Wysłanie zmian na serwer i sprzątanie
svn commit "$TMP_DIR" -m "Ustawiono UTF-8 dla plików $PATTERN"
rm -rf "$TMP_DIR"