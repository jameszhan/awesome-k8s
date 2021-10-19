
#### 下载代码

```bash
$ git clone https://github.com/kubernetes-csi/csi-driver-nfs.git

$ cd csi-driver-nfs/deploy
```

#### 替换`k8s.gcr.io`镜像

- `k8s.gcr.io/sig-storage/livenessprobe:v2.4.0` -> `registry.cn-hangzhou.aliyuncs.com/google_containers/livenessprobe:v2.4.0`
- `k8s.gcr.io/sig-storage/csi-provisioner:v2.2.2` -> `registry.cn-hangzhou.aliyuncs.com/google_containers/csi-provisioner:v2.2.2`
- `k8s.gcr.io/sig-storage/csi-node-driver-registrar:v2.3.0` -> `registry.cn-hangzhou.aliyuncs.com/google_containers/csi-node-driver-registrar:v2.3.0`

```bash
$ kubectl apply -f rbac-csi-nfs-controller.yaml
$ kubectl apply -f csi-nfs-driverinfo.yaml
$ kubectl apply -f csi-nfs-controller.yaml
$ kubectl apply -f csi-nfs-node.yaml

$ kubectl -n kube-system get pod -o wide -l app=csi-nfs-controller
$ kubectl -n kube-system get pod -o wide -l app=csi-nfs-node
```

#### 创建`StorageClass`

```bash
$ cat <<EOF | kubectl create -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-csi
provisioner: nfs.csi.k8s.io
parameters:
  server: 192.168.1.6
  share: /volume1/shared/k8s
reclaimPolicy: Delete
volumeBindingMode: Immediate
mountOptions:
  - hard
  - nfsvers=4.1
EOF

$ kubectl get sc nfs-csi -o yaml
```