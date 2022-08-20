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
$ ./awesome user k8s-node013 deploy
```

基础配置

```bash
$ ./awesome setup k8s-node003 deploy
$ ./awesome setup k8s-node004 deploy
$ ./awesome setup k8s-node008 deploy
$ ./awesome setup k8s-node009 deploy
$ ./awesome setup k8s-node013 deploy
```

`ntp`配置

```bash
$ ./awesome ntp k8s-node003 deploy
$ ./awesome ntp k8s-node004 deploy
$ ./awesome ntp k8s-node008 deploy
$ ./awesome ntp k8s-node009 deploy
$ ./awesome ntp k8s-node013 deploy
```

内核优化

```bash
$ ./awesome kernel k8s-node003 deploy
$ ./awesome kernel k8s-node004 deploy
$ ./awesome kernel k8s-node008 deploy
$ ./awesome kernel k8s-node009 deploy
$ ./awesome kernel k8s-node013 deploy
```

安装`docker`

```bash
$ ./awesome docker k8s-node003 deploy
$ ./awesome docker k8s-node004 deploy
$ ./awesome docker k8s-node008 deploy
$ ./awesome docker k8s-node009 deploy
$ ./awesome docker k8s-node013 deploy
$ ./awesome docker ubuntu-desktop.local james
$ ./awesome docker code-server.local james --daemon_json=false
```

安装`kubernetes`

```bash
$ ./awesome k8s k8s-node003 deploy --role=worker --kube_proxy_mode=ipvs --cluster_cidr=10.244.0.0/16 --dnsip=192.168.1.130
$ ./awesome k8s k8s-node004 deploy --role=worker --kube_proxy_mode=ipvs --cluster_cidr=10.244.0.0/16 --dnsip=192.168.1.130
$ ./awesome k8s k8s-node008 deploy --role=worker --kube_proxy_mode=ipvs --cluster_cidr=10.244.0.0/16 --dnsip=192.168.1.130
$ ./awesome k8s k8s-node009 deploy --role=worker --kube_proxy_mode=ipvs --cluster_cidr=10.244.0.0/16 --dnsip=192.168.1.130
$ ./awesome k8s k8s-node013 deploy --role=worker --kube_proxy_mode=ipvs --cluster_cidr=10.244.0.0/16 --dnsip=192.168.1.130

# 接受新加入节点申请
$ kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approve
```

升级`kubernetes`

```bash
$ ./awesome upgrade k8s-node001 deploy --role=worker --version=1.23.1
$ ./awesome upgrade k8s-node002 deploy --role=worker --version=1.23.1
$ ./awesome upgrade k8s-node003 deploy --role=worker --version=1.23.1
$ ./awesome upgrade k8s-node004 deploy --role=worker --version=1.23.1
$ ./awesome upgrade k8s-node005 deploy --role=worker --version=1.23.1
$ ./awesome upgrade k8s-node006 deploy --role=worker --version=1.23.1
$ ./awesome upgrade k8s-node007 deploy --role=worker --version=1.23.1
$ ./awesome upgrade k8s-node008 deploy --role=worker --version=1.23.1
$ ./awesome upgrade k8s-node009 deploy --role=worker --version=1.23.1
$ cd install-binaries/ansible && ansible -i hosts k8s_nodes -m reboot -u deploy --become -v && cd ../../

$ ./awesome upgrade k8s-master03 deploy --role=master --version=1.23.1
$ ./awesome upgrade k8s-master02 deploy --role=master --version=1.23.1
$ ./awesome upgrade k8s-master01 deploy --role=master --version=1.23.1
$ cd install-binaries/ansible && ansible -i hosts k8s_masters -m script -a "/opt/bin/update-system.sh" -u deploy -v && cd ../../
$ cd install-binaries/ansible && ansible -i hosts k8s_masters -m reboot -u deploy --become -v && cd ../../
```

安装附件软件

```bash
$ ./awesome addons k8s-node003 deploy
$ ./awesome addons k8s-node004 deploy
$ ./awesome addons k8s-node008 deploy
$ ./awesome addons k8s-node009 deploy
$ ./awesome addons k8s-node013 deploy
```

## 安装`microk8s`

```bash
$ ./awesome microk8s ubuntu-desktop.local james --channel=1.23/stable
```

## 安装`kubeadm`

```bash
$ ./awesome docker ubuntu-kubeadm.local james --daemon_json=false
$ ./awesome kubeadm ubuntu-kubeadm.local james --role=master
```

## 清理工作

### 卸载`Docker`

```bash
$ sudo apt purge docker-ce docker-ce-cli containerd.io
$ sudo rm -rf /var/lib/docker
$ sudo rm -rf /var/lib/containerd
```