

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

#### 小型集群

小型集群是指可以服务于不超过100个客户端，请求数小于200个/秒，同时存储的数据不超过100MB的etcd集群。

以下示例是50节点的Kubernetes集群：

| 供应商        | 类型           | vCPUS  | 内存（GB）        | 最大并行IOPS      | 磁盘带宽（MB/s）  |
| ------------- |-------------| -----| ------------- |-------------| ----- |
| AWS             | m4.large     | 2     | 8                | 3600         | 56.25 |
| GCE             | n1-standard-1+50GB PD SSD | 2        | 7.5      | 1500 | 25 |

#### 中型集群
中型集群是指可以服务于不超过500个客户端，请求数小于1000个/秒，同时存储数据不超过500MB的etcd集群。
以下示例是250节点的Kubernetes集群：

| 供应商        | 类型           | vCPUS  | 内存（GB）        | 最大并行IOPS      | 磁盘带宽（MB/s）  |
| ------------- |-------------| -----| ------------- |-------------| ----- |
| AWS      | m4.xlarge           | 4    |          16      | 6000          | 93.75 |
| GCE      | n1-standard-4+150GB PD SSD |            5  | 15        | 4500 | 75 |

#### 大型集群

大型集群是指可以服务于不超过1500个客户端，请求数小于10000个/秒，同时存储数据不超过1GB的etcd集群。
以下示例是1000节点的Kubernetes集群：

| 供应商        | 类型           | vCPUS  | 内存（GB）        | 最大并行IOPS      | 磁盘带宽（MB/s）  |
| ------------- |-------------| -----| ------------- |-------------| ----- |
| AWS      | m4.2xlarge         | 8      | 32              | 8000         | 125    |
| GCE      | n1-standard-8+250GB PD SSD | 8     | 30    | 7500         | 125    |

#### 超大型集群
超大型集群是指可以服务于超过1500个客户端，请求数超过10000个/秒，存储数据可以超过1GB的etcd集群。
以下示例是3000节点的Kubernetes集群：

| 供应商        | 类型           | vCPUS  | 内存（GB）        | 最大并行IOPS      | 磁盘带宽（MB/s）  |
| ------------- |-------------| -----| ------------- |-------------| ----- |
| AWS      | m4.4xlarge          | 16   | 64               | 16000        | 250    |
| GCE      | n1-standard-16+500GB PD SSD | 16 | 60     | 15000        | 250


```bash
$ etcdctl cluster-health

$ ETCDCTL_API=3 etcdctl endpoint health
```

#### 快照备份
```bash
etcdctl snapshot save backup.db
etcdctl --write-out=table snapshot status backup.db
```

```bash
$ etcd --version
$ ETCDCTL_API=3 etcdctl version
$ ETCDCTL_API=3 etcdctl endpoint health
```


