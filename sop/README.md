# 手动操作`SOP`

## 准备工作

```bash
$ gem install sshkit
$ gem install sshkit-sudo

$ gem install ed25519
$ gem install bcrypt_pbkdf
```

## 初始化新`K8S Worker`节点

创建新用户`deploy`

```bash
$ ./awesome user k8s-node003 deploy
$ ./awesome user k8s-node004 deploy
$ ./awesome user k8s-node008 deploy
$ ./awesome user k8s-node009 deploy
```

基础配置

```bash
$ ./awesome setup k8s-node003 deploy
$ ./awesome setup k8s-node004 deploy
$ ./awesome setup k8s-node008 deploy
$ ./awesome setup k8s-node009 deploy
```

`ntp`配置

```bash
$ ./awesome ntp k8s-node003 deploy
$ ./awesome ntp k8s-node004 deploy
$ ./awesome ntp k8s-node008 deploy
$ ./awesome ntp k8s-node009 deploy
```

内核优化

```bash
$ ./awesome kernel k8s-node003 deploy
$ ./awesome kernel k8s-node004 deploy
$ ./awesome kernel k8s-node008 deploy
$ ./awesome kernel k8s-node009 deploy
```

安装`docker`

```bash
$ ./awesome docker k8s-node003 deploy
$ ./awesome docker k8s-node004 deploy
$ ./awesome docker k8s-node008 deploy
$ ./awesome docker k8s-node009 deploy
$ ./awesome docker ubuntu-desktop.local james
$ ./awesome docker code-server.local james
```

安装`kubernetes`

```bash
$ ./awesome k8s k8s-node003 deploy --role=worker --kube_proxy_mode=ipvs --cluster_cidr=10.244.0.0/16 --dnsip=192.168.1.130
$ ./awesome k8s k8s-node004 deploy --role=worker --kube_proxy_mode=ipvs --cluster_cidr=10.244.0.0/16 --dnsip=192.168.1.130
$ ./awesome k8s k8s-node008 deploy --role=worker --kube_proxy_mode=ipvs --cluster_cidr=10.244.0.0/16 --dnsip=192.168.1.130
$ ./awesome k8s k8s-node009 deploy --role=worker --kube_proxy_mode=ipvs --cluster_cidr=10.244.0.0/16 --dnsip=192.168.1.130

# 接受新加入节点申请
$ kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approve
```