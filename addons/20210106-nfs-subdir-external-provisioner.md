## TL;DR

```bash
$ helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

$ helm repo update
$ helm search repo nfs

$ mkdir -p templates/nfs-subdir-external-provisioner
$ helm show values nfs-subdir-external-provisioner/nfs-subdir-external-provisioner > templates/nfs-subdir-external-provisioner-values.yaml

$ helm install -f templates/nfs-subdir-external-provisioner-values.yaml -n kube-system nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner
```

`k8s.gcr.io/sig-storage/nfs-subdir-external-provisioner` 替换为 `registry.cn-shanghai.aliyuncs.com/hybfkuf/nfs-subdir-external-provisioner`

```bash
$ kubectl get sc
NAME         PROVISIONER                                     RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs-client   cluster.local/nfs-subdir-external-provisioner   Delete          Immediate           true                   113s
nfs-csi      nfs.csi.k8s.io                                  Delete          Immediate           false                  24h

# 更新安装
$ helm upgrade --install -f templates/nfs-subdir-external-provisioner/values.yaml -n kube-system nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner
```

