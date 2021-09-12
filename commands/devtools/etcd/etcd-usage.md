

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


