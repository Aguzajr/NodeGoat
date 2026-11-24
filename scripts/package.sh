#!/usr/bin/env bash
# Genera entrega/PAI4-ST22.zip y avisa si detecta posibles credenciales.
set -euo pipefail
cd "$(dirname "$0")/../.."
TEAM="${TEAM:-ST22}"   # cambiar si el número de equipo es otro

echo "== Buscando posibles credenciales =="
if grep -rEIn --exclude-dir={.git,node_modules,.venv} --exclude=package.sh \
   -e 'AKIA[0-9A-Z]{16}' -e 'ghp_[A-Za-z0-9]{36}' -e 'Token [0-9a-f]{40}' \
   -e '(api[_-]?key|secret|password)\s*[:=]\s*["'\'']?[A-Za-z0-9/+_-]{12,}' \
   app defectdojo evidence report docs; then
  echo "!! Posibles credenciales encontradas. Revisa antes de entregar." >&2
  exit 1
fi

OUT="entrega/PAI4-${TEAM}.zip"
rm -f "$OUT"
zip -r "$OUT" report/*.pdf app/.github app/security-config app/scripts defectdojo evidence docs/diagramas \
    -x '*.gitkeep'
echo "Creado $OUT"
