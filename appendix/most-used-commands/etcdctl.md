```bash
$ echo '/sg/test/shopeepaybase-idmaker' | base64
$ echo '/sg/test/shopeepaybase-idmakes' | base64
$ curl -L http://10.143.215.171:2379/v3/kv/range \
  -X POST -d '{"key": "L3NnL3Rlc3Qvc2hvcGVlcGF5YmFzZS1pZG1ha2VyCg==", "range_end": "L3NnL3Rlc3Qvc2hvcGVlcGF5YmFzZS1pZG1ha2VzCg=="}'
```







```bash
$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --endpoints=http://127.0.0.1:2379 endpoint health
$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=http://127.0.0.1:2379 endpoint health

$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health

$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/kubernetes/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health
```

#### 快照备份
```bash
etcdctl snapshot save backup.db
etcdctl --write-out=table snapshot status backup.db
```

#### Install Guide

```bash
etcd --name infra0 --initial-advertise-peer-urls http://127.0.0.1:2380 \
    --listen-peer-urls http://127.0.0.1:2380 \
    --listen-client-urls http://127.0.0.1:2379 \
    --advertise-client-urls http://127.0.0.1:2379 \
    --initial-cluster-token etcd-cluster-1 \
    --initial-cluster infra0=http://127.0.0.1:2380, infra1=http://127.0.0.1:2382, infra2=http://127.0.0.1:2384 \ 
    --initial-cluster-state new 

etcd --name infra1 --initial-advertise-peer-urls http://127.0.0.1:2382 \
    --listen-peer-urls http://127.0.0.1:2382 \
    --listen-client-urls http://127.0.0.1:2381 \
    --advertise-client-urls http://127.0.0.1:2381 \
    --initial-cluster-token etcd-cluster-1 \
    --initial-cluster infra0=http://127.0.0.1:2380, infra1=http://127.0.0.1:2382, infra2=http://127.0.0.1:2384 \
    --initial-cluster-state new
    
etcd --name infra2 --initial-advertise-peer-urls http://127.0.0.1:2384 \
    --listen-peer-urls http://127.0.0.1:2384 \
    --listen-client-urls http://127.0.0.1:2383 \
    --advertise-client-urls http://127.0.0.1:2383 \
    --initial-cluster-token etcd-cluster-1 \
    --initial-cluster infra0=http://127.0.0.1:2380, infra1=http://127.0.0.1:2382, infra2=http://127.0.0.1:2384 \
    --initial-cluster-state new
```

- --name: etcd集群中的节点名称，在同一个集群中必须是唯一的。
- --listen-peer-urls：用于集群内各个节点之间通信的 URL 地址，每个节点可以监听多个URL地址，集群内部将通过这些URL地址进行数据交互，例如，Leader节点的选举、Message消息传输或是快照传输等。
- --initial-advertise-peer-urls：建议用于集群内部节点之间交互的URL地址，节点间将以该值进行通信。
- --listen-client-urls：用于当前节点与客户端交互的URL地址，每个节点同样可以向客户端提供多个URL地址。
- --advertise-client-urls：建议客户端使用的URL地址，该值用于etcd代理或etcd成员与etcd节点通信。
- --initial-cluster-token etcd-cluster-1：集群的唯一标识。
- --initial-cluster：集群中所有的initial-advertise-peer-urls 的合集。
- --initial-cluster-state new：新建集群的标识

```bash
$ etcdctl cluster-health

$ ETCDCTL_API=3 etcdctl endpoint health
```

```bash
$ etcd --version
$ ETCDCTL_API=3 etcdctl version
$ ETCDCTL_API=3 etcdctl endpoint health
```


#### ETCD

```bash
ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379 endpoint health

ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health

ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=http://192.168.1.61:2379,http://192.168.1.62:2379,http://192.168.1.63:2379 endpoint health


$ curl --cacert /etc/etcd/ssl/ca.pem --cert /etc/etcd/ssl/etcd.pem --key /etc/etcd/ssl/etcd-key.pem https://192.168.1.61:2379/health
$ curl --cacert /etc/etcd/ssl/ca.pem --cert /etc/etcd/ssl/etcd.pem --key /etc/etcd/ssl/etcd-key.pem https://127.0.0.1:2379/health
```

- 数据存储的路径:
  ETCD_DATA_DIR="/data/app/etcd/"
- 监听的用于节点之间通信的url，可监听多个，集群内部将通过这些url进行数据交互(如选举，数据同步等):
  ETCD_LISTEN_PEER_URLS="http://172.16.0.8:2380"
- 监听的用于客户端通信的url，同样可以监听多个
  ETCD_LISTEN_CLIENT_URLS="http://127.0.0.1:2379,http://172.16.0.8:2379"
- etcd集群中的节点名，这里可以随意，可区分且不重复就行
  ETCD_NAME="etcd-0-8"
- 用于节点之间通信的url，节点间将以该值进行通信。
  ETCD_INITIAL_ADVERTISE_PEER_URLS="http://172.16.0.8:2380"
- 使用的客户端通信 url，该值用于 etcd 代理或 etcd 成员与 etcd 节点通信。
  ETCD_ADVERTISE_CLIENT_URLS="http://127.0.0.1:2379,http://172.16.0.8:2379"
- 集群中所有的 initial-advertise-peer-urls 的合集
  ETCD_INITIAL_CLUSTER="etcd-0-8=http://172.16.0.8:2380,etcd-0-17=http://172.16.0.17:2380,etcd-0-14=http://172.16.0.14:2380"
- 节点的 token 值，设置该值后集群将生成唯一 id，并为每个节点也生成唯一 id，当使用相同配置文件再启动一个集群时，只要该 token 值不一样，etcd 集群就不会相互影响。
  ETCD_INITIAL_CLUSTER_TOKEN="etcd-token"
- 新建集群的标志
  ETCD_INITIAL_CLUSTER_STATE="new"
- 心跳超时时间
  ETCD_HEARTBEAT_INTERVAL="1000"
- 选举超时时间
  ETCD_ELECTION_TIMEOUT="5000"

###### 172.20.120.11

```conf
#[Member]
ETCD_NAME="etcd1"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://172.20.120.11:2380"
ETCD_LISTEN_CLIENT_URLS="https://172.20.120.11:2379,http://127.0.0.1:2379"

#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://172.20.120.11:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://172.20.120.11:2379"
ETCD_INITIAL_CLUSTER="etcd1=https://172.20.120.11:2380,etcd2=https://172.20.120.12:2380,etcd3=https://172.20.120.13:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
```

###### 172.20.120.12

```conf
#[Member]
ETCD_NAME="etcd2"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://172.20.120.12:2380"
ETCD_LISTEN_CLIENT_URLS="https://172.20.120.12:2379,http://127.0.0.1:2379"

#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://172.20.120.12:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://172.20.120.12:2379"
ETCD_INITIAL_CLUSTER="etcd1=https://172.20.120.11:2380,etcd2=https://172.20.120.12:2380,etcd3=https://172.20.120.13:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
```

###### 172.20.120.13

```conf
#[Member]
ETCD_NAME="etcd3"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://172.20.120.13:2380"
ETCD_LISTEN_CLIENT_URLS="https://172.20.120.13:2379,http://127.0.0.1:2379"

#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://172.20.120.13:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://172.20.120.13:2379"
ETCD_INITIAL_CLUSTER="etcd1=https://172.20.120.11:2380,etcd2=https://172.20.120.12:2380,etcd3=https://172.20.120.13:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
```