#### [pulsar](https://hub.docker.com/r/apachepulsar/pulsar-standalone/tags)

##### docker-compose.yml

```yaml
version: '3'
services:
    pulsar:
        image: apachepulsar/pulsar-standalone:latest
        container_name: pulsar
        network_mode: bridge
        restart: always
        tty: true
        ports:
            - 6650:6650
            - 8080:8080
        volumes:
            - /data/pulsar/logs:/pulsar/logs
```