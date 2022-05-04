


```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpbin-local
  namespace: geek-apps
spec:
  replicas: 2
  selector:
    matchLabels:
      app.kubernetes.io/name: httpbin-local
      app.kubernetes.io/instance: httpbin-local-0.0.1
  template:
    metadata:
      labels:
        app.kubernetes.io/name: httpbin-local
        app.kubernetes.io/instance: httpbin-local-0.0.1
    spec:
      containers:
      - name: httpbin-local
        image: kennethreitz/httpbin
        imagePullPolicy: IfNotPresent
        ports:
        - name: http
          containerPort: 80
          protocol: TCP
        livenessProbe:
          httpGet:
            path: /
            port: http
        readinessProbe:
          httpGet:
            path: /
            port: http
        resources:
          requests:
            cpu: 200m
            memory: 256Mi

---
apiVersion: v1
kind: Service
metadata:
  name: httpbin-local
  namespace: geek-apps
  labels:
    app.kubernetes.io/name: httpbin-local
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: httpbin-local
    app.kubernetes.io/instance: httpbin-local-0.0.1

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: httpbin-local
  namespace: geek-apps
spec:
  ingressClassName: nginx
  tls:
  - hosts:
      - httpbin.zizhizhan.com
    secretName: star.zizhizhan.com-tls
  rules:
  - host: httpbin.zizhizhan.com
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: httpbin-local
            port:
              number: 80
EOF
```