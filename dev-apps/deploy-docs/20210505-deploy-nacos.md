
```sql
CREATE DATABASE IF NOT EXISTS nacos DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON nacos.* TO deploy@'192.168.1.%' IDENTIFIED BY 'YOUR-PASSWORD' WITH GRANT OPTION;
```

```bash
$ kubectl apply -f templates/nacos/nacos-pvc-ceph.yaml

$ for i in 0 1 2; do echo nacos-$i; kubectl exec -n geek-apps nacos-$i -- cat conf/cluster.conf; done
$ for i in 0 1 2; do echo nacos-$i; kubectl exec -n geek-apps nacos-$i -- curl -X GET "http://localhost:8848/nacos/v1/ns/raft/state"; done
```

#### 配置`Ingress`和`Cluster Service`

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nacos-ingress
  namespace: geek-apps
spec:
  ingressClassName: nginx
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

---
apiVersion: v1
kind: Service
metadata:
  name: nacos
  namespace: geek-apps
  labels:
    app: nacos
spec:
  selector:
    app: nacos
  ports:
    - name: http
      port: 8848
      targetPort: 8848
EOF
```

#### 测试服务

```bash
$ nc -vz nacos.geek-apps.svc.cluster.local 8848

# 服务注册
$ curl -X POST 'http://nacos.geek-apps.svc.cluster.local:8848/nacos/v1/ns/instance?serviceName=nacos.naming.serviceName&ip=20.18.7.10&port=8080'

# 服务发现
$ curl -X GET 'http://nacos.geek-apps.svc.cluster.local:8848/nacos/v1/ns/instance/list?serviceName=nacos.naming.serviceName'

# 发布配置
$ curl -X POST "http://nacos.geek-apps.svc.cluster.local:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test&content=HelloWorld"

# 获取配置
$ curl -X GET "http://nacos.geek-apps.svc.cluster.local:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test"

# nacos/nacos
$ open https://nacos.zizhizhan.com
```

- [Kubernetes Nacos](https://nacos.io/zh-cn/docs/use-nacos-with-kubernetes.html)
- [Nacos k8s](https://github.com/nacos-group/nacos-k8s.git)