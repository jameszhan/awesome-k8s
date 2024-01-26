## TL;DR

```bash
$ sysctl -w net.core.rmem_max=2500000
$ sysctl -w net.core.wmem_max=2500000
```

```bash
$ docker run --rm cloudflare/cloudflared:latest tunnel --metrics 0.0.0.0:2000 run --token <token value>

$ mkdir -p templates/cloudflare/
$ cat <<EOF > templates/cloudflare/cloudflared-deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: cloudflared
  name: cloudflared-deployment
  namespace: kube-system
spec:
  replicas: 2
  selector:
    matchLabels:
      pod: cloudflared
  template:
    metadata:
      labels:
        pod: cloudflared
    spec:
      containers:
      - command:
        - cloudflared
        - tunnel
        - --metrics
        - 0.0.0.0:2000
        - run
        - --token
        - <token value>
        image: cloudflare/cloudflared:2023.10.0
        name: cloudflared
        livenessProbe:
          httpGet:
            path: /ready
            port: 2000
          failureThreshold: 1
          initialDelaySeconds: 10
          periodSeconds: 10
EOF

$ kubectl create -f templates/cloudflare/cloudflared-deployment.yml
```



