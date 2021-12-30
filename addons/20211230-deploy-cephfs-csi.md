## TL;DR

## Deploy Ceph CSI CephFS

![CEPH FILE SYSTEM](https://gallery.zizhizhan.com:8443/images/virt/cephfs-architecture.svg)

### CREATE A CephFS

```bash
$ pveceph mds create
$ ceph mds stat

$ pveceph fs create --name k8s --pg_num 128 --add-storage

$ ceph fs ls
name: k8s, metadata pool: k8s_metadata, data pools: [k8s_data ]
```

### CONFIGURE CEPH-CSI

#### SETUP CEPH CLIENT AUTHENTICATION

```bash
$ ceph fs authorize k8s client.cephfs-k8s / rw
[client.cephfs-k8s]
	key = AQByw81hKgkLFBAAZYGEGFmsEU4+nAJ6C3OVAg==
$ ceph auth list
```

#### GENERATE CEPH-CSI CONFIGMAP

```bash
$ ceph mon dump
epoch 1
fsid 3a5cad60-a648-48aa-a281-21795b69d6b3
<...>
0: [v2:192.168.1.50:3300/0,v1:192.168.1.50:6789/0] mon.pve-5900hx
1: [v2:192.168.1.60:3300/0,v1:192.168.1.60:6789/0] mon.pve-5700u
```

> ceph-csi currently only supports the legacy V1 protocol.

```bash
$ mkdir -p templates/ceph-csi
$ kubectl create ns ceph-csi

$ cat <<EOF > templates/ceph-csi/csi-config-map.yaml
---
apiVersion: v1
kind: ConfigMap
data:
  config.json: |-
    [
      {
        "clusterID": "3a5cad60-a648-48aa-a281-21795b69d6b3",
        "monitors": [
          "192.168.1.50:6789",
          "192.168.1.60:6789"
        ]
      }
    ]
metadata:
  name: ceph-csi-config
EOF
$ kubectl apply -n ceph-csi -f templates/ceph-csi/csi-config-map.yaml

$ cat <<EOF > templates/ceph-csi/csi-kms-config-map.yaml
---
apiVersion: v1
kind: ConfigMap
data:
  config.json: |-
    {}
metadata:
  name: ceph-csi-encryption-kms-config
EOF
$ kubectl apply -n ceph-csi -f templates/ceph-csi/csi-kms-config-map.yaml

$ cat <<EOF > templates/ceph-csi/ceph-config-map.yaml
---
apiVersion: v1
kind: ConfigMap
data:
  ceph.conf: |
    [global]
    auth_cluster_required = cephx
    auth_service_required = cephx
    auth_client_required = cephx
  # keyring is a required key and its value should be empty
  keyring: |
metadata:
  name: ceph-config
EOF
$ kubectl apply -n ceph-csi -f templates/ceph-csi/ceph-config-map.yaml
```

#### GENERATE CEPH-CSI CEPHX SECRET

```bash
$ cat <<EOF > templates/ceph-csi-cephfs/csi-cephfs-secret.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: csi-cephfs-secret
stringData:
  userID: cephfs-k8s
  userKey: AQByw81hKgkLFBAAZYGEGFmsEU4+nAJ6C3OVAg==
  adminID: admin
  adminKey: AQC547hhOMaVHBAAHO7PzxKp8mfgPkMToTKJ1w==
EOF
$ kubectl apply -n ceph-csi -f templates/ceph-csi-cephfs/csi-cephfs-secret.yaml
```

#### CONFIGURE CEPH-CSI PLUGINS

```bash
$ wget -O templates/ceph-csi-cephfs/csi-provisioner-rbac.yaml https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/cephfs/kubernetes/csi-provisioner-rbac.yaml
$ sed -i "s/namespace: default/namespace: ceph-csi/g" templates/ceph-csi-cephfs/csi-provisioner-rbac.yaml

$ wget -O templates/ceph-csi-cephfs/csi-nodeplugin-rbac.yaml https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/cephfs/kubernetes/csi-nodeplugin-rbac.yaml
$ sed -i "s/namespace: default/namespace: ceph-csi/g" templates/ceph-csi-cephfs/csi-nodeplugin-rbac.yaml

$ kubectl create -n ceph-csi -f templates/ceph-csi-cephfs/csi-provisioner-rbac.yaml
$ kubectl create -n ceph-csi -f templates/ceph-csi-cephfs/csi-nodeplugin-rbac.yaml
```

```bash
$ wget -O templates/ceph-csi-cephfs/csi-cephfsplugin-provisioner.yaml https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/cephfs/kubernetes/csi-cephfsplugin-provisioner.yaml
$ sed -i "s/namespace: default/namespace: ceph-csi/g" templates/ceph-csi-cephfs/csi-cephfsplugin-provisioner.yaml
$ sed -i "s/k8s.gcr.io\/sig-storage/registry.cn-hangzhou.aliyuncs.com\/google_containers/g" templates/ceph-csi-cephfs/csi-cephfsplugin-provisioner.yaml

$ wget -O templates/ceph-csi-cephfs/csi-cephfsplugin.yaml https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/cephfs/kubernetes/csi-cephfsplugin.yaml
$ sed -i "s/namespace: default/namespace: ceph-csi/g" templates/ceph-csi-cephfs/csi-cephfsplugin.yaml
$ sed -i "s/k8s.gcr.io\/sig-storage/registry.cn-hangzhou.aliyuncs.com\/google_containers/g" templates/ceph-csi-cephfs/csi-cephfsplugin.yaml

$ kubectl apply -n ceph-csi -f templates/ceph-csi-cephfs/csi-cephfsplugin-provisioner.yaml
$ kubectl apply -n ceph-csi -f templates/ceph-csi-cephfs/csi-cephfsplugin.yaml
```

检查替换后的镜像

```bash
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/csi-provisioner:v3.0.0
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/csi-snapshotter:v4.2.0
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/csi-attacher:v3.3.0
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/csi-resizer:v1.3.0
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/csi-node-driver-registrar:v2.3.0
```

### USING CEPH BLOCK DEVICES

#### CREATE A STORAGECLASS

```bash
$ kubectl delete storageclasses.storage.k8s.io cephfs

$ cat <<EOF | kubectl create -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: cephfs
  namespace: ceph-csi
provisioner: cephfs.csi.ceph.com
parameters:
  clusterID: 3a5cad60-a648-48aa-a281-21795b69d6b3
  fsName: k8s
  csi.storage.k8s.io/provisioner-secret-name: csi-cephfs-secret
  csi.storage.k8s.io/provisioner-secret-namespace: ceph-csi
  csi.storage.k8s.io/controller-expand-secret-name: csi-cephfs-secret
  csi.storage.k8s.io/controller-expand-secret-namespace: ceph-csi
  csi.storage.k8s.io/node-stage-secret-name: csi-cephfs-secret
  csi.storage.k8s.io/node-stage-secret-namespace: ceph-csi
reclaimPolicy: Delete
allowVolumeExpansion: true
mountOptions:
  - discard
EOF

$ kubectl get sc -A
```