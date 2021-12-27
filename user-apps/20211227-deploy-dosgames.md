# `Kubernetes`部署`DOSGames`

#### 参考资料

- [DOSGames](https://github.com/jameszhan/dosgames-web)
- [dosgames-web docker image](https://hub.docker.com/repository/docker/jameszhan/dosgames-web)

## 部署`DOSGames`

### 利用`NAS`挂载游戏资源文件

#### 准备`PV`和`PVC`

```bash
$ cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: PersistentVolume
metadata:  
  name: dosgames-pv
  labels:
    pv: dosgames-pv
spec:  
  capacity:    
    storage: 64Gi  
  accessModes:    
    - ReadOnlyMany  
  persistentVolumeReclaimPolicy: Retain  
  storageClassName: nfs
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:    
    path: /volume1/shared/kickstart/games
    server: 192.168.1.6

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dosgames-pvc
  namespace: geek-apps
spec:
  storageClassName: nfs
  accessModes:
    - ReadOnlyMany
  resources:
    requests:
      storage: 64Gi
  selector:
    matchLabels:
      pv: dosgames-pv
EOF

$ kubectl get pvc -n geek-apps
```

#### 准备部署描述文件

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dosgames-web
  namespace: geek-apps
spec:
  replicas: 2
  selector:
    matchLabels:
      app.kubernetes.io/name: dosgames-web
      app.kubernetes.io/instance: dosgames-web-0.0.1
  template:
    metadata:
      labels:
        app.kubernetes.io/name: dosgames-web
        app.kubernetes.io/instance: dosgames-web-0.0.1
    spec:
      initContainers:
      - name: fix-permissions
        image: debian:bullseye-slim
        imagePullPolicy: IfNotPresent
        volumeMounts:
        - mountPath: /app/static/games/bin
          name: dosgames-pvc-vol
        securityContext:
          runAsUser: 0
        command: ['/bin/sh', '-c']
        args: ['chown -R 1000:0 /app/static/games/bin && chmod ugo+r /app/static/games/bin']
      containers:
      - name: dosgames-web
        image: jameszhan/dosgames-web:0.0.1
        imagePullPolicy: IfNotPresent
        volumeMounts:
        - mountPath: /app/static/games/bin
          name: dosgames-pvc-vol
        ports:
        - name: http
          containerPort: 8080
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
      volumes:
      - name: dosgames-pvc-vol
        persistentVolumeClaim:
          claimName: dosgames-pvc
EOF
```

### 利用`CORS`挂载游戏资源文件

#### 准备部署描述文件

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dosgames-web
  namespace: geek-apps
spec:
  replicas: 2
  selector:
    matchLabels:
      app.kubernetes.io/name: dosgames-web
      app.kubernetes.io/instance: dosgames-web-0.0.1
  template:
    metadata:
      labels:
        app.kubernetes.io/name: dosgames-web
        app.kubernetes.io/instance: dosgames-web-0.0.1
    spec:
      containers:
      - name: dosgames-web
        image: jameszhan/dosgames-web:0.0.1
        imagePullPolicy: IfNotPresent
        env:
        - name: GAME_LOAD_PATH
          value: https://dl.zizhizhan.com:8443/games
        ports:
        - name: http
          containerPort: 8080
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
EOF
```

## 创建`Service`和`Ingress`

### 创建`Service`

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: dosgames-web
  namespace: geek-apps
  labels:
    app.kubernetes.io/name: dosgames-web
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: dosgames-web
    app.kubernetes.io/instance: dosgames-web-0.0.1
EOF

$ kubectl port-forward --namespace geek-apps service/dosgames-web 8080:80
$ open http://localhost:8080
```

### 创建`Ingress`

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dosgames-web
  namespace: geek-apps
spec:
  ingressClassName: nginx
  tls:
  - hosts:
      - games.zizhizhan.com
    secretName: star.zizhizhan.com-tls
  rules:
  - host: games.zizhizhan.com
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: dosgames-web
            port:
              number: 80
EOF

$ open https://games.zizhizhan.com
```