## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install kafka bitnami/kafka
```

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm search repo kafka
$ helm repo update

$ mkdir -p templates/kafka
$ helm show values bitnami/kafka > templates/kafka/kafka-values.yaml

$ helm -n geek-apps uninstall kafka 
$ helm -n geek-apps install kafka bitnami/kafka \
    --set global.storageClass=nfs-csi \
    --set persistence.enabled=true \
    --set persistence.size=8Gi \
    --set volumePermissions.enabled=true \
    --set replicaCount=3 \
    --set zookeeper.enabled=false \
    --set externalZookeeper.servers="zookeeper-0.zookeeper-headless:2181\,zookeeper-1.zookeeper-headless:2181\,zookeeper-2.zookeeper-headless:2181"

$ kubectl get pods -w --namespace geek-apps -o wide
```


```bash  
$ kubectl run kafka-client --restart='Never' --image docker.io/bitnami/kafka:2.8.1-debian-10-r0 --namespace geek-apps --command -- sleep infinity
```

#### Producer

```bash
$ kubectl exec --tty -i kafka-client --namespace geek-apps -- bash
$ kafka-console-producer.sh \
    --broker-list kafka-0.kafka-headless:9092,kafka-1.kafka-headless:9092,kafka-2.kafka-headless:9092 \
    --topic test
```

#### Consumer

```bash
$ kubectl exec --tty -i kafka-client --namespace geek-apps -- bash
$ kafka-console-consumer.sh \
    --bootstrap-server kafka.geek-apps.svc.cluster.local:9092 \
    --topic test \
    --from-beginning
```
