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

## Conventions
- *Docker Compose* file sections order `x-templates`, `services`, `networks`, `volumes`, `secrets` and `deploy`
- Use underscore `_` for middleware name
- Do not use double quotes for Compose values
- Use `example.com` (RFC 2606 reserved for testing and documentation)

## Stacks
### Management
```shell
docker stack deploy --resolve-image changed -c management-stack.yml management
```

#### Portainer
[http://localhost:9000](http://localhost:9000) and [http://localhost/portainer](http://localhost/portainer)

### Proxy
```shell
docker stack deploy --resolve-image changed -c proxy-stack.yml proxy
```

#### Traefik
http://localhost:8080

### DB
```shell
docker stack deploy --resolve-image changed -c db-stack.yml db
```

#### PostgreSQL
##### Secrets
##### Secrets
````shell
echo "postgres" | docker secret create postgres-user -
````
````shell
echo "postgres" | docker secret create postgres-password -
````

#### MongoDB
##### Secrets
````shell
openssl rand -base64 756 | docker secret create mongo-keyfile -
````
```shell
echo "mongo" | docker secret create mongo-username -
```
```shell
echo "mongo" | docker secret create mongo-password -
```

#### Redis
##### Secrets
```shell
echo "redis" | docker secret create redis-username -
```
```shell
echo "redis" | docker secret create redis-password -
```

### Auth
```shell
docker stack deploy --resolve-image changed -c auth-stack.yml auth
```

#### Keycloak
[http://localhost/keycloak/auth/](http://localhost/keycloak/auth/)

##### Secrets
```shell
echo "keycloak" | docker secret create keycloak-admin-username -
```
```shell
echo "keycloak" | docker secret create keycloak-admin-password -
```

### SMTP
```shell
docker stack deploy --resolve-image changed -c smtp-stack.yml smtp
```

#### MailDev
[http://localhost:1080](http://localhost:1080)

##### Secrets
```shell
echo "maildev" | docker secret create maildev-username -
```

```shell
echo "maildev" | docker secret create maildev-password -
```

### Automation
```shell
docker stack deploy --resolve-image changed -c automation-stack.yml automation
```

#### n8n
[http://localhost:5678](http://localhost:5678)