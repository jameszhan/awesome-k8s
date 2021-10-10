#### NAS服务器设置用户

```bash
$ sudo adduser -G users -D -H -u 1000 -s /sbin/nologin -g 'user for jupyter-notebook' jovyan
$ sudo chown -R jovyan:users jupyter
```

#### 准备存储卷

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:  
  name: jupyterlab-pv
  labels:
    pv: jupyterlab
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
    path: /volume1/shared/jupyterlab
    server: 192.168.1.6
EOF

$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jupyterlab-pvc
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
      pv: jupyterlab
EOF

$ kubectl get pv
$ kubectl get pvc -n geek-apps
```

#### 配置密码

```bash
$ kubectl create configmap jupyterlab-pass -n geek-apps --from-file=templates/jupyterlab/jupyter_server_config.json
$ kubectl create configmap jupyterlab-conf -n geek-apps --from-file=templates/jupyterlab/jupyter_server_config.py
$ kubectl get configmap jupyterlab-pass -n geek-apps -o yaml
$ kubectl get configmap jupyterlab-conf -n geek-apps -o yaml
```

#### 创建部署和Service

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jupyterlab-notebook
  namespace: geek-apps
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: jupyterlab-notebook
      app.kubernetes.io/instance: jupyterlab-notebook
  template:
    metadata:
      labels:
        app.kubernetes.io/name: jupyterlab-notebook
        app.kubernetes.io/instance: jupyterlab-notebook
    spec:
      containers:
        - name: jupyterlab-notebook
          image: "jameszhan/docker-jupyterlab:0.9"
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - mountPath: "/home/jovyan/notebooks"
              name: jupyterlab-pvc
            - mountPath: "/home/jovyan/.jupyter/jupyter_server_config.py"
              subPath: jupyter_server_config.py
              name: jupyterlab-conf-vol
            - mountPath: "/home/jovyan/.jupyter/jupyter_server_config.json"
              subPath: jupyter_server_config.json
              name: jupyterlab-pass-vol
          ports:
            - name: http
              containerPort: 8888
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
              cpu: 1000m
              memory: 1024Mi
          env:
            - name: JUPYTER_ENABLE_LAB
              value: "yes"
      volumes:
        - name: jupyterlab-pvc
          persistentVolumeClaim:
            claimName: jupyterlab-pvc
        - name: jupyterlab-conf-vol
          configMap:
            name: jupyterlab-conf
        - name: jupyterlab-pass-vol
          configMap:
            name: jupyterlab-pass
EOF

$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: jupyterlab-notebook
  namespace: geek-apps
  labels:
    app.kubernetes.io/name: jupyterlab-notebook
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: jupyterlab-notebook
    app.kubernetes.io/instance: jupyterlab-notebook
EOF

$ kubectl port-forward -n geek-apps service/jupyterlab-notebook 8080:80 --address=0.0.0.0

$ cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: jupyterlab-ingress
  namespace: geek-apps
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  tls:
  - hosts:
      - jupyter.zizhizhan.com
    secretName: star.zizhizhan.com-tls
  rules:
  - host: jupyter.zizhizhan.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: jupyterlab-notebook
            port:
              number: 80
EOF
```

打开`https://jupyter.zizhizhan.com:8443`，访问`Jupyter Notebook`服务。

### 更新密码

#### 进入容器

```bash
$ kubectl exec -it $(kubectl get pods -n geek-apps | grep jupyterlab-notebook | awk '{print $1}') -n geek-apps -- bash
```

#### 生成密码

```python
$ from jupyter_server.auth import passwd; passwd()
```

```bash
$ jupyter lab --generate-config
$ vi /home/jovyan/.jupyter/jupyter_lab_config.py
```

```bash
$ jupyter lab password
```

#### 配置SQL支持

```notebook
!pip install ipython-sql
!pip install psycopg2
!pip install mysqlclient
```

```notebook
%load_ext sql
%env DATABASE_URL postgresql://user:password@192.168.1.6/kb
%sql select version();
```