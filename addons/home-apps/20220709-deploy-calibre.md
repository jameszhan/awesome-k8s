```bash
$ echo -n 'Hello123456' > templates/calibre/calibre-password.txt

$ kubectl create secret -n geek-apps generic calibre-password \
    --from-file=PASSWORD=templates/calibre/calibre-password.txt
$ kubectl get secret calibre-password -n geek-apps -o yaml
```


```bash
$ cat <<EOF | kubectl apply -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: calibre-config-pvc
  namespace: geek-apps
  annotations:
    nfs.io/storage-path: "calibres"
spec:
  storageClassName: nfs-client
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 16Gi
EOF

$ cat <<EOF | kubectl apply -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: calibre-library-pvc
  namespace: geek-apps
  annotations:
    nfs.io/storage-path: "books"
spec:
  storageClassName: nfs-client
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 128Gi
EOF

$ cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: calibre-desktop
  namespace: geek-apps
  labels:
    app: calibre-desktop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: calibre-desktop
  template:
    metadata:
      labels:
        app: calibre-desktop
    spec:
      containers:
      - name: calibre-desktop
        image: lscr.io/linuxserver/calibre:latest
        imagePullPolicy: IfNotPresent    
        ports:
        - containerPort: 8080
          name: desktop
          protocol: TCP
        - containerPort: 8081
          name: http
          protocol: TCP
        env:
        - name: TZ
          value: "Asia/Shanghai"
        - name: PUID
          value: "1001"
        - name: PGID
          value: "1001"
        envFrom:
          - secretRef:
              name: calibre-password
        volumeMounts:
        - mountPath: "/config"
          name: calibre-config-vol
        - mountPath: "/books"
          name: calibre-library-vol
      volumes:
      - name: calibre-config-vol
        persistentVolumeClaim:
          claimName: calibre-config-pvc
      - name: calibre-library-vol
        persistentVolumeClaim:
          claimName: calibre-library-pvc
EOF

$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: calibre-desktop
  namespace: geek-apps
  labels:
    app: calibre-desktop
spec:
  type: ClusterIP
  ports:
  - targetPort: 8080
    port: 8080
    name: desktop
  - targetPort: 8081
    port: 8081
    name: http
  selector:
    app: calibre-desktop
EOF
```

abc/Hello123456
