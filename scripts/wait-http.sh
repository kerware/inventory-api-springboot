#!/usr/bin/env bash
set -euo pipefail

URL="${1:?URL attendue en premier argument}"
TIMEOUT_SECONDS="${2:-120}"
START_TS="$(date +%s)"

echo "Attente de $URL pendant ${TIMEOUT_SECONDS}s maximum..."

while true; do
  if curl -fsS "$URL" >/dev/null 2>&1; then
    echo "OK: $URL répond."
    exit 0
  fi

  NOW_TS="$(date +%s)"
  ELAPSED=$((NOW_TS - START_TS))

  if [ "$ELAPSED" -ge "$TIMEOUT_SECONDS" ]; then
    echo "ERREUR: $URL ne répond pas après ${TIMEOUT_SECONDS}s." >&2
    exit 1
  fi

  sleep 3
done
