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

#### MongoDB
##### Replica Set
###### Keyfile
````shell
openssl rand -base64 756 | docker secret create mongo-keyfile -
````

##### Credentials
```shell
echo "mongo" | docker secret create mongo-username -
```
```shell
echo "mongo" | docker secret create mongo-password -
```

### Auth
```shell
docker stack deploy --resolve-image changed -c auth-stack.yml auth
```

#### Keycloak
[http://localhost/keycloak/auth/](http://localhost/keycloak/auth/)

##### Credentials
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

##### Credentials
```shell
echo "maildev" | docker secret create maildev-username -
```

```shell
echo "maildev" | docker secret create maildev-password -
```

## Conventions
- Underscore for middleware name
- No Double quotes for values