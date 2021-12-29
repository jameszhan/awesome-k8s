## TL;DR

## Deploy Ceph CSI

![Kubernetes/Ceph Technology Stack](https://gallery.zizhizhan.com:8443/images/virt/ceph-csi.png)

### CREATE A POOL

```bash
$ ceph osd pool create kubernetes
$ rbd pool init kubernetes
```

### CONFIGURE CEPH-CSI

#### SETUP CEPH CLIENT AUTHENTICATION

```bash
$ ceph auth get-or-create client.kubernetes mon 'profile rbd' osd 'profile rbd pool=kubernetes' mgr 'profile rbd pool=kubernetes'
[client.kubernetes]
	key = AQBsYLlh4ulcIhAA5bL+z02iz1zr7qTL8JZ9wQ==
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
$ cat <<EOF > templates/ceph-csi/csi-rbd-secret.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: csi-rbd-secret
stringData:
  userID: kubernetes
  userKey: AQBsYLlh4ulcIhAA5bL+z02iz1zr7qTL8JZ9wQ==
EOF
$ kubectl apply -n ceph-csi -f templates/ceph-csi/csi-rbd-secret.yaml
```

#### CONFIGURE CEPH-CSI PLUGINS

```bash
$ wget -O templates/ceph-csi/csi-provisioner-rbac.yaml https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-provisioner-rbac.yaml
$ sed -i "s/namespace: default/namespace: ceph-csi/g" templates/ceph-csi/csi-provisioner-rbac.yaml

$ wget -O templates/ceph-csi/csi-nodeplugin-rbac.yaml https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-nodeplugin-rbac.yaml
$ sed -i "s/namespace: default/namespace: ceph-csi/g" templates/ceph-csi/csi-nodeplugin-rbac.yaml

$ kubectl apply -n ceph-csi -f templates/ceph-csi/csi-provisioner-rbac.yaml
$ kubectl apply -n ceph-csi -f templates/ceph-csi/csi-nodeplugin-rbac.yaml
```

```bash
$ wget -O templates/ceph-csi/csi-rbdplugin-provisioner.yaml https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin-provisioner.yaml
$ sed -i "s/namespace: default/namespace: ceph-csi/g" templates/ceph-csi/csi-rbdplugin-provisioner.yaml
$ sed -i "s/k8s.gcr.io\/sig-storage/registry.cn-hangzhou.aliyuncs.com\/google_containers/g" templates/ceph-csi/csi-rbdplugin-provisioner.yaml

$ wget -O templates/ceph-csi/csi-rbdplugin.yaml https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin.yaml
$ sed -i "s/namespace: default/namespace: ceph-csi/g" templates/ceph-csi/csi-rbdplugin.yaml
$ sed -i "s/k8s.gcr.io\/sig-storage/registry.cn-hangzhou.aliyuncs.com\/google_containers/g" templates/ceph-csi/csi-rbdplugin.yaml

$ kubectl apply -n ceph-csi -f templates/ceph-csi/csi-rbdplugin-provisioner.yaml
$ kubectl apply -n ceph-csi -f templates/ceph-csi/csi-rbdplugin.yaml
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
$ kubectl delete storageclasses.storage.k8s.io ceph-rbd

$ cat <<EOF | kubectl create -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
   name: ceph-rbd
   namespace: ceph-csi
provisioner: rbd.csi.ceph.com
parameters:
   clusterID: 3a5cad60-a648-48aa-a281-21795b69d6b3
   pool: kubernetes
   imageFeatures: layering
   csi.storage.k8s.io/provisioner-secret-name: csi-rbd-secret
   csi.storage.k8s.io/provisioner-secret-namespace: ceph-csi
   csi.storage.k8s.io/controller-expand-secret-name: csi-rbd-secret
   csi.storage.k8s.io/controller-expand-secret-namespace: ceph-csi
   csi.storage.k8s.io/node-stage-secret-name: csi-rbd-secret
   csi.storage.k8s.io/node-stage-secret-namespace: ceph-csi
reclaimPolicy: Delete
allowVolumeExpansion: true
mountOptions:
   - discard
EOF

$ kubectl get sc -A
```