

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
```