## 准备通用环境

#### 创建新用户`deploy`

在创建新用户前，你只需要有任意一个用户可以免登到对应的服务器上即可。

```bash
$ ansible-playbook -i hosts -c paramiko --ask-pass --ask-become-pass user-deploy.yml -v

$ ansible -i hosts all -m ping -u deploy
```


```bash
$ ansible-playbook -i hosts k8s-deploy.yml -u deploy -v
```


#### 批量设置免登

```bash
$ for h in k8s-master01 k8s-master02 k8s-master03; do ssh-copy-id -i ~/.ssh/id_rsa.pub james@$h; done
```


#### ETCD

ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health

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