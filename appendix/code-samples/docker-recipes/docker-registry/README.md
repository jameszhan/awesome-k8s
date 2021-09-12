#### [Docker Registry](https://hub.docker.com/_/registry/)

#### [docker-registry-frontend](https://hub.docker.com/r/konradkleine/docker-registry-frontend)

##### docker-compose.yml

```yaml
version: '3.1'
services:
  frontend:
    image: konradkleine/docker-registry-frontend:v2
    ports:
      - 8088:80
    volumes:
      - ./certs/frontend.crt:/etc/apache2/server.crt:ro
      - ./certs/frontend.key:/etc/apache2/server.key:ro
    environment:
      - ENV_DOCKER_REGISTRY_HOST=172.20.8.205
      - ENV_DOCKER_REGISTRY_PORT=5000
````

