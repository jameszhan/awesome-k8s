## TL;DR

```bash
$ sysctl -w net.core.rmem_max=2500000
$ sysctl -w net.core.wmem_max=2500000
```

[](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/deploy-tunnels/deployment-guides/kubernetes/)

```bash
$ docker run --rm cloudflare/cloudflared:latest tunnel --metrics 0.0.0.0:2000 run --token <token value>

$ mkdir -p templates/cloudflare/
$ cat <<EOF > templates/cloudflare/cloudflared-deployment.yml
cat <<EOF | kubectl apply -f -
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
        - --no-autoupdate
        - tunnel
        - --metrics
        - 0.0.0.0:2000
        - run
        args:
        - --token
        - eyJhIjoiY2YzN2JmZTVlZTc4MDIyZDkwOTljNTc2NzNlNTBkYmMiLCJ0IjoiNjliNTlmYjUtNDZiNi00YTRkLTg5YTEtNmU3YmI0OTQ0YjRjIiwicyI6Ik1qTXhNekE1TkRJdFpEQTVZeTAwWkRjMUxXRXpOalF0TUdFMFpETmhZemswTXpFMSJ9
        image: cloudflare/cloudflared:latest
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

sudo cloudflared service install eyJhIjoiY2YzN2JmZTVlZTc4MDIyZDkwOTljNTc2NzNlNTBkYmMiLCJ0IjoiMDVmYTM3MzItMDg2MC00ZjBmLWJlMWEtZWQ3MjQwY2QwMzBkIiwicyI6Ik5qWm1ZVE13Wm1NdFpURXlNeTAwTVdSbExUazJNbU10T0RrM05UUTVaRFZtTjJVNCJ9
