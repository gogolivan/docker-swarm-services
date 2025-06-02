# Docker Swarm Services

## Setup
### Init
```shell
docker swarm init --task-history-limit=0
```

### List
```shell
docker stack ls
```

## Stacks
### Management
```shell
docker stack deploy --resolve-image changed -c management-stack.yml management
```

- [Portainer](http://localhost:9000)

### Proxy
```shell
docker stack deploy --resolve-image changed -c proxy-stack.yml proxy
```

- [Traefik](http://localhost:8080)

### DB
```shell
docker stack deploy --resolve-image changed -c db-stack.yml db
```

- PostgreSQL
- MongoDB

### Auth
```shell
docker stack deploy --resolve-image changed -c auth-stack.yml auth
```

- [Keycloak](http://localhost/keycloak/auth/)