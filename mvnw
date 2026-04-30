#!/usr/bin/env bash
set -euo pipefail

if command -v mvn >/dev/null 2>&1; then
  exec mvn "$@"
fi

echo "Maven n'est pas installé. Installez Maven 3.9+ ou ajoutez un wrapper Maven complet avec ./mvnw -N wrapper:wrapper." >&2
exit 1
