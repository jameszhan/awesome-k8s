### Install Ansible

```bash
$ python -m ensurepip
$ python -m pip install -v --upgrade ansible
$ ansible --version
```

### Install kubectl and helm

#### 基于`Linux`

> 本文只演示`x86_64`二进制版本的安装，其他版本详细安装过程可以参考:
- [Install kubectl Tools](https://kubernetes.io/zh/docs/tasks/tools/)
- [Installing Helm](https://helm.sh/docs/intro/install/)

```bash
$ cd /usr/local/bin
# 客户端版本安装最新版本即可，不需要严格和集群版本保持一致
$ sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
$ sudo chmod +x /usr/local/bin/kubectl
$ kubectl version

# 这个步骤可以等集群部署好了再做
$ mkdir ~/.kube
$ scp deploy@k8s-master01:~/.kube/config ~/.kube/config


$ wget https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz
$ tar -zxvf helm-v3.7.0-linux-amd64.tar.gz
$ sudo cp linux-amd64/helm /usr/local/bin
$ helm version
```

#### 基于`macOS`

```bash
$ brew install kubernetes-cli
$ brew install helm
```
