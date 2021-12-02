## TL;DR



## Deploy Ceph CSI

![Kubernetes/Ceph Technology Stack](https://gallery.zizhizhan.com:8443/images/k8s/ceph-csi.png)

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
	key = AQBI2ahhip1rAxAASf9dezG2u5oFCkAXSHdk3g==
```

#### GENERATE CEPH-CSI CONFIGMAP

```bash
$ ceph mon dump
epoch 1
fsid 2d72a497-00cc-4c20-979c-39bebaf20e70
<...>
0: [v2:192.168.1.50:3300/0,v1:192.168.1.50:6789/0] mon.pve-5900hx
1: [v2:192.168.1.60:3300/0,v1:192.168.1.60:6789/0] mon.pve-5700u
```

> ceph-csi currently only supports the legacy V1 protocol.

```bash
$ cat <<EOF > templates/csi-config-map.yaml
---
apiVersion: v1
kind: ConfigMap
data:
  config.json: |-
    [
      {
        "clusterID": "2d72a497-00cc-4c20-979c-39bebaf20e70",
        "monitors": [
          "192.168.1.50:6789",
          "192.168.1.60:6789"
        ]
      }
    ]
metadata:
  name: ceph-csi-config
  namespace: kube-system
EOF

$ cat <<EOF > templates/csi-kms-config-map.yaml
---
apiVersion: v1
kind: ConfigMap
data:
  config.json: |-
    {}
metadata:
  name: ceph-csi-encryption-kms-config
  namespace: kube-system
EOF

$ cat <<EOF > templates/ceph-config-map.yaml
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
  namespace: kube-system
EOF
```

```bash

```

#### GENERATE CEPH-CSI CEPHX SECRET

```bash
$ cat <<EOF > csi-rbd-secret.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: csi-rbd-secret
  namespace: kube-system
stringData:
  userID: kubernetes
  userKey: AQBI2ahhip1rAxAASf9dezG2u5oFCkAXSHdk3g==
EOF
```

#### CONFIGURE CEPH-CSI PLUGINS

```bash
$ kubectl apply -f https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-provisioner-rbac.yaml
$ kubectl apply -f https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-nodeplugin-rbac.yaml

$ wget https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin-provisioner.yaml
$ kubectl apply -f csi-rbdplugin-provisioner.yaml
$ wget https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin.yaml
$ kubectl apply -f csi-rbdplugin.yaml
```