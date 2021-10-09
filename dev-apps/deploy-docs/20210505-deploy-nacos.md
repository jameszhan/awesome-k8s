
[Kubernetes Nacos](https://nacos.io/zh-cn/docs/use-nacos-with-kubernetes.html)

```sql
CREATE DATABASE IF NOT EXISTS nacos DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON nacos.* TO deploy@'192.168.1.%' IDENTIFIED BY 'YOUR-PASSWORD' WITH GRANT OPTION;
```

```bash
$ kubectl apply -f templates/nacos/nacos-quick-start.yaml
$ for i in 0 1 2; do echo nacos-$i; kubectl exec -n geek-apps nacos-$i -- cat conf/cluster.conf; done
$ for i in 0 1 2; do echo nacos-$i; kubectl exec -n geek-apps nacos-$i -- curl -X GET "http://localhost:8848/nacos/v1/ns/raft/state"; done
```

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nacos-ingress
  namespace: geek-apps
  annotations:
    nginx.ingress.kubernetes.io/app-root: /nacos
spec:
  tls:
  - hosts:
      - nacos.zizhizhan.com
    secretName: star.zizhizhan.com-tls
  rules:
  - host: nacos.zizhizhan.com
    http:
      paths:
      - backend:
          service:
            name: nacos-headless
            port:
              number: 8848
        path: /
        pathType: Prefix
EOF
```

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: nacos-service
  namespace: geek-apps
  labels:
    app: nacos-service
spec:
  selector:
    app: nacos
  ports:
    - name: http
      port: 8848
      targetPort: 8848
  externalIPs:
    - 192.168.1.161
EOF
```

```bash
# 服务注册
$ curl -X POST 'http://192.168.1.161:8848/nacos/v1/ns/instance?serviceName=nacos.naming.serviceName&ip=20.18.7.10&port=8080'

# 服务发现
$ curl -X GET 'http://192.168.1.161:8848/nacos/v1/ns/instance/list?serviceName=nacos.naming.serviceName'

# 发布配置
$ curl -X POST "http://192.168.1.161:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test&content=HelloWorld"

# 获取配置
$ curl -X GET "http://192.168.1.161:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test"
```
