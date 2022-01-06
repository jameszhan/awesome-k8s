## 创建`deployment`和`service`

```bash
$ kubectl create configmap gophernotes-pass -n geek-apps --from-file=templates/gophernotes/jupyter_notebook_config.json

$ cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: gophernotes
  namespace: geek-apps
spec:
  serviceName: gophernotes
  replicas: 1
  template:
    metadata:
      labels:
        app: gophernotes
      annotations:
        pod.alpha.kubernetes.io/initialized: "true"
    spec:
      containers:
        - name: gophernotes
          imagePullPolicy: IfNotPresent
          image: gopherdata/gophernotes
          workingDir: /root/notebooks
          volumeMounts:
            - mountPath: /root/notebooks
              name: data-vol
            - mountPath: "/root/.jupyter/jupyter_notebook_config.json"
              subPath: jupyter_notebook_config.json
              name: gophernotes-pass-vol
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
      volumes:
        - name: gophernotes-pass-vol
          configMap:
            name: gophernotes-pass
  volumeClaimTemplates:
    - metadata:
        labels:
          app.kubernetes.io/instance: gophernotes
          app.kubernetes.io/name: gophernotes
        name: data-vol
      spec:
        accessModes:
          - ReadWriteMany
        resources:
          requests:
            storage: 16Gi
        storageClassName: cephfs
        volumeMode: Filesystem
  selector:
    matchLabels:
      app: gophernotes
EOF

$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: gophernotes
  namespace: geek-apps
  labels:
    app.kubernetes.io/name: gophernotes
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app: gophernotes
EOF

$ kubectl port-forward -n geek-apps service/gophernotes 8080:80 --address=0.0.0.0
$ open http://localhost:8080

$ cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: gophernotes-ingress
  namespace: geek-apps
spec:
  ingressClassName: nginx
  tls:
  - hosts:
      - go.zizhizhan.com
    secretName: star.zizhizhan.com-tls
  rules:
  - host: go.zizhizhan.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: gophernotes
            port:
              number: 80
EOF
```

打开`https://go.zizhizhan.com`，访问`Jupyter Notebook`服务。

### 更新密码

#### 进入容器

```bash
$ kubectl exec -it $(kubectl get pods -n geek-apps | grep gophernotes | awk '{print $1}') -n geek-apps -- sh
```

#### 生成密码

```bash
$ jupyter notebook --generate-config
$ vi /home/jovyan/.jupyter/jupyter_lab_config.py
```

```bash
$ jupyter notebook password
```