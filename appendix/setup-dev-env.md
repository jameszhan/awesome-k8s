### Install Ansible

```bash
$ python -m ensurepip
$ python -m pip install -v --upgrade ansible
$ ansible --version
```

### Install kubectl and helm

#### 基于`Linux`

> 二进制安装`kubectl`和`helm`，详细安装过程可以参考:

- [Install kubectl Tools](https://kubernetes.io/zh/docs/tasks/tools/)
- [Installing Helm](https://helm.sh/docs/intro/install/)

```bash
$ wget https://storage.googleapis.com/kubernetes-release/release/v1.21.4/kubernetes-server-linux-amd64.tar.gz
$ tar -zxvf kubernetes-server-linux-amd64.tar.gz
$ sudo cp kubernetes/server/bin/kubectl /usr/local/bin

# 这个步骤可以等集群部署好了再做
$ mkdir ~/.kube
$ scp deploy@k8s-master01:~/.kube/config ~/.kube/config
```

#### 基于`macOS`

```bash
$ brew install kubernetes-cli
$ brew install helm
```
