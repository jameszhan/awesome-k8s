

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:  
  name: calibre-web-books-pv
  labels:
    pv: calibre-web-books-pv
spec:  
  capacity:    
    storage: 128Gi  
  accessModes:    
    - ReadOnlyMany  
  persistentVolumeReclaimPolicy: Retain  
  storageClassName: nfs
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:    
    path: /volume1/shared/appdata/geek-apps/books
    server: 192.168.1.6

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: calibre-web-books-pvc
  namespace: geek-apps
spec:
  storageClassName: nfs
  accessModes:
    - ReadOnlyMany
  resources:
    requests:
      storage: 128Gi
  selector:
    matchLabels:
      pv: calibre-web-books-pv
EOF

$ cat <<EOF | kubectl apply -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: calibre-web-pvc
  namespace: geek-apps
  annotations:
    nfs.io/storage-path: "calibre-web-config"
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
  name: calibre-web
  namespace: geek-apps
  labels:
    app: calibre-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: calibre-web
  template:
    metadata:
      labels:
        app: calibre-web
    spec:
      containers:
      - name: calibre-web
        image: lscr.io/linuxserver/calibre-web:latest
        imagePullPolicy: IfNotPresent    
        ports:
        - containerPort: 8083
          name: web
          protocol: TCP
        env:
        - name: TZ
          value: "Asia/Shanghai"
        - name: PUID
          value: "0"
        - name: PGID
          value: "0"
        - name: OAUTHLIB_RELAX_TOKEN_SCOPE
          value: "1" 
        volumeMounts:
        - mountPath: "/config"
          name: calibre-config-vol
        - mountPath: "/books"
          name: calibre-library-vol
      volumes:
      - name: calibre-config-vol
        persistentVolumeClaim:
          claimName: calibre-web-pvc
      - name: calibre-library-vol
        persistentVolumeClaim:
          claimName: calibre-web-books-pvc
EOF

$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: calibre-service
  namespace: geek-apps
  labels:
    app: calibre-web
spec:
  type: ClusterIP
  ports:
  - targetPort: 8083
    port: 8083
    name: web
  selector:
    app:  calibre-web
EOF
```
admin/admin123


```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: calibre-web-ingress
  namespace: geek-apps
spec:
  ingressClassName: nginx
  tls:
  - hosts:
      - pma.zizhizhan.com
    secretName: star.zizhizhan.com-tls
  rules:
  - host: books.zizhizhan.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: calibre-service
            port:
              number: 8083
EOF
``` 