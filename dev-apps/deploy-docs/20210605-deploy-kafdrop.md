- [Kafdrop – Kafka Web UI](https://github.com/obsidiandynamics/kafdrop)


```bash
$ git clone https://github.com/obsidiandynamics/kafdrop
$ cd kafdrop

$ helm template -n geek-apps kafdrop chart \
    --set image.tag=3.27.0 \
    --set kafka.brokerConnect=kafka:9092 \
    --set server.servlet.contextPath="/" \
    --set cmdArgs="--message.format=AVRO --schemaregistry.connect=http://localhost:8080" \
    --set jvm.opts="-Xms32M -Xmx1284M" > kafdrop-deploy.yaml

$ kubectl apply -f templates/kafdrop-deploy.yaml
```

```bash
$ open http://kafdrop.geek-apps.svc.cluster.local
```