#!/usr/bin/env bash
if [ $# -ne 2 ]; then
  echo "Uso: ./correr.sh <Clase> <nombre-de-la-evidencia> (ejemplo: ./correr.sh AppSinSpring mp1)"; exit 2
fi
clase="$1"; nombre="$2"
archivo="evidencia/$nombre.txt"
mkdir -p evidencia
if ! ./mvnw -q -B compile dependency:build-classpath -Dmdep.outputFile=target/classpath.txt > "$archivo" 2>&1; then
  cat "$archivo"
  echo "NO COMPILA: arriba está el error"
  exit 1
fi
java -cp "target/classes:$(cat target/classpath.txt)" "com.academia.banco.$clase" 2>&1 | tee "$archivo"
codigo=${PIPESTATUS[0]}
if [ "$codigo" -ne 0 ]; then
  causa=$(grep "Caused by: " "$archivo" | tail -1)
  if [ -n "$causa" ]; then
    echo; echo "La causa (la última línea Caused by: de arriba):"; echo "$causa" | tee -a "$archivo"
  fi
fi
exit "$codigo"
