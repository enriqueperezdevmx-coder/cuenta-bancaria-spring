#!/usr/bin/env bash
if [ $# -ne 1 ]; then
  echo "Uso: ./probar.sh <nombre-de-la-evidencia> (ejemplo: ./probar.sh mp0)"; exit 2
fi
nombre="$1"
archivo="evidencia/$nombre.txt"
mkdir -p evidencia
inicio=$(mktemp)
./mvnw -B test > "$archivo" 2>&1
codigo=$?
awk -v dir="$PWD/" '
  /BUILD (SUCCESS|FAILURE)/ { if (!fin) print substr($0, index($0, "BUILD")); fin = 1; next }
  /^\t/ { next }
  cont && /^[A-Z]/ { print "    " $0; next }
  /^[A-Z]/ { cont = 0 }
  / \[INFO\] (\+--|\|)/ { print substr($0, 8); next }
  / \[ERROR\] (Failures|Errors):/ { print substr($0, 9); next }
  / \[ERROR\]   [A-Z][A-Za-z0-9]*Test/ { print substr($0, 9); cont = 1; next }
  /Tests run:/ { print substr($0, index($0, "Tests run:")); next }
  /COMPILATION ERROR/ { print "NO COMPILA:"; next }
  /^[ERROR] .*\/[A-Za-z0-9]+\.java:\[/ { t = substr($0, 9); sub(dir, "", t); print t; next }
' "$archivo"

if [ "$codigo" -ne 0 ] && ! grep -qE "Tests run:|COMPILATION ERROR" "$archivo"; then
  echo "--- Maven falló antes de correr las pruebas. Las últimas 25 líneas: ---"
  tail -25 "$archivo"
fi
if [ "$codigo" -eq 0 ] && ! grep -q 'Tests run: [1-9]' "$archivo"; then
  echo "⚠ No corrió ninguna prueba. (Si ya escribiste pruebas, revisa «Si algo falla».)"
fi
echo "→ salida completa en $archivo"
rm -f "$inicio"
exit "$codigo"
