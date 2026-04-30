#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

cleanup() {
  echo "Nettoyage Docker Compose..."
  docker compose -f compose.yml down -v --remove-orphans >/dev/null 2>&1 || true
  docker compose -f compose.yml -f compose.qualif.yml down -v --remove-orphans >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "1. Vérification des prérequis"
command -v java >/dev/null || { echo "Java 21 est requis"; exit 1; }
command -v docker >/dev/null || { echo "Docker est requis"; exit 1; }
docker compose version >/dev/null || { echo "Docker Compose v2 est requis"; exit 1; }

echo "2. Tests Maven avec H2"
./mvnw -B clean verify -Dspring.profiles.active=test

echo "3. Test Docker Compose en mode dev avec H2"
cp env/.env.dev.example .env
docker compose -f compose.yml up -d --build
./scripts/wait-http.sh http://localhost:8080/actuator/health 120
curl -fsS http://localhost:8080/api/products
docker compose -f compose.yml down -v --remove-orphans

echo "4. Test Docker Compose en mode qualif avec PostgreSQL"
cp env/.env.qualif.example .env
docker compose -f compose.yml -f compose.qualif.yml up -d --build
./scripts/wait-http.sh http://localhost:8080/actuator/health 180
curl -fsS http://localhost:8080/api/products
curl -fsS -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Manual deploy product","quantity":10}'
docker compose -f compose.yml -f compose.qualif.yml down -v --remove-orphans

echo "5. Test optionnel du déploiement Ansible local"
if command -v ansible-playbook >/dev/null; then
  pushd ansible >/dev/null
  ansible-galaxy collection install -r requirements.yml
  ansible-playbook --syntax-check playbooks/deploy-compose.yml
  ansible-playbook playbooks/deploy-compose.yml --limit local
  popd >/dev/null

  ./scripts/wait-http.sh http://localhost:8082/actuator/health 120
  curl -fsS http://localhost:8082/api/products

  pushd ansible >/dev/null
  ansible-playbook playbooks/stop-compose.yml --limit local
  popd >/dev/null
else
  echo "Ansible non installé : étape Ansible ignorée."
fi

echo "Déploiement manuel testé avec succès."
