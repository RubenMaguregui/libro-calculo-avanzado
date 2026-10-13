#!/usr/bin/env bash
# Compila las figuras TikZ (capitulos/*/figuras/*.tex), junto al fuente, a:
#   nombre.pdf          libro PDF
#   nombre.svg          libro HTML, tema claro
#   nombre-oscuro.svg   libro HTML, tema oscuro (compilada con \modooscuro)
#
# Uso:
#   scripts/figuras.sh                 # recompila solo las figuras desactualizadas
#   scripts/figuras.sh --todas         # recompila todas
#   scripts/figuras.sh a.tex b.tex     # recompila esos archivos
set -euo pipefail

raiz="$(cd "$(dirname "$0")/.." && pwd)"
cd "$raiz"

compartidos=(tikz-estilos.tex macros.tex)
forzar=false
archivos=()

for arg in "$@"; do
  case "$arg" in
    --todas) forzar=true ;;
    *) archivos+=("$arg"); forzar=true ;;
  esac
done

if [ ${#archivos[@]} -eq 0 ]; then
  while IFS= read -r f; do archivos+=("$f"); done \
    < <(find capitulos -path '*/figuras/*.tex' | sort)
fi

desactualizada() {
  local tex="$1" svg="${1%.tex}.svg" pdf="${1%.tex}.pdf"
  local oscuro="${1%.tex}-oscuro.svg"
  [ ! -f "$svg" ] || [ ! -f "$pdf" ] || [ ! -f "$oscuro" ] && return 0
  for dep in "$tex" "${compartidos[@]}"; do
    [ "$dep" -nt "$svg" ] && return 0
  done
  return 1
}

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# compilar JOBNAME CODIGO_TEX
compilar() {
  TEXINPUTS="$raiz:" lualatex -interaction=nonstopmode -halt-on-error \
    -output-directory="$tmp" -jobname="$1" "$2" > "$tmp/$1.salida" \
    || { cat "$tmp/$1.salida"; exit 1; }
}

n=0
for tex in "${archivos[@]}"; do
  if ! $forzar && ! desactualizada "$tex"; then
    continue
  fi
  nombre="$(basename "${tex%.tex}")"
  dir="$(dirname "$tex")"
  echo "figura: $tex"
  compilar "$nombre" "\\input{$tex}"
  compilar "$nombre-oscuro" "\\def\\modooscuro{}\\input{$tex}"
  cp "$tmp/$nombre.pdf" "$dir/$nombre.pdf"
  pdftocairo -svg "$tmp/$nombre.pdf" "$dir/$nombre.svg"
  pdftocairo -svg "$tmp/$nombre-oscuro.pdf" "$dir/$nombre-oscuro.svg"
  n=$((n + 1))
done

echo "figuras compiladas: $n"
