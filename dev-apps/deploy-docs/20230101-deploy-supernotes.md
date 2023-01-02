
#### 准备存储卷

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:  
  name: supernotes-pv
  labels:
    pv: supernotes
spec:  
  capacity:    
    storage: 32Gi  
  accessModes:    
    - ReadWriteMany  
  persistentVolumeReclaimPolicy: Retain  
  storageClassName: nfs
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:    
    path: /volume1/shared/kickstart/supernotes/media
    server: 192.168.1.6
EOF

$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: supernotes-pvc
  namespace: geek-apps
spec:
  storageClassName: nfs
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 32Gi
  selector:
    matchLabels:
      pv: supernotes
EOF

$ kubectl get pv
$ kubectl get pvc -n geek-apps
```

#### 准备环境变量

```bash
$ kubectl delete cm supernotes-env -n geek-apps
$ kubectl create configmap supernotes-env -n geek-apps --from-file=.env
$ kubectl get configmap supernotes-env -n geek-apps -o yaml
```

#### 创建部署和Service

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: supernotes
  namespace: geek-apps
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: supernotes
      app.kubernetes.io/instance: supernotes
  template:
    metadata:
      labels:
        app.kubernetes.io/name: supernotes
        app.kubernetes.io/instance: supernotes
    spec:
      initContainers:
        - name: fix-permissions
          image: debian:bullseye-slim
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - mountPath: /app/supernotes/media
              name: supernotes-vol
          securityContext:
            runAsUser: 0
          command: ['/bin/sh', '-c']
          args: ['chown -R 1026:100 /app/supernotes/media && chmod ug+rwx /app/supernotes/media']
      containers:
        - name: supernotes
          image: "jameszhan/supernotes:0.1.0"
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - mountPath: "/app/supernotes/media"
              name: supernotes-vol
            - mountPath: "/app/.env"
              subPath: .env
              name: supernotes-env-vol
          ports:
            - name: http
              containerPort: 8000
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /health
              port: http
              httpHeaders:
                - name: Host
                  value: sn.zizhizhan.com:8000
          readinessProbe:
            httpGet:
              path: /health
              port: http
              httpHeaders:
                - name: Host
                  value: sn.zizhizhan.com:8000
          resources:
            requests:
              cpu: 2000m
              memory: 2048Mi
          env:
            - name: DJANGO_SETTINGS_MODULE
              value: "settings.production"
      volumes:
        - name: supernotes-vol
          persistentVolumeClaim:
            claimName: supernotes-pvc
        - name: supernotes-env-vol
          configMap:
            name: supernotes-env
EOF

$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: supernotes
  namespace: geek-apps
  labels:
    app.kubernetes.io/name: supernotes
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: supernotes
    app.kubernetes.io/instance: supernotes
EOF

$ cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: supernotes
  namespace: geek-apps
spec:
  ingressClassName: nginx
  tls:
  - hosts:
      - sn.zizhizhan.com
    secretName: star.zizhizhan.com-tls
  rules:
  - host: sn.zizhizhan.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: supernotes
            port:
              number: 80
EOF
```

