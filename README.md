# inventory-api

Application Spring Boot pédagogique pour illustrer :

- configuration par profils `dev`, `qualif`, `prod` ;
- H2 en développement ;
- PostgreSQL en qualification / production ;
- Docker et Docker Compose ;
- Ansible avec `community.docker.docker_compose_v2` ;
- GitHub Actions pour tests H2, PostgreSQL, Docker Compose et Ansible.

## Commandes principales

### Tests locaux

```bash
./mvnw clean verify -Dspring.profiles.active=test
```

### Démarrage dev avec H2

```bash
cp env/.env.dev.example .env
docker compose -f compose.yml up -d --build
curl http://localhost:8080/actuator/health
```

### Démarrage qualif avec PostgreSQL

```bash
cp env/.env.qualif.example .env
docker compose -f compose.yml -f compose.qualif.yml up -d --build
curl http://localhost:8080/actuator/health
```

### Déploiement Ansible local

```bash
cd ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook playbooks/deploy-compose.yml --limit local
```

### Test manuel complet

```bash
./scripts/test-manual-deploy.sh
```
